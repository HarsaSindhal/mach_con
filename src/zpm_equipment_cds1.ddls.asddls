@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PM EQUIPMENT CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPM_EQUIPMENT_CDS1 as select from I_TechnicalObject as S
left outer join  I_EquipmentText as d on ( S.Equipment = d.Equipment and d.Language = 'E' ) 
//left outer join I_LocationAccountAssignment as z on ( z.MaintObjectLocAcctAssgmtNmbr = S.MaintObjectInternalID )

{
    key S.Equipment,
    key S.MaintenancePlanningPlant,
    d.EquipmentName
//    z.CostCenter
}
   group by
    S.Equipment,
     S.MaintenancePlanningPlant,
    d.EquipmentName
//    z.CostCenter
