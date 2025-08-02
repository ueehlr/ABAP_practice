*&---------------------------------------------------------------------*
*& Report ZSTUDYA01W0101
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTUDYA01W0101.

DATA age TYPE c LENGTH 7. "냥이나이

PARAMETERS pa_name TYPE c LENGTH 30.
PARAMETERS pa_date TYPE d.
PARAMETERS pa_gend TYPE c LENGTH 7.

*입력값체크
IF pa_name = ''.
  WRITE : 'Cat Name을 입력하세요'.
ELSEIF pa_date =''.
  WRITE  : 'Birth Date을 입력하세요'.
ELSEIF pa_date > sy-datum.
  WRITE  : '생일 오류'.
ENDIF.

*성별분기
IF pa_gend = 'M'.
  pa_gend = 'Male'.
ELSEIF pa_gend = 'F'.
  pa_gend = 'Female'.
ELSEIF pa_gend <> 'M' and pa_gend <> 'F'.
    WRITE : '올바른 성별 표시(M of F)'.
ELSEIF pa_gend = ''.
  WRITE  : '성별 미입력'.
ENDIF.


*나이분기
age = ( sy-datum(4) ) - ( pa_date(4) ) .
IF age < 1.
  age = 'kitten'.
ELSEIF age >= 1 and age < 3.
  age = 'Cat'.
ELSEIF age >= 3 and age < 7.
  age = 'Adult Cat'.
ELSEIF age > 7.
  age = 'Senior Cat'.
ENDIF.


WRITE : 'Cat Info : ' , pa_name, age , pa_gend .