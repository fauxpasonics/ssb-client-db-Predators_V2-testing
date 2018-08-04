SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[crm_migration] AS
SELECT cb.ContactId ,
       cb.DefaultPriceLevelId ,
       cb.CustomerSizeCode ,
       cb.CustomerTypeCode ,
       cb.PreferredContactMethodCode ,
       cb.LeadSourceCode ,
       cb.OriginatingLeadId ,
       cb.OwningBusinessUnit ,
       cb.PaymentTermsCode ,
       cb.ShippingMethodCode ,
       cb.ParticipatesInWorkflow ,
       cb.IsBackofficeCustomer ,
       cb.Salutation ,
       cb.JobTitle ,
       cb.FirstName ,
       cb.Department ,
       cb.NickName ,
       cb.MiddleName ,
       cb.LastName ,
       cb.Suffix ,
       cb.YomiFirstName ,
       cb.FullName ,
       cb.YomiMiddleName ,
       cb.YomiLastName ,
       cb.Anniversary ,
       cb.BirthDate ,
       cb.GovernmentId ,
       cb.YomiFullName ,
       cb.Description ,
       cb.EmployeeId ,
       cb.GenderCode ,
       cb.AnnualIncome ,
       cb.HasChildrenCode ,
       cb.EducationCode ,
       cb.WebSiteUrl ,
       cb.FamilyStatusCode ,
       cb.FtpSiteUrl ,
       cb.EMailAddress1 ,
       cb.SpousesName ,
       cb.AssistantName ,
       cb.EMailAddress2 ,
       cb.AssistantPhone ,
       cb.EMailAddress3 ,
       cb.DoNotPhone ,
       cb.ManagerName ,
       cb.ManagerPhone ,
       cb.DoNotFax ,
       cb.DoNotEMail ,
       cb.DoNotPostalMail ,
       cb.DoNotBulkEMail ,
       cb.DoNotBulkPostalMail ,
       cb.AccountRoleCode ,
       cb.TerritoryCode ,
       cb.IsPrivate ,
       cb.CreditLimit ,
       cb.CreatedOn ,
       cb.CreditOnHold ,
       cb.CreatedBy ,
       cb.ModifiedOn ,
       cb.ModifiedBy ,
       cb.NumberOfChildren ,
       cb.ChildrensNames ,
       cb.VersionNumber ,
       cb.MobilePhone ,
       cb.Pager ,
       cb.Telephone1 ,
       cb.Telephone2 ,
       cb.Telephone3 ,
       cb.Fax ,
       cb.Aging30 ,
       cb.StateCode ,
       cb.Aging60 ,
       cb.StatusCode ,
       cb.Aging90 ,
       cb.PreferredSystemUserId ,
       cb.PreferredServiceId ,
       cb.MasterId ,
       cb.PreferredAppointmentDayCode ,
       cb.PreferredAppointmentTimeCode ,
       cb.DoNotSendMM ,
       cb.Merged ,
       cb.ExternalUserIdentifier ,
       cb.SubscriptionId ,
       cb.PreferredEquipmentId ,
       cb.LastUsedInCampaign ,
       cb.TransactionCurrencyId ,
       cb.OverriddenCreatedOn ,
       cb.ExchangeRate ,
       cb.ImportSequenceNumber ,
       cb.TimeZoneRuleVersionNumber ,
       cb.UTCConversionTimeZoneCode ,
       cb.AnnualIncome_Base ,
       cb.CreditLimit_Base ,
       cb.Aging60_Base ,
       cb.Aging90_Base ,
       cb.Aging30_Base ,
       cb.OwnerId ,
       cb.CreatedOnBehalfBy ,
       cb.IsAutoCreate ,
       cb.ModifiedOnBehalfBy ,
	   (CASE WHEN (SELECT accountid FROM etl.crm_account_migration WHERE accountid = cb.parentcustomerid) IS NULL THEN NULL
	   ELSE cb.ParentCustomerId
	   END) AS 'ParentCustomerID',
       cb.ParentCustomerIdType ,
       cb.ParentCustomerIdName ,
       cb.OwnerIdType ,
       cb.ParentCustomerIdYomiName ,
       cb.ProcessId ,
       cb.EntityImageId ,
       cb.StageId ,
       (CASE WHEN LEN(cb.kore_archticsids) <= 100 THEN cb.kore_archticsids
	   WHEN LEN(cb.kore_archticsids) > 100 THEN LEFT(cb.kore_archticsids,100)
	   END) AS 'kore_archticsids',
       cb.kore_CheckedOutUntil ,
       cb.kore_ExternalContactId ,
       cb.kore_GroupBuyer ,
       cb.kore_GroupCategory ,
       cb.kore_HeritageNationality ,
       cb.kore_MilesFromFacility ,
       cb.kore_MiniPlanHolder ,
       cb.kore_OverrideCheckoutExpiration ,
       cb.kore_PrimaryArchticsId ,
       cb.kore_SeasonTicketHolder ,
       cb.kore_SecondaryArchticsName ,
       cb.kore_SecondaryEmail ,
       cb.kore_SuiteBuyer ,
       cb.kore_TicketingContactType ,
       cb.kore_TicketingType ,
       cb.koreps_LastContacted ,
       cb.kore_countryid ,
       cb.kore_stateorprovinceid ,
       cb.kore_CheckedOutBy ,
       cb.kore_GroupSalesRep ,
       cb.kore_SuiteSalesRep ,
       cb.kore_TicketingSalesRep ,
       cb.kore_TicketingServiceRep ,
       cb.koreps_AccountStrippedName ,
       cb.koreps_CompanyId ,
       cb.koreps_InvalidEmail ,
       cb.new_Alternate_Payment_Plan ,
       cb.new_GroupName ,
       cb.new_SmashvilleRewardsPoints ,
       cb.new_LoggedintoWifi ,
       cb.new_LoggedintoSmashvilleRewards ,
       cb.koreps_ContactType ,
       cb.str_clienttype ,
       cb.str_hometown ,
       cb.str_college ,
       cb.koreps_DoNotStream ,
       cb.koreps_ficoscore ,
       cb.client_IceRinkEmail1 ,
       cb.client_IceRinkEmail2 ,
       cb.client_IceRinkEmail3 ,
       cb.koreps_DisableContactSync ,
       cb.str_client_LexusInnerCircleCustomer ,
       cb.str_Client_LexusTermStartDate ,
       cb.str_Client_LexusTermEndDate ,
       cb.str_Client_Lexus_Forecast1617 ,
       cb.str_client_lexus_forecast1617_Base ,
       cb.str_Client_Lexus_Forecast1718 ,
       cb.str_client_lexus_forecast1718_Base ,
       cb.str_Client_Lexus_Forecast1819 ,
       cb.str_client_lexus_forecast1819_Base ,
       cb.str_Client_Lexus_Forecast1920 ,
       cb.str_client_lexus_forecast1920_Base ,
       cb.str_Client_Lexus_Forecast2021 ,
       cb.str_client_lexus_forecast2021_Base ,
       cb.str_Client_Lexus_Forecast2122 ,
       cb.str_client_lexus_forecast2122_Base ,
       cb.str_Client_Lexus_Forecast2223 ,
       cb.str_client_lexus_forecast2223_Base ,
       cb.str_Client_Lexus_Forecast_2425 ,
       cb.str_client_lexus_forecast_2425_Base ,
       cb.str_Client_Lexus_Forecast2324 ,
       cb.str_client_lexus_forecast2324_Base ,
       cb.str_Client_Lexus_PaymentPlan ,
       cb.str_Client_Lexus_Notes ,
       cb.koreps_SyncPriority ,
       cb.koreps_TicketingAccountType ,
       cab.ParentId ,
       cab.CustomerAddressId ,
       cab.AddressNumber ,
       cab.ObjectTypeCode ,
       cab.AddressTypeCode ,
       cab.Name ,
       cab.PrimaryContactName ,
       cab.Line1 ,
       cab.Line2 ,
       cab.Line3 ,
       cab.City ,
       cab.StateOrProvince ,
       cab.County ,
       cab.Country ,
       cab.PostOfficeBox ,
       cab.PostalCode
FROM etl.crm_migration_ids base
JOIN dbo.ContactBase cb ON base.ContactId = cb.ContactId
JOIN dbo.CustomerAddressBase cab ON cb.ContactId = cab.ParentId
WHERE cab.AddressNumber = 1 AND cab.AddressTypeCode IS NULL

GO