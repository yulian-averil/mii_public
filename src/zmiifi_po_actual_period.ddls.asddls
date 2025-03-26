@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Actual Period Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIIFI_PO_ACTUAL_PERIOD
with parameters
    P_CompanyCode : bukrs,
    P_Period      : fins_fiscalperiod,
    P_FiscalYear  : fis_gjahr_no_conv
//    P_GLAccount   : saknr
as select from Z_I_PO_ACTUAL_PERIOD 
( P_CompanyCode: $parameters.P_CompanyCode,
  P_Period: $parameters.P_Period,
  P_FiscalYear: $parameters.P_FiscalYear) as POActual
//  P_GLAccount: $parameters.P_GLAccount ) as POActual
  left outer join Z_I_JOURNAL_ACTUAL_PERIOD
( P_CompanyCode: $parameters.P_CompanyCode,
  P_Period: $parameters.P_Period,
  P_FiscalYear: $parameters.P_FiscalYear) as JournalActual
//  P_GLAccount: $parameters.P_GLAccount ) as JournalActual
  on POActual.CompanyCode = JournalActual.CompanyCode and
     POActual.FiscalYear  = JournalActual.FiscalYear and
     POActual.FiscalPeriod = JournalActual.FiscalPeriod
{
//    key POActual.SourceLedger,
    key POActual.CompanyCode as CompanyCode,
    key POActual.FiscalYear as FiscalYear,
//    key POActual.AccountingDocument,
//    key LedgerGLLineItem,
//    key Ledger,
    key POActual.FiscalPeriod as FiscalPeriod,
    key POActual.GLAccount as GLAccount,
    key POActual.CostCenter as CostCenter,
//    SourceReferenceDocumentType,
//    SourceReferenceDocument,
//    SourceReferenceDocumentItem,
//    PredecessorReferenceDocType,
//    PredecessorReferenceDocument,
//    PredecessorReferenceDocItem,
    POActual.CompanyCodeCurrency as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'    
      sum(case when POActual.SourceReferenceDocument = JournalActual.PurchasingDocument and
                    substring(POActual.SourceReferenceDocumentItem,1,5) = JournalActual.PurchasingDocumentItem 
      then cast( 0 as abap.curr( 23 , 2 ) )
      else POActual.AmountInCompanyCodeCurrency
      end) as POActualPeriod
}
group by POActual.CompanyCode, POActual.FiscalYear, POActual.FiscalPeriod, POActual.GLAccount, POActual.CostCenter, POActual.CompanyCodeCurrency
 