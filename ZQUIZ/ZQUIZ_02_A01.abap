*&---------------------------------------------------------------------*
*& Report ZQUIZ_02_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_02_a01.

DATA t_date TYPE d. "오늘날짜
t_date = sy-datum.

DATA p_age1 TYPE i. "일반나이
DATA p_age2 TYPE i. "만나이

PARAMETERS : pa_fname TYPE c LENGTH 32 , "이름
             pa_lname TYPE c LENGTH 16 , "성
             pa_birth TYPE d, "생년월일 2001.04.21
             mode  TYPE c LENGTH 2. "옵션1 / 옵션2 *옵션 2는 만나이

*옵션 1 -> 일반나이
p_age1 = t_date - pa_birth.
p_age1 = p_age1 / 365 + 1 .
*옵션 2 -> 만나이
p_age2 = t_date - pa_birth.
p_age2 = p_age2 / 365 .

If mode = 1 .
  WRITE : 'Hi!' , pa_fname , pa_lname , 'Korean age is', p_age1 .
ELSEIF mode = 2.
  WRITE : 'Hi!' , pa_fname , pa_lname ,'Korean legal age is', p_age2 .
ENDIF.


* 출력문
*WRITE : 'Hi!' , pa_fname , pa_lname , 'Korean age is', p_age1 .
*WRITE : 'Hi!' , pa_fname , pa_lname ,'Korean legal age is', p_age2 .
*WRITE : 'Your age is' , p_age1.
*WRITE : 'Your age is' , p_age2.
