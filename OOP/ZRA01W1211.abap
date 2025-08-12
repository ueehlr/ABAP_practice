*&---------------------------------------------------------------------*
*& Report ZRA01W1210
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1211.

CLASS lcl_std DEFINITION.

  PUBLIC SECTION. "
    DATA : stdno(8)  TYPE n,
           sname(40).

ENDCLASS.


DATA : go_std  TYPE REF TO lcl_std,
       go_std2 LIKE go_std.  "like 했을떄 value는 안가져옴, 형태만 가져옴

START-OF-SELECTION.
  CREATE OBJECT go_std. "객체생성
  go_std->stdno = '25100001'.
  go_std2 = go_std. "두 개가 같은 객체를 바라봄 -> Casting
  go_std2->sname = 'Kang, SK'.
  WRITE : go_std2->stdno.

  CLEAR go_std.
  CREATE OBJECT go_std.
  go_std->stdno = '25100001'.
