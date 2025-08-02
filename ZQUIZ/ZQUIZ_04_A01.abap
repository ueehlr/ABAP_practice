*&---------------------------------------------------------------------*
*& Report ZQUIZ_04_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_04_a01.


DATA pa_vaca TYPE i. "연차개수
DATA pa_rank TYPE i. "입사 년차
DATA pa_vayear TYPE i.  "연차 받는 년차
*DATA pa_date TYPE d.


PARAMETERS pa_name TYPE c LENGTH 32 OBLIGATORY. "사원명
PARAMETERS pa_date TYPE d OBLIGATORY. "입사일

pa_vaca = 15. "기본 연차
pa_rank = sy-datum+0(4) - pa_date+0(4). "현재 날짜에서 년수만 -> 입사날짜의 년수만 분기 =>경력몇년차 (직급

*입사일 제약조건
IF pa_date > sy-datum. "sy-datum 오늘날짜
  WRITE : '입사일은 오늘 날짜보다 클 수 없습니다.'.
  EXIT.
ENDIF.

*2년마다 연차 추가되는 로직
*IF pa_rank / 2 = 1. -> 이렇게 해버리면 반복문이 돌지 않아오!, 그리고 /이거는 1.5 이렇게 나왔을때 반올림 해버림, div해야 반올림 안하는 나누기~
*  pa_vaca = pa_vaca + 1.
*  IF pa_vaca = 20.
*    EXIT.
*  ENDIF.
*ENDIF.

DO pa_rank TIMES.
  IF sy-index MOD 2 = 0 . "짝수년도
    pa_vaca = pa_vaca + 1.
    IF pa_vaca = 20.
      EXIT.
      ENDIF.
    ENDIF.
  ENDDO.

  WRITE : pa_name, 'you have' , pa_vaca, 'days.'.
