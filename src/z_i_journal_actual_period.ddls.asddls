@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Actual Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_JOURNAL_ACTUAL_PERIOD
  with parameters
    P_CompanyCode : bukrs,
    P_Period      : fins_fiscalperiod,
    P_FiscalYear  : fis_gjahr_no_conv
  //    P_GLAccount   : saknr
  //  as select from I_GLAccountLineItem
  as select from I_ActualPlanJournalEntryItem
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      FiscalPeriod,
      GLAccount,
      CostCenter,
      PurchasingDocument,
      PurchasingDocumentItem,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency
}
where
      CompanyCode  = $parameters.P_CompanyCode
  and FiscalYear   = $parameters.P_FiscalYear
  and FiscalPeriod = $parameters.P_Period
  //  and GLAccount = $parameters.P_GLAccount
  and SourceLedger = '0L'
  //  and Ledger = '0E'
  and Ledger       = '0L'
//  and GLBusinessTransactionType = 'RMWE'
//  and ControllingBusTransacType = ''
//  and PurchasingDocument <> ''
//  and PurchasingDocumentItem <> '00000'
//union
//select from I_GLAccountLineItem
//{
//  key SourceLedger,
//  key CompanyCode,
//  key FiscalYear,
//  key AccountingDocument,
//  key LedgerGLLineItem,
//  key Ledger,
//      FiscalPeriod,
//      GLAccount,
//      CostCenter,
//      PurchasingDocument,
//      PurchasingDocumentItem,
//      CompanyCodeCurrency,
//      AmountInCompanyCodeCurrency
//}
//where CompanyCode = $parameters.P_CompanyCode
//  and FiscalYear = $parameters.P_FiscalYear
//  and FiscalPeriod = $parameters.P_Period
////  and GLAccount = $parameters.P_GLAccount
//  and SourceLedger = '0L'
//  and Ledger = '0L'
//  and ( BusinessTransactionType = 'RFBU' or BusinessTransactionType = 'RFIV' )
