@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Actual YTD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PO_ACTUAL_YTD
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
      SourceReferenceDocumentType,
      SourceReferenceDocument,
      SourceReferenceDocumentItem,
//      PredecessorReferenceDocType,
//      PredecessorReferenceDocument,
//      PredecessorReferenceDocItem,
      ReferenceDocumentType,
      ReferenceDocument,
      ReferenceDocumentItem,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency
}
where 
      SourceLedger = '0E'
  and CompanyCode = $parameters.P_CompanyCode
  and FiscalYear = $parameters.P_FiscalYear
  and Ledger = '0E'  
  and FiscalPeriod between '001' and $parameters.P_Period
//  and GLAccount = $parameters.P_GLAccount 
//  and IsCommitment                = 'X'
//  and GLBusinessTransactionType   = 'RMWE'
//  and ControllingBusTransacType   = 'COIN'
  and SourceReferenceDocumentType = 'PORD'
  and OffsettingAccountType <> ''
