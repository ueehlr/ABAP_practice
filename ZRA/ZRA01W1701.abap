*&---------------------------------------------------------------------*
*& Report ZRA01W1701
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1701.

DATA : gv_d1 TYPE sy-datum,
       gv_d2 TYPE sy-datum.

FIELD-SYMBOLS <fs> TYPE any.
ASSIGN gv_d1 TO <fs>.
gv_d1 = <fs>.

<fs> = sy-datum. "sy-datum이 값은 20250819의 값

ASSIGN gv_d2 TO <fs>.
<fs> = gv_d1. "gv_d1값을 fs에 넣음

WRITE : gv_d1, gv_d2.
