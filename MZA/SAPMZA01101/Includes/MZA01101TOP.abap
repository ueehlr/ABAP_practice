*&---------------------------------------------------------------------*
*& Include MZA01101TOP                                       Module Pool      SAPMZA01102
*&
*&---------------------------------------------------------------------*
PROGRAM sapmza01102.

*Condition에 관련한 변수
*DATA gv_carrid TYPE scarr-carrid. "글로벌변수
*DATA ZBCA01002. "스트럭처 타입 넣어줌 _____ 타입명 잘못만듦;;
TABLES ZSA001002. "Airline에 해당하는것만 띄울라고
TABLES ZBCA01003. "밑에3개 해당하는 것만 띄울라고



*Airline Info
*DATA : BEGIN OF gs_info,
*         carrid   TYPE scarr-carrid,
*         carrname TYPE scarr-carrname,
*         currcode TYPE scarr-currcode,
*       END OF gs_info.
