@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Opex Budget Model View Entity'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.dataCategory: #CUBE
//@Analytics.query: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_OPEX_BUDGET_MII
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
  as select from ZMIIFI_ActualPlan_Param
                 ( P_ControllingArea: $parameters.P_ControllingArea,
                 P_CompanyCode: $parameters.P_CompanyCode,
                 P_PlanningCategory: $parameters.P_PlanningCategory,
                 P_Period: $parameters.P_Period,
                 P_FiscalYear: $parameters.P_FiscalYear ) as Budget
  //                 P_Project: $parameters.P_Project,
  //                 P_WBSExternalID: $parameters.P_WBSExternalID,
  //                 P_CostCenter: $parameters.P_CostCenter,
  //                 P_GLAccount: $parameters.P_GLAccount ) as Budget
  association [0..1] to ZMIIFI_ACTUALPLAN_YTD_PARAM  as _BudgetYTD           on  _BudgetYTD.ControllingArea      = $projection.ControllingArea
                                                                             and _BudgetYTD.CompanyCode          = $projection.CompanyCode
                                                                             and _BudgetYTD.PlanningCategory     = $projection.PlanningCategory
  //                                                                  and _BudgetYTD.FiscalPeriod         = $projection.FiscalPeriod
                                                                             and _BudgetYTD.FiscalYear           = $projection.FiscalYear
                                                                             and _BudgetYTD.ProjectInternalID    = $projection.ProjectInternalID
                                                                             and _BudgetYTD.WBSElementExternalID = $projection.WBSElementExternalID
                                                                             and _BudgetYTD.CostCenter           = $projection.CostCenter
                                                                             and _BudgetYTD.GLAccount            = $projection.GLAccount
  association [0..1] to ZMIIFI_PR_ACTUAL_PERIOD      as _PrActualPeriod      on  _PrActualPeriod.CompanyCode = $projection.CompanyCode
                                                                             and _PrActualPeriod.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _PrActualPeriod.GLAccount   = $projection.GLAccount
  association [0..1] to ZMIIFI_PO_ACTUAL_PERIOD      as _PoActualPeriod      on  _PoActualPeriod.CompanyCode = $projection.CompanyCode
                                                                             and _PoActualPeriod.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _PoActualPeriod.GLAccount   = $projection.GLAccount
  association [0..1] to ZMIIFI_JOURNAL_ACTUAL_PERIOD as _JournalActualPeriod on  _JournalActualPeriod.CompanyCode = $projection.CompanyCode
                                                                             and _JournalActualPeriod.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _JournalActualPeriod.GLAccount   = $projection.GLAccount
  association [0..1] to ZMIIFI_PR_ACTUAL_YTD         as _PrActualYTD         on  _PrActualYTD.CompanyCode = $projection.CompanyCode
                                                                             and _PrActualYTD.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _PrActualYTD.GLAccount   = $projection.GLAccount
  association [0..1] to ZMIIFI_PO_ACTUAL_YTD         as _PoActualYTD         on  _PoActualYTD.CompanyCode = $projection.CompanyCode
                                                                             and _PoActualYTD.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _PoActualYTD.GLAccount   = $projection.GLAccount
  association [0..1] to ZMIIFI_JOURNAL_ACTUAL_YTD    as _JournalActualYTD    on  _JournalActualYTD.CompanyCode = $projection.CompanyCode
                                                                             and _JournalActualYTD.FiscalYear  = $projection.FiscalYear
  // and _PrActualPeriod.FiscalPeriod   = $projection.
                                                                             and _JournalActualYTD.GLAccount   = $projection.GLAccount
{
  key ControllingArea,
  key CompanyCode,
  key PlanningCategory,
      //  key FiscalPeriod,
  key FiscalYear,
  key ProjectInternalID,
  key WBSElementExternalID,
      @Consumption.filter.mandatory: false
      @Consumption.filter : { selectionType : #SINGLE}
  key CostCenter,
  key GLAccount,
      ProjectExternalID,
      ProjectDescription,
      GLAccountName,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      BudgetOriPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ReturnBudgetPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      SupplBudgetPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (BudgetOriPeriod - ReturnBudgetPeriod + SupplBudgetPeriod)                                  as TotalBudgetPeriod,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PrActualPeriod( P_CompanyCode: $parameters.P_CompanyCode,
                       P_Period: $parameters.P_Period,
                       P_FiscalYear: $parameters.P_FiscalYear).PRActualPeriod                     as PrActualPeriod,
      //                       P_GLAccount: $parameters.P_GLAccount ).PRActualPeriod as PrActualPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PoActualPeriod( P_CompanyCode: $parameters.P_CompanyCode,
                       P_Period: $parameters.P_Period,
                       P_FiscalYear: $parameters.P_FiscalYear).POActualPeriod                     as PoActualPeriod,
      //                       P_GLAccount: $parameters.P_GLAccount ).POActualPeriod as PoActualPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _JournalActualPeriod( P_CompanyCode: $parameters.P_CompanyCode,
                        P_Period: $parameters.P_Period,
                        P_FiscalYear: $parameters.P_FiscalYear).JournalActualPeriod               as JournalActualPeriod,
      //                       P_GLAccount: $parameters.P_GLAccount ).JournalActualPeriod as JournalActualPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ($projection.PrActualPeriod + $projection.PoActualPeriod + $projection.JournalActualPeriod) as PaymentPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ($projection.TotalBudgetPeriod - $projection.PaymentPeriod)                                 as RemainBudgetPeriod,
      case when $projection.TotalBudgetPeriod = 0
      then 0
      else cast($projection.PaymentPeriod as abap.fltp) / cast($projection.TotalBudgetPeriod as abap.fltp) * cast(100 as abap.fltp)
      end                                                                                         as RealizationPeriod,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (_BudgetYTD( P_ControllingArea:$parameters.P_ControllingArea ,
                  P_CompanyCode:$parameters.P_CompanyCode ,
                  P_PlanningCategory:$parameters.P_PlanningCategory ,
                  P_Period:$parameters.P_Period,
                  P_FiscalYear:$parameters.P_FiscalYear).BudgetOriYTD),
      //                  P_Project:$parameters.P_Project,
      //                  P_WBSExternalID:$parameters.P_WBSExternalID,
      //                  P_CostCenter:$parameters.P_CostCenter,
      //                  P_GLAccount:$parameters.P_GLAccount).BudgetOriYTD)                        as BudgetOriYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (_BudgetYTD( P_ControllingArea:$parameters.P_ControllingArea ,
                   P_CompanyCode:$parameters.P_CompanyCode ,
                   P_PlanningCategory:$parameters.P_PlanningCategory ,
                   P_Period:$parameters.P_Period,
                   P_FiscalYear:$parameters.P_FiscalYear).ReturnBudgetYTD),
      //                  P_Project:$parameters.P_Project,
      //                  P_WBSExternalID:$parameters.P_WBSExternalID,
      //                  P_CostCenter:$parameters.P_CostCenter,
      //                  P_GLAccount:$parameters.P_GLAccount).ReturnBudgetYTD)                     as ReturnBudgetYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (_BudgetYTD( P_ControllingArea:$parameters.P_ControllingArea ,
                  P_CompanyCode:$parameters.P_CompanyCode ,
                  P_PlanningCategory:$parameters.P_PlanningCategory ,
                  P_Period:$parameters.P_Period,
                  P_FiscalYear:$parameters.P_FiscalYear).SupplBudgetYTD),
      //                  P_Project:$parameters.P_Project,
      //                  P_WBSExternalID:$parameters.P_WBSExternalID,
      //                  P_CostCenter:$parameters.P_CostCenter,
      //                  P_GLAccount:$parameters.P_GLAccount).SupplBudgetYTD)                      as SupplBudgetYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ($projection.budgetoriytd - $projection.returnbudgetytd + $projection.supplbudgetytd)       as TotalBudgetYTD,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PrActualYTD( P_CompanyCode: $parameters.P_CompanyCode,
                       P_Period: $parameters.P_Period,
                       P_FiscalYear: $parameters.P_FiscalYear).PRActualYTD                        as PrActualYTD,
      //                       P_GLAccount: $parameters.P_GLAccount ).PRActualYTD as PrActualYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PoActualYTD( P_CompanyCode: $parameters.P_CompanyCode,
                    P_Period: $parameters.P_Period,
                    P_FiscalYear: $parameters.P_FiscalYear).POActualYTD                           as PoActualYTD,
      //                       P_GLAccount: $parameters.P_GLAccount ).POActualYTD as PoActualYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _JournalActualYTD( P_CompanyCode: $parameters.P_CompanyCode,
                        P_Period: $parameters.P_Period,
                        P_FiscalYear: $parameters.P_FiscalYear).JournalActualYTD                  as JournalActualYTD,
      //                       P_GLAccount: $parameters.P_GLAccount ).JournalActualYTD as JournalActualYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ($projection.PrActualYTD + $projection.PoActualYTD + $projection.JournalActualYTD)          as PaymentYTD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ($projection.TotalBudgetYTD - $projection.PaymentYTD)                                       as RemainBudgetYTD,
      case when $projection.TotalBudgetYTD = 0
      then 0
      else cast($projection.PaymentYTD as abap.fltp) / cast($projection.TotalBudgetYTD as abap.fltp) * cast(100 as abap.fltp)
      end                                                                                         as RealizationYTD,

      _BudgetYTD,
      _PrActualPeriod,
      _PoActualPeriod,
      _JournalActualPeriod,
      _PrActualYTD,
      _PoActualYTD,
      _JournalActualYTD

}
where
      ControllingArea  = $parameters.P_ControllingArea
  and CompanyCode      = $parameters.P_CompanyCode
  and PlanningCategory = $parameters.P_PlanningCategory
  and FiscalYear       = $parameters.P_FiscalYear
  and FiscalPeriod     = $parameters.P_Period
// and ProjectExternalID    = ProjectExternalID
//  and WBSElementExternalID = $parameters.P_WBSExternalID
//  and CostCenter           = $parameters.P_CostCenter
//  and GLAccount            = $parameters.P_GLAccount
