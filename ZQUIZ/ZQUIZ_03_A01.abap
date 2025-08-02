*&---------------------------------------------------------------------*
*& Report ZQUIZ_03_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZQUIZ_03_A01.

DATA sum TYPE i.
DATA val TYPE i.

PARAMETERS num TYPE i.
PARAMETERS mode TYPE c LENGTH 1.  "O: odd 홀, E: Even짝

*Number 유효성체크
IF num > 1000 or num < 0.
  WRITE: 'number is not valid!'.
  exit.
ENDIF.

*Mode 유효성 체크
IF mode <> 'O' AND  mode <>'E'.
  WRITE: 'mode is not valid!'.
  exit.
ENDIF.

*case문으로도 작성해보기
*CASE .
*	WHEN .
*	WHEN .
*	WHEN OTHERS.
*ENDCASE.


DO num TIMES.
  val = sy-index.
  IF mode = 'O' and val mod 2 = 1.
    SUM = sum + val.
  ELSEIF mode = 'E' and val mod 2 = 0.
    sum = sum + val.
  ENDIF.
ENDDO.

WRITE: sum .
