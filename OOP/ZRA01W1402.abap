*&---------------------------------------------------------------------*
*& Report ZRA01W1401
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1402.

DATA go_veh TYPE REF TO zcl_vehicle_a01.
DATA gv_fuel TYPE i.

START-OF-SELECTION.

  CREATE OBJECT go_veh
    EXPORTING
      iv_model = 'SM7'. "객체생성

  gv_fuel = go_veh->estimate_fuel( 40 ).

  WRITE gv_fuel.
