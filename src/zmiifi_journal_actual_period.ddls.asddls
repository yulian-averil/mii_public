@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Actual Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIIFI_JOURNAL_ACTUAL_PERIOD
  with parameters
    P_CompanyCode : bukrs,
    P_Period      : fins_fiscalperiod,
    P_FiscalYear  : fis_gjahr_no_conv
//    P_GLAccount   : saknr
  as select from Z_I_JOURNAL_ACTUAL_PERIOD( 
     P_CompanyCode: $parameters.P_CompanyCode, 
     P_Period: $parameters.P_Period, 
     P_FiscalYear: $parameters.P_FiscalYear)
//     P_GLAccount: $parameters.P_GLAccount)
{
  key CompanyCode,
  key FiscalYear,
  key FiscalPeriod,
  key GLAccount,
  key CostCenter,
  CompanyCodeCurrency,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum(AmountInCompanyCodeCurrency) as JournalActualPeriod
} 
group by CompanyCode, FiscalYear, FiscalPeriod, GLAccount, CostCenter, CompanyCodeCurrency
 