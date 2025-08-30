*&---------------------------------------------------------------------*
*& Module Pool       SAPMZA01901
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


INCLUDE MZA01901_1TOP.
*INCLUDE MZA01901TOP                             .    " global Data

INCLUDE MZA01901_1O01.
* INCLUDE MZA01901O01                             .  " PBO-Modules
INCLUDE MZA01901_1I01.
* INCLUDE MZA01901I01                             .  " PAI-Modules
INCLUDE MZA01901_1F01.
* INCLUDE MZA01901F01                             .  " FORM-Routines

LOAD-OF-PROGRAM.
 PERFORM set_default. "기본 설정
