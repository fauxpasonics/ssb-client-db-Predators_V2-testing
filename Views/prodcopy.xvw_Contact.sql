SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE VIEW [prodcopy].[xvw_Contact] AS 
						---- CREATED BY PROCESS ON Oct  3 2016  8:08PM
						Select * from ProdCopy.Contact Where 1=1 and statecode = 0 and merged = 0
GO
