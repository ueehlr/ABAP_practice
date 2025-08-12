*&---------------------------------------------------------------------*
*& Report ZRA01W1210
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1212.

CLASS lcl_std DEFINITION.
  PUBLIC SECTION. "
    DATA : stdno(8)  TYPE n, "이런애들을 Instance Attribute
           sname(40).
    class-DATA : tot_cnt TYPE i. "Class Attribute =  Statice Attribute

ENDCLASS.


DATA : go_std1  TYPE REF TO lcl_std,
       go_std2 LIKE go_std1.

START-OF-SELECTION.
  CREATE OBJECT go_std1.
*  go_std1->tot_cnt = '1'. "Static Attibute에 1 대입 (이 방법은 안좋음)
  lcl_std=>tot_cnt = '1'. "클래스접근이여서 => 사용
*  lcl_std=>stdno = '2510001'. "이건 불가 -> stdno는 인스턴스여서 어떤 객체의 stdno인지 몰라서 오류남
  CREATE OBJECT go_std2.
  WRITE go_std2->tot_cnt.
