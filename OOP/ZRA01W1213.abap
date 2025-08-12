*&---------------------------------------------------------------------*
*& Report ZRA01W1210
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1213.

CLASS lcl_emp DEFINITION. "로컬클래스 정의

  PUBLIC SECTION. "Instance Attribute
    CLASS-DATA : tot_cnt TYPE i. "총사원수 "Static Attibute
    DATA : prnr  TYPE ztb0001-pernr,
           ename TYPE zeb00_ename. "Data ele.로 바로 사용 가능

*  PROTECTED SECTION.
*
*  PRIVATE SECTION.

ENDCLASS.

DATA : go_emp TYPE REF TO lcl_emp. "아밥은 절차지향적이기 때문에 class정의 후에 정의 가능
*DATA : gt_emp TYPE TABLE OF REF TO lcl_emp.
DATA : gt_emp LIKE TABLE OF go_emp. "위에줄이랑 같은 내용

START-OF-SELECTION.
  CREATE OBJECT go_emp. "객체1 생성
  go_emp->prnr = '23010001'.
  go_emp->ename = '강길동'.
  go_emp->tot_cnt = 1 + lcl_emp=>tot_cnt. "나쁜문법 ..?
  APPEND go_emp TO gt_emp. "객체의 내용을 인터널테이블 안에 넣어줌 -> 자연스럽게 Casting이루어짐
  CLEAR go_emp. "인터널테이블 안에 넣어줬으니까 객체 클리어

  CREATE OBJECT go_emp. "새로운 객체 생성 (위의 go_emp는 소멸됨)
  go_emp->prnr = '23010002'.
  go_emp->ename = '신길동'.
  go_emp->tot_cnt = 1 + lcl_emp=>tot_cnt.
  APPEND go_emp TO gt_emp. "두번째 객체 인터널테이블에 담아줌
  CLEAR go_emp.

  LOOP AT gt_emp INTO go_emp.
    WRITE : go_emp->tot_cnt,
            go_emp->prnr,
            go_emp->ename.
    NEW-LINE.
*    CLEAR go_emp.
  ENDLOOP.

  WRITE : go_emp->tot_cnt,
          go_emp->prnr,
          go_emp->ename.
