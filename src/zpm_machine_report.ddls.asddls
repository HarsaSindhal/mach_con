@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Report Cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPM_MACHINE_REPORT as select from I_MaterialDocumentItem_2 as A
left outer join I_ProductDescription as B on  ( A.Material = B.Product and B.Language = 'E' )
left outer join I_ProductValuationBasic as c on ( A.Material = c.Product and A.Plant = c.ValuationArea)
{
   key A.MaterialDocument,
   A.Plant,
   A.YY1_EQUIPMENT_MMI,
   A.CostCenter,
   A.DocumentDate,
   A.Material,
   A.MaterialBaseUnit,
   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
   A.QuantityInEntryUnit,
   A.StorageLocation,
   A.Batch,
   A.YY1_Remark3_MMI,
   A.CompanyCode,
   B.ProductDescription,
   A.GoodsMovementType,
   c.Currency,
   @Semantics.amount.currencyCode: 'Currency'
   c.StandardPrice
   
   
   
   
   
}

where
 A.YY1_EQUIPMENT_MMI is not initial and A.CostCenter is not initial
