//@AccessControl.authorizationCheck: #NOT_REQUIRED
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Opex Budget MII Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define transient view entity Z_C_OPEX_BUDGET_MII
  provider contract analytical_query
  with parameters
    P_ControllingArea  : fis_kokrs,
    P_CompanyCode      : bukrs,
    P_PlanningCategory : fcom_category,
    P_Period           : fins_fiscalperiod,
    P_FiscalYear       : fis_gjahr_no_conv
  //    P_Project          : zmiifde_project,
  //    P_WBSExternalID    : zmiifde_wbs_element,
  //    P_CostCenter       : zmiifde_kostl,
  //    P_GLAccount        : saknr
  as projection on Z_I_OPEX_BUDGET_MII
                   ( P_ControllingArea: $parameters.P_ControllingArea,
                     P_CompanyCode: $parameters.P_CompanyCode,
                     P_PlanningCategory: $parameters.P_PlanningCategory,
                     P_Period: $parameters.P_Period,
                     P_FiscalYear: $parameters.P_FiscalYear)
  //                   P_Project: $parameters.P_Project,
  //                   P_WBSExternalID: $parameters.P_WBSExternalID,
  //                   P_CostCenter: $parameters.P_CostCenter,
  //                   P_GLAccount: $parameters.P_GLAccount )
  association to Z_I_OPEX_BUDGET_MII as _YTDBudget on _YTDBudget.ControllingArea = $parameters.P_ControllingArea

{
  @AnalyticsDetails.query.axis: #ROWS
  @Consumption.defaultValue: 'A000'
  ControllingArea,
  @AnalyticsDetails.query.axis: #ROWS
  CompanyCode,
  @AnalyticsDetails.query.axis: #ROWS
  PlanningCategory,
  @AnalyticsDetails.query.axis: #ROWS
  FiscalYear,
  @AnalyticsDetails.query.axis: #ROWS
  ProjectInternalID,
  @AnalyticsDetails.query.axis: #ROWS
  @Consumption.filter.mandatory: false
  @Consumption.filter : { selectionType : #SINGLE}
  ProjectExternalID,
  @AnalyticsDetails.query.axis: #ROWS
  ProjectDescription,
  @AnalyticsDetails.query.axis: #ROWS
  WBSElementExternalID,
  @AnalyticsDetails.query.axis: #ROWS
  @Consumption.filter.mandatory: false
  @Consumption.filter : { selectionType : #SINGLE}
  CostCenter,
  @AnalyticsDetails.query.axis: #ROWS
  GLAccount,
  @AnalyticsDetails.query.axis: #ROWS
  GLAccountName,
  @AnalyticsDetails.query.axis: #ROWS
  CompanyCodeCurrency,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  BudgetOriPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  ReturnBudgetPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  SupplBudgetPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  TotalBudgetPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PrActualPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PoActualPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  JournalActualPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PaymentPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  RemainBudgetPeriod,
  RealizationPeriod,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  BudgetOriYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  ReturnBudgetYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  SupplBudgetYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  TotalBudgetYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PrActualYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PoActualYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  JournalActualYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  PaymentYTD,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  RemainBudgetYTD,
  RealizationYTD,
  /* Associations */
  _BudgetYTD,
  _JournalActualPeriod,
  _JournalActualYTD,
  _PoActualPeriod,
  _PoActualYTD,
  _PrActualPeriod,
  _PrActualYTD
}
