@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Report Cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPM_MACHINE_FINAL_REPORT as select from ZPM_MACHINE_REPORT
{
     @UI.lineItem   : [{ position: 10 }]
    @UI.identification: [{position: 10}]
    @UI.selectionField: [{ position: 10 }]
    @EndUserText.label: 'Material Document' 
    key MaterialDocument,
    
    @UI.lineItem   : [{ position: 20 }]
    @UI.identification: [{position: 20}]
    @UI.selectionField: [{ position: 20 }]
    @EndUserText.label: 'Plant' 
    Plant,
    
    @UI.lineItem   : [{ position: 30 }]
    @UI.identification: [{position: 30}]
    @EndUserText.label: 'Company Code' 
    CompanyCode,
    
    @UI.lineItem   : [{ position: 40 }]
    @UI.identification: [{position: 40}]
    @UI.selectionField: [{ position: 40 }]
    @EndUserText.label: 'Material' 
    Material,
    
    @UI.lineItem   : [{ position: 50 }]
    @UI.identification: [{position: 50}]
    @EndUserText.label: 'Product Description' 
    ProductDescription,
    
    @UI.lineItem   : [{ position: 60 }]
    @UI.identification: [{position: 60}]
    @EndUserText.label: 'EQUIPMENT' 
    YY1_EQUIPMENT_MMI,
    
    @UI.lineItem   : [{ position: 70 }]
    @UI.identification: [{position: 70}]
    @EndUserText.label: 'CostCenter' 
    CostCenter,
    
    @UI.lineItem   : [{ position: 80 }]
    @UI.identification: [{position: 80}]
    @EndUserText.label: 'Document Date' 
    DocumentDate,
    
    MaterialBaseUnit,
    
    @UI.lineItem   : [{ position: 90 }]
    @UI.identification: [{position: 90}]
    @EndUserText.label: 'QuantityIn EntryUnit'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    @Aggregation.default     : #SUM
    sum(QuantityInEntryUnit) as QuantityInEntryUnit,
    
    @UI.lineItem   : [{ position: 100 }]
    @UI.identification: [{position: 100}]
    @EndUserText.label: 'Storage Location'
    StorageLocation,
    
    @UI.lineItem   : [{ position: 110 }]
    @UI.identification: [{position: 110}]
    @EndUserText.label: 'Batch'
    Batch,
     
    @UI.lineItem   : [{ position: 120 }]
    @UI.identification: [{position: 120}]
    @EndUserText.label: 'Goods Movement Type'  
    GoodsMovementType,
    
    @UI.lineItem   : [{ position: 130 }]
    @UI.identification: [{position: 130}]
    @EndUserText.label: 'Currency'
    Currency,
    
//    @UI.lineItem   : [{ position: 140 }]
//    @UI.identification: [{position: 140}]
//    @EndUserText.label: 'Standard Price'
//     @Aggregation.default     : #SUM
//     @Semantics.amount.currencyCode: 'Currency'
//    sum(StandardPrice) as StandardPrice ,
    
    @UI.lineItem   : [{ position: 140 }]
    @UI.identification: [{position: 140}]
    @EndUserText.label: 'Remark'
     YY1_Remark3_MMI,
     
     @Aggregation.default     : #SUM
     ( cast( sum( QuantityInEntryUnit ) as abap.dec( 13, 2 ) )  
       * cast(sum(StandardPrice) as abap.dec( 13, 2 ))  )  as PRICE
     
}

group by
   MaterialDocument,
   Plant,
   YY1_EQUIPMENT_MMI,
   CostCenter,
   DocumentDate,
   Material,
   MaterialBaseUnit,
   
   StorageLocation,
   Batch,
   YY1_Remark3_MMI,
   CompanyCode,
   ProductDescription,
   GoodsMovementType,
   Currency
   
