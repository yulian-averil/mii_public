@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual Plan Interface View Parameter'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIIFI_ACTUALPLAN_YTD_PARAM
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
  as select from I_ActualPlanJournalEntryItem as ActPlan
  association [0..1] to I_EnterpriseProject          as _Project   on  $projection.ProjectInternalID = _Project.ProjectInternalID
  association [0..1] to I_GlAccountTextInCompanycode as _GLAccount on  $projection.GLAccount   = _GLAccount.GLAccount
                                                                   and $projection.CompanyCode = _GLAccount.CompanyCode
                                                                   and _GLAccount.Language     = 'E'


{
  key ControllingArea,
  key CompanyCode,
  key FiscalYear,
  key PlanningCategory,
  key FiscalPeriod,
  key ProjectInternalID,
  key WBSElementExternalID,
  key CostCenter,
  key GLAccount,
      ProjectExternalID,
      _Project.ProjectDescription  as ProjectDescription,
      _GLAccount.GLAccountLongName as GLAccountName,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case when BudgetProcess = ''
           then AmountInCompanyCodeCurrency
           else cast( 0 as abap.curr( 23 , 2 ) )
           end)                    as BudgetOriYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case when BudgetProcess = 'RETN' or BudgetProcess = 'SEND'
           then AmountInCompanyCodeCurrency
           else cast( 0 as abap.curr( 23 , 2 ) )
           end)                    as ReturnBudgetYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case when BudgetProcess = 'SUPL' or BudgetProcess = 'RECV'
           then AmountInCompanyCodeCurrency
           else cast( 0 as abap.curr( 23 , 2 ) )
           end)                    as SupplBudgetYTD,

      _Project,
      _GLAccount

}
where
      ActPlan.ControllingArea = $parameters.P_ControllingArea
  and ActPlan.CompanyCode     = $parameters.P_CompanyCode
  and PlanningCategory        = $parameters.P_PlanningCategory
  and FiscalPeriod            between '001' and $parameters.P_Period
  and FiscalYear              = $parameters.P_FiscalYear
//  and ProjectExternalID = $parameters.P_Project
//  and WBSElementExternalID = $parameters.P_WBSExternalID
//  and CostCenter = $parameters.P_CostCenter
//  and ActPlan.GLAccount = $parameters.P_GLAccount
group by
  ControllingArea,
  CompanyCode,
  PlanningCategory,
  FiscalPeriod,
  FiscalYear,
  ProjectInternalID,
  WBSElementExternalID,
  CostCenter,
  GLAccount,
  ProjectExternalID,
  _Project.ProjectDescription,
  _GLAccount.GLAccountLongName,
  CompanyCodeCurrency
