SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE VIEW [prodcopy].[xvw_Account] AS 
						---- CREATED BY PROCESS ON Oct  3 2016  7:50PM
						Select * from ProdCopy.Account Where 1=1 and statecode = 0 and merged = 0
GO
