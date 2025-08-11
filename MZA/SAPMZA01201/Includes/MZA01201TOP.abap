*&---------------------------------------------------------------------*
*& Include MZA01201TOP                                       Module Pool      SAPMZA01201
*&
*&---------------------------------------------------------------------*
PROGRAM sapmza01201.

"공통변수
DATA ok_code TYPE sy-ucomm.
DATA gv_subrc LIKE sy-ucomm. "성공실패 -> T/F로 하는게 아니라, 이거 아니면 initial value

*DATA gs_cond TYPE ZSA011101. "아밥에서 사용한다는 뜻 -> 개발자가 사용한다는 뜻(=개발자가 임의로
*핸들링할거다)
TABLES ZSA011101. "input "스크린에서 사용한다는 뜻 -> 사용자가 값을 입력할거다.
   "ZSA011101.얘도 스트럭쳐 변수

TABLES ZSA011102. "Connection info -> output
