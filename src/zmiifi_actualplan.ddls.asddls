@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual Plan Interface View'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIIFI_ActualPlan
  as select from ZMIIFI_ActualPlan_Param (
                 P_ControllingArea : 'A000',
                 P_CompanyCode : '0180',
                 P_PlanningCategory: 'PLN',
                 P_Period: '001',
                 P_FiscalYear: '2025'
                 //                 P_Project: 'C-Z1005-25-S402',
                 //                 P_WBSExternalID: 'C-Z1005-25-S402-0001',
                 //                 P_CostCenter: '',
                 //                 P_GLAccount: '7999999999'
                 )
{
      //  key SourceLedger,
      //  key Ledger,
  key CompanyCode,
  key FiscalYear,
      //  key AccountingDocument,
      //  key FinancialPlanningReqTransSqnc,
      //  key FinancialPlanningDataPacket,
      //  key ActualPlanJournalEntryItem,
      ControllingArea,
      PlanningCategory,
      //      FiscalPeriod,
      ProjectInternalID,
      ProjectExternalID,
      ProjectDescription,
      WBSElementExternalID,
      CostCenter,
      GLAccount,
      //      GLAccountName,
      CompanyCodeCurrency,
      BudgetOriPeriod,
      ReturnBudgetPeriod,
      SupplBudgetPeriod,

      /* Associations */
      _GLAccount,
      _Project
}
