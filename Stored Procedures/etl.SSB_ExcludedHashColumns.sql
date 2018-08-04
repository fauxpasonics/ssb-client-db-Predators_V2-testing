SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*****		Revision History

DCH on 2017-09-26:		Initial sproc creation.  Purpose is to create a string of columns... mostly ETL_... to be excluded from the hashkey build in etl.SSB_MergeHashFieldSyntax.


*****/


CREATE   PROCEDURE [etl].[SSB_ExcludedHashColumns]
(
	@Source			NVARCHAR(255),
	@AddlColumns	NVARCHAR(255) = NULL
)  
AS
BEGIN 
	DECLARE @ExcludedColumns		NVARCHAR(255),
			@SourceSchema			NVARCHAR(255),
			@SourceTable			NVARCHAR(255),
			@tmp_ExcludedColumns	NVARCHAR(255),
			@loopcounter			INT,
			@maxloop				INT;


	SET @SourceSchema =	(SELECT LEFT(@Source, CHARINDEX('.',@Source)-1));
	SET @SourceTable =	(SELECT SUBSTRING(@Source, CHARINDEX('.',@Source)+1, LEN(@Source)));


	SELECT c.name AS columnName, ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY c.column_id) AS rownum
	INTO #columns
	FROM sys.tables t
	JOIN sys.schemas s
		ON t.schema_id = s.schema_id
		AND s.name = @SourceSchema
	JOIN sys.columns c
		ON t.object_id = c.object_id
		AND t.name = @SourceTable
		AND LEFT(c.name,4) = 'ETL_';


	SET @maxloop = (SELECT ISNULL(MAX(rownum),0) FROM #columns);
	SET @loopcounter = 1;


	WHILE @loopcounter <= @maxloop
	BEGIN
		SET @tmp_ExcludedColumns = (SELECT CASE WHEN @loopcounter = 1 THEN columnName ELSE CONCAT(@tmp_ExcludedColumns,',',columnName) END FROM #columns WHERE rownum = @loopcounter);
		
		SET @loopcounter = @loopcounter+1;
	END 


	SET @ExcludedColumns = (SELECT CASE WHEN ISNULL(@AddlColumns,'') = '' THEN @tmp_ExcludedColumns ELSE CONCAT(@tmp_ExcludedColumns,',',@AddlColumns) END);


	SELECT @ExcludedColumns; 
END

GO
