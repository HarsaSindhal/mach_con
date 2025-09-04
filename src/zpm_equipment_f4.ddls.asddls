@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPM_EQUIPMENT_F4 as select from I_TechnicalObject as A
left outer join I_EquipmentText as B on ( A.Equipment = B.Equipment )
{
  key  A.Equipment,
  key  B.EquipmentName,
  key  A.MaintenancePlanningPlant
      
}

group by 
A.Equipment,
B.EquipmentName,
A.MaintenancePlanningPlant
