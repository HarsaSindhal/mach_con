class ZCL_PM_MACHINE_HTTP definition
  public
  create public .

public section.

          TYPES : BEGIN OF ty,
      MaintenancePlanningPlant TYPE string,
      Equipment                TYPE string,
      MACHINENAME              TYPE string,
      WorkCenter               TYPE string,
      CostCenter               TYPE string,
      Date                     TYPE string,
      Batch                    TYPE string,
      Material                 TYPE string,
      ProductDescription       TYPE string,
      MatlWrhsStkQtyInMatlBaseUnit TYPE string,
      StorageLocation           TYPE string,
      consumeqty                 TYPE string,
      Remark                   TYPE string,
      MaterialBaseUnit         TYPE string,
             END OF ty.
    CLASS-DATA tabdata TYPE TABLE OF ty.

    TYPES : BEGIN OF ty1,
             items LIKE tabdata,
            END OF ty1.
    CLASS-DATA tab1 TYPE ty1.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PM_MACHINE_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    DATA json TYPE string.
    DATA(body)  = request->get_text(  )  .
    xco_cp_json=>data->from_string( body )->write_to( REF #( tab1  ) ).

MODIFY ENTITIES OF i_materialdocumenttp
             ENTITY MaterialDocument
             CREATE FROM VALUE #( ( %cid                          = 'My%CID_1'  "'CID_001'
                                    goodsmovementcode             = '03'
                                    postingdate                   = sy-datum
                                    documentdate                  = sy-datum
                                    "MaterialDocumentHeaderText    = tab1-deliverynotes
                                    "ReferenceDocument             = tab1-DeliveryNotes
                                    %control-goodsmovementcode                    = cl_abap_behv=>flag_changed
                                    %control-postingdate                          = cl_abap_behv=>flag_changed
                                    %control-documentdate                         = cl_abap_behv=>flag_changed
                                ) )
             ENTITY MaterialDocument
             CREATE BY \_MaterialDocumentItem
             FROM VALUE #( (
                             %cid_ref = 'My%CID_1'
                             %target = VALUE #( FOR any IN tab1-items INDEX INTO i
                                                 ( %cid                           = |My%CID_{ i }_001| "'CID_ITM_001'
                                                  plant                          = any-maintenanceplanningplant
                                                  material                       =  any-material  "any-material
                                                  GoodsMovementType              = '201'
                                                  storagelocation                = 'PM01'
                                                   QuantityInEntryUnit           = any-consumeqty
                                                   EntryUnit                     = SWITCH #( any-materialbaseunit
                                                                       WHEN 'NO'
                                                                       THEN  'ZNO'  ELSE any-materialbaseunit ) "any-materialbaseunit
                                                   Batch                         = any-batch
                                                   yy1_equipment_mmi             = any-equipment
                                                   YY1_Remark3_MMI               = ANY-remark
                                                   CostCenter                    = |00{ any-costcenter }| "any-costcenter

                                                  %control-plant                        = cl_abap_behv=>flag_changed
                                                  %control-material                     = cl_abap_behv=>flag_changed
                                                  %control-goodsmovementtype            = cl_abap_behv=>flag_changed
                                                  %control-storagelocation              = cl_abap_behv=>flag_changed
                                                  %control-quantityinentryunit          = cl_abap_behv=>flag_changed
                                                  %control-entryunit                    = cl_abap_behv=>flag_changed
                                                  %control-issuingorreceivingplant      = cl_abap_behv=>flag_changed
                                                  %control-issuingorreceivingstorageloc = cl_abap_behv=>flag_changed
                                                  %control-issgorrcvgbatch              = cl_abap_behv=>flag_changed

                                              ) )
                                                                       ) )

                   MAPPED   DATA(ls_create_mapped)
                   FAILED   DATA(ls_create_failed)
                   REPORTED DATA(ls_create_reported).

       COMMIT ENTITIES BEGIN
           RESPONSE OF i_materialdocumenttp
           FAILED DATA(commit_failed)
           REPORTED DATA(commit_reported).

    IF commit_failed-materialdocument IS NOT INITIAL.

      LOOP AT commit_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<data>).
        DATA(mszty) = sy-msgty.
        DATA(msz_1) = | { sy-msgv1 } { sy-msgv2 }  { sy-msgv3 } { sy-msgv4 } Message Type- { sy-msgid } Message No { sy-msgno }  |.
      ENDLOOP.
      IF commit_failed-materialdocument IS INITIAL.
        CLEAR mszty.
      ENDIF.
    ELSE.
      LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
        IF mszty = 'E' OR mszty = 'W'.
          EXIT.
        ENDIF.
        CONVERT KEY OF i_materialdocumenttp
                FROM <keys_header>-%pid
                TO <keys_header>-%key.
      ENDLOOP.

      LOOP AT ls_create_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
        IF mszty = 'E' OR mszty = 'W'.
          EXIT.
        ENDIF.
        CONVERT KEY OF i_materialdocumentitemtp
                FROM <keys_item>-%pid
                TO <keys_item>-%key.
      ENDLOOP.
    ENDIF.
    COMMIT ENTITIES END.
    DATA result TYPE string.
    IF mszty = 'E' OR mszty = 'W'.
      result = |ERROR { msz_1 } |.
    ELSE.

      IF <keys_header> IS ASSIGNED.

        DATA(grn) = <keys_header>-MaterialDocument.
        " data result type string .
        DATA result1 TYPE string.
        result = <keys_header>-MaterialDocument.
        result1 = <keys_header>-MaterialDocumentYear.
      ENDIF.
    ENDIF.

    IF mszty = 'E' OR mszty = 'W' OR grn IS INITIAL  .
      json = |ERROR { msz_1 } | .
    ELSE.
      CONCATENATE 'Material Document' result  'Created Suscessfully' INTO json SEPARATED BY ' '.
    ENDIF.
    response->set_text( json  ).
  ENDMETHOD.
ENDCLASS.
