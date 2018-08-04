SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN


-- CRM Account
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Predators', @LoadView = 'etl.vw_Load_DimCustomer_DynamicsAccout', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- CRM Contact
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Predators', @LoadView = 'etl.vw_Load_DimCustomer_DynamicsContacts', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Fanmaker
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Predators', @LoadView = 'etl.vw_Load_DimCustomer_FanMaker', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- TM
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Predators', @LoadView = 'etl.vw_Load_DimCustomer_TM', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Emma
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Predators', @LoadView = 'etl.vw_Load_DimCustomer_Emma', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'



END

GO
