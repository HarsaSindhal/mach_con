@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MACHINE CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPM_MACHINE_CDS as select from I_MaterialStock_2 as A 
left outer join I_ProductDescription_2 as b on ( b.Product = A.Material and b.Language = 'E' )
//left outer join I_MaterialStock_2 as z on ( z.Material = A.Material and z.Plant = A.Plant and z.StorageLocation = A.StorageLocation)
//left outer join ZPM_EQUIPMENT_CDS1 as z1 on ( z1.MaintenancePlanningPlant = A.Plant )
{
       
       
       key  A.Batch,
       key A.Material,
//        z1.Equipment,
//        z1.CostCenter,
        A.Plant as MaintenancePlanningPlant,
//        z1.EquipmentName,        
        A.StorageLocation,                
        A.MaterialBaseUnit,
        b.ProductDescription,
//        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//        sum(z.MatlWrhsStkQtyInMatlBaseUnit) as SSSSS,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        sum(A.MatlWrhsStkQtyInMatlBaseUnit) as SSSSS //mat
}
where
 (( A.MatlWrhsStkQtyInMatlBaseUnit != 0.00000000000000 ) and A.Material like 'ST%'  and A.StorageLocation = 'PM01'  or A.StorageLocation = 'EL01' 
 or A.StorageLocation = 'UT01'  )
group by 
//z1.Equipment,
A.Material,
//A.Plant  ,
A.Plant,
//       z1.CostCenter,
        A.StorageLocation,
        A.Batch,
        A.MaterialBaseUnit,
        b.ProductDescription
//        z1.EquipmentName
having
  sum(A.MatlWrhsStkQtyInMatlBaseUnit) != 0.00000000000000


