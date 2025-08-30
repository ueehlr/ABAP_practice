*&---------------------------------------------------------------------*
*& Include MZA01901TOP                                       Module Pool      SAPMZA01901
*&
*&---------------------------------------------------------------------*
PROGRAM sapmza01901.

"참고
"ZTB0001 -> 사원테이블

*Common
TABLES zta01m01. "항공사별 담당사원 Table
TABLES zta01m02. "output테이블,
TABLES zta01m03. "항공사+직원Info 모음

DATA : gt_emp TYPE TABLE OF zta01m02, "Ouput 테이블
       gs_emp LIKE LINE OF gt_emp.

*DATA : gt_insert TYPE TABLE OF ZTA01M01, "Insert 테이블
*       gs_insert like LINE OF gt_insert.
*DATA : gs_zta01m01 TYPE zta01m01,
DATA : gs_insert TYPE zta01m01,
       gt_insert TYPE TABLE OF zta01m01.

  DATA : gt_value TYPE TABLE OF dd07v,
         gs_value LIKE LINE OF gt_value.


"스크린 400에서 Output
TABLES : scarr, ztb0001.
DATA : gt_info TYPE TABLE OF zta01m03,
       gs_info LIKE LINE OF gt_info.


*ALV
DATA : go_con TYPE REF TO cl_gui_custom_container,
       go_alv TYPE REF TO cl_gui_alv_grid.

DATA : gs_layo TYPE lvc_s_layo.

DATA : gt_fcat TYPE lvc_t_fcat,
       gs_fcat TYPE LINE OF lvc_t_fcat.

DATA : gs_sort TYPE lvc_s_sort,
       gt_sort TYPE lvc_t_sort.
