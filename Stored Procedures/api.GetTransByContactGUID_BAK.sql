SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [api].[GetTransByContactGUID_BAK]
    (
      @ContactGUID VARCHAR(50)
    , @RowsPerPage INT = 500
    , --APIification
      @PageNumber INT = 0 --APIification
    )
AS
    BEGIN

-- =========================================
-- Initial Variables for API
-- =========================================

        DECLARE @totalCount INT
          , @xmlDataNode XML
          , @recordsInResponse INT
          , @remainingCount INT
          , @rootNodeName NVARCHAR(100)
          , @responseInfoNode NVARCHAR(MAX)
          , @finalXml XML;

-- =========================================
-- Base Table Set
-- =========================================


        DECLARE @baseData TABLE
            (
              Team NVARCHAR(255)
            , Season NVARCHAR(255)
            , SeasonName NVARCHAR(255)
            , OrderNumber NVARCHAR(255)
            , OrderLine NVARCHAR(255)
            , Account NVARCHAR(255)
            , OrderDate DATE
            , Item NVARCHAR(255)
            , ItemName NVARCHAR(255)
            , ItemClass NVARCHAR(255)
            , ItemClassName NVARCHAR(255)
            , PriceType NVARCHAR(255)
            , Class NVARCHAR(255)
            , ClassName NVARCHAR(255)
            , IsComp BIT
            , PriceLevel NVARCHAR(255)
            , PromoCode NVARCHAR(255)
            , Qty INT
            , SeatPrice DECIMAL(18, 6)
            , Total DECIMAL(18, 6)
            , SeatBlock NVARCHAR(255)
            , AmountOwed DECIMAL(18, 6)
            , AmountPaid DECIMAL(18, 6)
            , LedgerCode NVARCHAR(255)
            , PriceCode NVARCHAR(255)
            , RepCode NVARCHAR(255)
            , RepName NVARCHAR(255)
            , PlanEventName NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


        DECLARE @ArchticsIDs TABLE
            (
              ArchticsIDs VARCHAR(50)
            );

        INSERT  INTO @ArchticsIDs
                (
                  [ArchticsIDs]
                )
        SELECT  vdcmai.AccountId
        FROM    dbo.vwDimCustomer_ModAcctId AS vdcmai
        WHERE   vdcmai.SSB_CRMSYSTEM_CONTACT_ID IN ( @ContactGUID );

        SELECT  dc.AccountId
              , f.DimItemId
              , f.DimEventId
              , f.DimPriceCodeMasterId
              , f.DimClassTMId
              , f.DimPromoId
              , f.IsComp
              , f.DimCustomerIdSalesRep
              , f.DimLedgerId
              , dst.SectionName
              , dst.RowName
              , dst.Seat StartSeat
              , f.OrderNum
              , f.OrderLineItem
              , f.DimDateId
              , f.QtySeat
              , f.BlockPurchasePrice
              , ROW_NUMBER() OVER ( PARTITION BY f.DimCustomerId, f.DimItemId,
                                    f.DimEventId, f.DimPriceCodeMasterId,
                                    f.DimClassTMId, f.DimPromoId, f.IsComp,
                                    f.DimCustomerIdSalesRep, f.DimLedgerId,
                                    dst.SectionName, dst.RowName ORDER BY dst.Seat ) AS RowRank
        INTO    #PlanSeatBlocks
        FROM    rpt.vw_FactTicketSales f
        INNER JOIN rpt.vw_DimDate dd ON dd.DimDateId = f.DimDateId
        INNER JOIN rpt.vw_DimSeat dst ON dst.DimSeatId = f.DimSeatIdStart
        INNER JOIN rpt.vw_DimCustomer dc WITH ( NOLOCK ) ON dc.DimCustomerId = f.DimCustomerId
        INNER JOIN rpt.vw_DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
        WHERE   f.DimPlanId > 0
--and ds.Cust_LoadSFDC = 1
                AND dd.CalDate >= DATEADD(YEAR, -2, GETDATE() - 90)
--AND CASE WHEN ds.Config_IsMultiYearSeason = 1 THEN dd.CalDate ELSE CAST('3000-01-01' AS DATE) END > dateadd(YEAR, -2, GETDATE())
                AND dc.AccountId IN ( SELECT    ArchticsIDs
                                      FROM      @ArchticsIDs );

        WITH    CTE_Plan ( AccountId, DimItemId, DimEventId, DimPriceCodeMasterId, DimClassTMId, DimPromoId, IsComp, DimCustomerIdSalesRep, DimLedgerId, SectionName, RowName, StartSeat, EndSeat, Level, Contiguous, BlockPurchasePrice, OrderNum, OrderLineItem, DimDateId )
                  AS (
                       SELECT   AccountId
                              , DimItemId
                              , DimEventId
                              , DimPriceCodeMasterId
                              , DimClassTMId
                              , DimPromoId
                              , IsComp
                              , DimCustomerIdSalesRep
                              , DimLedgerId
                              , SectionName
                              , RowName
                              , StartSeat
                              , ( StartSeat + QtySeat - 1 ) EndSeat
                              , 1 Level
                              , 1 Contiguous
                              , BlockPurchasePrice
                              , OrderNum
                              , OrderLineItem
                              , DimDateId
                       FROM     #PlanSeatBlocks
                       WHERE    1 = 1
                                AND RowRank = 1
                       UNION ALL
                       SELECT   a.AccountId
                              , a.DimItemId
                              , a.DimEventId
                              , a.DimPriceCodeMasterId
                              , a.DimClassTMId
                              , a.DimPromoId
                              , a.IsComp
                              , a.DimCustomerIdSalesRep
                              , a.DimLedgerId
                              , a.SectionName
                              , a.RowName
                              , CASE WHEN b.StartSeat = a.EndSeat + 1
                                     THEN a.StartSeat
                                     ELSE b.StartSeat
                                END StartSeat
                              , ( b.StartSeat + b.QtySeat - 1 ) EndSeat
                              , ( a.Level + 1 ) Level
                              , CASE WHEN b.StartSeat = a.EndSeat + 1 THEN 1
                                     ELSE 0
                                END Contiguous
                              , CAST(CASE WHEN b.StartSeat = a.EndSeat + 1
                                          THEN ( a.BlockPurchasePrice
                                                 + b.BlockPurchasePrice )
                                          ELSE b.BlockPurchasePrice
                                     END AS DECIMAL(18, 6)) StartSeat
	--, CAST((a.BlockPurchasePrice + b.BlockPurchasePrice) AS DECIMAL(18,6)) BlockPurchasePrice
                              , a.OrderNum
                              , a.OrderLineItem
                              , a.DimDateId
                       FROM     CTE_Plan a
                       INNER JOIN #PlanSeatBlocks b ON a.AccountId = b.AccountId
                                                       AND a.DimItemId = b.DimItemId
                                                       AND a.DimEventId = b.DimEventId
                                                       AND a.DimPriceCodeMasterId = b.DimPriceCodeMasterId
                                                       AND a.DimClassTMId = b.DimClassTMId
                                                       AND a.DimPromoId = b.DimPromoId
                                                       AND a.IsComp = b.IsComp
                                                       AND a.DimCustomerIdSalesRep = b.DimCustomerIdSalesRep
                                                       AND a.DimLedgerId = b.DimLedgerId
                                                       AND a.SectionName = b.SectionName
                                                       AND a.RowName = b.RowName
                       WHERE    b.RowRank = a.Level + 1
                     )
            SELECT  a.AccountId
                  , a.DimItemId
                  , a.DimEventId
                  , a.DimPriceCodeMasterId
                  , a.DimClassTMId
                  , a.DimPromoId
                  , a.IsComp
                  , a.DimCustomerIdSalesRep
                  , a.DimLedgerId
                  , a.SectionName
                  , a.RowName
                  , a.StartSeat
                  , a.EndSeat
                  , ( a.EndSeat - a.StartSeat + 1 ) QtySeat
                  , a.BlockPurchasePrice
                  , a.OrderNum
                  , a.OrderLineItem
                  , a.DimDateId
            INTO    #PlanEventOrders
            FROM    (
                      SELECT    *
                              , ROW_NUMBER() OVER ( PARTITION BY CTE_Plan.AccountId,
                                                    CTE_Plan.DimItemId,
                                                    CTE_Plan.DimEventId,
                                                    CTE_Plan.DimPriceCodeMasterId,
                                                    CTE_Plan.DimClassTMId,
                                                    CTE_Plan.DimPromoId,
                                                    CTE_Plan.IsComp,
                                                    CTE_Plan.DimCustomerIdSalesRep,
                                                    CTE_Plan.DimLedgerId,
                                                    CTE_Plan.SectionName,
                                                    CTE_Plan.RowName,
                                                    CTE_Plan.StartSeat ORDER BY CTE_Plan.Level DESC ) AS RowRank
                      FROM      CTE_Plan
                    ) a
            WHERE   a.RowRank = 1;




        SELECT  AccountId
              , DimItemId
              , DimPriceCodeMasterId
              , DimClassTMId
              , DimPromoId
              , IsComp
              , DimCustomerIdSalesRep
              , DimLedgerId
              , SectionName
              , RowName
              , StartSeat
              , EndSeat
              , QtySeat
              , SUM(BlockPurchasePrice) BlockPurchasePrice
              , COUNT(*) cnt
              , MIN(OrderNum) OrderNum
              , MIN(OrderLineItem) OrderLineItem
              , MIN(DimDateId) DimDateId
              , MIN(DimEventId) MinDimEventId
        INTO    #PlanOrders
        FROM    #PlanEventOrders
        GROUP BY AccountId
              , DimItemId
              , DimPriceCodeMasterId
              , DimClassTMId
              , DimPromoId
              , IsComp
              , DimCustomerIdSalesRep
              , DimLedgerId
              , SectionName
              , RowName
              , StartSeat
              , EndSeat
              , QtySeat;

        SELECT  *
        INTO    #Count
        FROM    (
                  SELECT    'Predators' Team
                          , ds.SeasonName Season
                          , ds.SeasonName
                          , f.OrderNum OrderNumber
                          , f.OrderLineItem OrderLine
                          , f.AccountId Account
                          , dd.CalDate OrderDate
                          , di.ItemCode
                          , di.ItemName
                          , di.ItemClass
                          , di.ItemClass ItemClassName
                          , ISNULL(dpcm.PC2, '') + ISNULL(dpcm.PC3, '')
                            + ISNULL(dpcm.PC4, '') PriceType
                          , dctm.ClassName Class
                          , dctm.ClassName ClassNae
                          , f.IsComp
                          , dpcm.PC1
                          , '' PromoCode
                          , f.QtySeat
                          , ( f.BlockPurchasePrice
                              / CAST(f.QtySeat AS DECIMAL(18, 6)) ) SeatPrice
                          , f.BlockPurchasePrice Total
                          , f.SectionName + ':' + f.RowName + ':'
                            + CONVERT(NVARCHAR, f.StartSeat) + ','
                            + CONVERT(NVARCHAR, f.EndSeat) SeatBlock
                          , CAST(0 AS DECIMAL(18, 2)) AmountOwed
                          , CAST(0 AS DECIMAL(18, 2)) AmountPaid
                          , dl.LedgerCode
                          , dpcm.PriceCode
                          , dc_rep.AccountId RepCode
                          , dc_rep.FirstName + ' ' + dc_rep.LastName RepName
                          , CASE WHEN f.cnt = 1 THEN de.EventName
                                 ELSE CONVERT(NVARCHAR, f.cnt) + ' Events'
                            END PlanEventName
                  FROM      #PlanOrders f
                  INNER JOIN rpt.vw_DimDate dd ON dd.DimDateId = f.DimDateId
                  INNER JOIN dbo.DimItem di ON di.DimItemId = f.DimItemId
                  INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = di.DimSeasonId
                  INNER JOIN dbo.DimPriceCodeMaster dpcm ON dpcm.DimPriceCodeMasterId = f.DimPriceCodeMasterId
                  INNER JOIN dbo.DimClassTM dctm ON dctm.DimClassTMId = f.DimClassTMId
                  INNER JOIN dbo.DimLedger dl ON dl.DimLedgerId = f.DimLedgerId
                  INNER JOIN dbo.DimCustomer dc_rep WITH ( NOLOCK ) ON dc_rep.DimCustomerId = f.DimCustomerIdSalesRep
                  INNER JOIN dbo.DimEvent de ON de.DimEventId = f.MinDimEventId
                  UNION ALL
                  SELECT    'Predators' Team
                          , ds.SeasonName Season
                          , ds.SeasonName
                          , f.OrderNum OrderNumber
                          , f.OrderLineItem OrderLine
                          , dc.AccountId Account
                          , dd.CalDate OrderDate
                          , di.ItemCode
                          , di.ItemName
                          , di.ItemClass
                          , di.ItemClass ItemClassName
                          , ISNULL(dpcm.PC2, '') + ISNULL(dpcm.PC3, '')
                            + ISNULL(dpcm.PC4, '') PriceType
                          , dctm.ClassName Class
                          , dctm.ClassName ClassNae
                          , f.IsComp
                          , dpcm.PC1
                          , '' PromoCode
                          , f.QtySeat
                          , ( f.BlockPurchasePrice
                              / CAST(f.QtySeat AS DECIMAL(18, 6)) ) SeatPrice
                          , f.BlockPurchasePrice Total
                          , dst.SectionName + ':' + dst.RowName + ':'
                            + CONVERT(NVARCHAR, dst.Seat) + ','
                            + CONVERT(NVARCHAR, ( dst.Seat + f.QtySeat )) SeatBlock
                          , CAST(0 AS DECIMAL(18, 2)) AmountOwed
                          , CAST(0 AS DECIMAL(18, 2)) AmountPaid
                          , dl.LedgerCode
                          , dpcm.PriceCode
                          , dc_rep.AccountId RepCode
                          , dc_rep.FirstName + ' ' + dc_rep.LastName RepName
                          , NULL PlanEventName
                  FROM      dbo.FactTicketSales f
                  INNER JOIN dbo.DimCustomer dc WITH ( NOLOCK ) ON dc.DimCustomerId = f.DimCustomerId
                  INNER JOIN dbo.DimDate dd ON dd.DimDateId = f.DimDateId
                  INNER JOIN dbo.DimItem di ON di.DimItemId = f.DimItemId
                  INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = di.DimSeasonId
                  INNER JOIN dbo.DimPriceCodeMaster dpcm ON dpcm.DimPriceCodeMasterId = f.DimPriceCodeMasterId
                  INNER JOIN dbo.DimClassTM dctm ON dctm.DimClassTMId = f.DimClassTMId
                  INNER JOIN dbo.DimLedger dl ON dl.DimLedgerId = f.DimLedgerId
                  INNER JOIN dbo.DimCustomer dc_rep WITH ( NOLOCK ) ON dc_rep.DimCustomerId = f.DimCustomerIdSalesRep
                  INNER JOIN dbo.DimSeat dst ON dst.DimSeatId = f.DimSeatIdStart
                  WHERE     f.DimPlanId <= 0
                            AND dd.CalDate >= DATEADD(YEAR, -2, GETDATE() - 90)
	--AND CASE WHEN ds.Config_IsMultiYearSeason = 1 THEN dd.CalDate ELSE CAST('3000-01-01' AS DATE) END > dateadd(YEAR, -2, GETDATE())
                            AND dc.AccountId IN ( SELECT    ArchticsIDs
                                                  FROM      @ArchticsIDs )
	--AND dc.AccountId = 2923914
                ) a
        ORDER BY a.OrderDate DESC;


-- =========================================
-- API Pagination
-- =========================================
-- Cap returned results at 1000

        IF @RowsPerPage > 1000
            BEGIN

                SET @RowsPerPage = 1000;

            END;

-- Pull total count

        SELECT  @totalCount = COUNT(*)
        FROM    #Count AS c;

-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
        SELECT  *
        FROM    #Count AS c
        ORDER BY c.OrderDate DESC
              , c.OrderNumber
              OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(Team, '') AS Team
                                  , ISNULL(Season, '') AS Season
                                  , ISNULL(SeasonName, '') AS SeasonName
                                  , ISNULL(OrderNumber, '') AS OrderNumber
                                  , ISNULL(OrderLine, '') AS OrderLine
                                  , ISNULL(Account, '') AS Account
                                  , ISNULL(OrderDate, '') AS OrderDate
                                  , ISNULL(Item, '') AS Item
                                  , ISNULL(ItemName, '') AS ItemName
                                  , ISNULL(ItemClass, '') AS ItemClass
                                  , ISNULL(ItemClassName, '') AS ItemClassName
                                  , ISNULL(PriceType, '') AS PriceType
                                  , ISNULL(Class, '') AS Class
                                  , ISNULL(ClassName, '') AS ClassName
                                  , ISNULL(IsComp, 0) AS IsComp
                                  , ISNULL(PriceLevel, '') AS PriceLevel
                                  , ISNULL(PromoCode, '') AS PromoCode
                                  , ISNULL(Qty, 0) AS Qty
                                  , ISNULL(SeatPrice, 0) AS SeatPrice
                                  , ISNULL(Total, 0) AS Total
                                  , ISNULL(SeatBlock, '') AS SeatBlock
                             FROM   @baseData
                           FOR
                             XML PATH('Parent')
                               , ROOT('Parents')
                           );

        SET @rootNodeName = 'Records';

		-- Calculate remaining count

        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) );

        IF @remainingCount < 0
            BEGIN

                SET @remainingCount = 0;

            END;

			-- Create response info node

        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>'
                                  + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>'
                                  + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>'
                                  + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20))
                                  + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>'
                                  + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20))
                                  + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20))
                                  + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>'
                                  + '</ResponseInfo>' );
    END;

-- Wrap response info and data, then return    

    IF @xmlDataNode IS NULL
        BEGIN

            SET @xmlDataNode = '<' + @rootNodeName + ' />';

        END;

    SET @finalXml = '<Root>' + @responseInfoNode
        + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

    SELECT  CAST(@finalXml AS XML);


GO
