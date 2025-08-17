*&---------------------------------------------------------------------*
*& Report ZRA01W1401
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1401.

CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_model TYPE string .
    METHODS estimate_fuel IMPORTING iv_distance  TYPE i "연료계산메소드
    RETURNING VALUE(rv_fuel) TYPE i.

  PROTECTED SECTION.


  PRIVATE SECTION.
    DATA : ser_no TYPE numc04, "차번호  "Instance Attribute
           model  TYPE string. "차종
    CLASS-DATA tot_cnt TYPE i. "토탈  "Static Attribute

ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.
  METHOD constructor.
    lcl_vehicle=>tot_cnt = lcl_vehicle=>tot_cnt + 1.
    me->ser_no = lcl_vehicle=>tot_cnt.
    me->model = iv_model.
  ENDMETHOD.

  METHOD estimate_fuel.
    rv_fuel = iv_distance * 12.
  ENDMETHOD.

ENDCLASS.

DATA go_veh TYPE REF TO lcl_vehicle. "참조변수
DATA gv_fuel TYPE i.

START-OF-SELECTION.

  CREATE OBJECT go_veh
    EXPORTING
      iv_model = 'SM7'. "객체생성

  gv_fuel = go_veh->estimate_fuel( 40 ).

  WRITE 'Test'.
