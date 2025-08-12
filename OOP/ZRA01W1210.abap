*&---------------------------------------------------------------------*
*& Report ZRA01W1210
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1210.

CLASS lcl_std DEFINITION. "클래스 정의 -> <선언부>

  PUBLIC SECTION. "
    DATA : stdno(8)  TYPE n, "학생번호  "Atrribute 선언(필드)
           sname(40). "학생명

ENDCLASS.

DATA : go_std TYPE REF TO lcl_std.  "객체변수 선언 -> 참조변수

START-OF-SELECTION.
  CREATE OBJECT go_std. "객체생성
  go_std->stdno = '25100001'. "go_std객체의 stdno변수에 '25100001' 값 할당
  CLEAR go_std.
  CREATE OBJECT go_std. "객체 한번 더 생성
  WRITE : go_std->stdno. "출력 : 25100001
