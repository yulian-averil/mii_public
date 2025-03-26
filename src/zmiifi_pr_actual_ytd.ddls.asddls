@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Actual YTD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIIFI_PR_ACTUAL_YTD 
  with parameters
    P_CompanyCode : bukrs,
    P_Period      : fins_fiscalperiod,
    P_FiscalYear  : fis_gjahr_no_conv
//    P_GLAccount   : saknr
  as select from Z_I_PR_ACTUAL_YTD(
                 P_CompanyCode: $parameters.P_CompanyCode,
                 P_Period: $parameters.P_Period,
                 P_FiscalYear: $parameters.P_FiscalYear) as PrActual
//                 P_GLAccount: $parameters.P_GLAccount ) as PrActual
    left outer join   Z_I_PO_ACTUAL_YTD(
                 P_CompanyCode: $parameters.P_CompanyCode,
                 P_Period: $parameters.P_Period,
                 P_FiscalYear: $parameters.P_FiscalYear) as PoActual on  PrActual.SourceLedger = PoActual.SourceLedger
//                 P_GLAccount: $parameters.P_GLAccount ) as PoActual on  PrActual.SourceLedger = PoActual.SourceLedger
                                                                    and PrActual.CompanyCode  = PoActual.CompanyCode
                                                                    and PrActual.FiscalYear   = PoActual.FiscalYear
                                                                    and PrActual.Ledger       = PoActual.Ledger
{
  key PrActual.CompanyCode as CompanyCode,
  key PrActual.FiscalYear as FiscalYear,
  key PrActual.FiscalPeriod as FiscalPeriod,
  key PrActual.GLAccount as GLAccount,
  key PrActual.CostCenter as CostCenter,
//      PrActual.SourceReferenceDocumentType,
//      PrActual.SourceReferenceDocument,
//      PrActual.SourceReferenceDocumentItem,
//      PoActual.PredecessorReferenceDocType,
//      PoActual.PredecessorReferenceDocument,
//      PoActual.PredecessorReferenceDocItem,
      PrActual.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      sum(case when PrActual.SourceReferenceDocumentType = PoActual.PredecessorReferenceDocType and
//                    PrActual.SourceReferenceDocument = PoActual.PredecessorReferenceDocument and
//                    PrActual.SourceReferenceDocumentItem = PoActual.PredecessorReferenceDocItem
      sum(case when PrActual.SourceReferenceDocumentType = PoActual.ReferenceDocumentType and
                    PrActual.SourceReferenceDocument = PoActual.ReferenceDocument and
                    PrActual.SourceReferenceDocumentItem = PoActual.ReferenceDocumentItem
      then cast( 0 as abap.curr( 23 , 2 ) )
      else PrActual.AmountInCompanyCodeCurrency
      end) as PRActualYTD
}
group by PrActual.CompanyCode, PrActual.FiscalYear, PrActual.FiscalPeriod, PrActual.GLAccount, PrActual.CostCenter, PrActual.CompanyCodeCurrency 
