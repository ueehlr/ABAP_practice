*&---------------------------------------------------------------------*
*& Report ZBC400_A01_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_compute.

TYPES pa_int TYPE i.
TYPES pa_op TYPE c LENGTH 10.

*계산한 값 담을거 (계산을 위한 변수)
DATA gv_result TYPE p LENGTH 16 DECIMALS 2.


PARAMETERS : pa_int1 TYPE pa_int, "숫자1
             pa_int2 TYPE pa_int, "숫자2
             pa_op   TYPE pa_op. "연산자

PERFORM get_calcul USING pa_int1 pa_int2 pa_op CHANGING gv_result.

*&---------------------------------------------------------------------*
*&      Form  GET_CALCUL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PA_INT1  text
*      -->P_PA_INT2  text
*      -->P_PA_OP  text
*      <--P_GV_RESULT  text
*----------------------------------------------------------------------*
FORM get_calcul  USING    pa_int1
                          pa_int2
                          pa_op
                 CHANGING gv_result.


*잘못된 연산자 기입시 오류메시지
  IF pa_op <> '+' AND
    pa_op <> '-' AND
    pa_op <> '*'AND
    pa_op <> '/' .
    WRITE: / '잘못된 연산자입니다.'.
    RETURN.
  ENDIF.

*0으로 나누기 하려고 하면 오류메시지
  " 0으로 나누기 방지
  IF pa_op = '/' AND pa_int2 = 0.
    WRITE: / '0으로 나눌 수 없습니다.'.
    RETURN.
  ENDIF.

  CASE pa_op.
    WHEN '+'.
      gv_result = pa_int1 + pa_int2.
    WHEN '-'.
      gv_result = pa_int1 - pa_int2.
    WHEN '*'.
      gv_result = pa_int1 * pa_int2.
    WHEN '/'.
      gv_result = pa_int1 div pa_int2.
  ENDCASE.

  WRITE: 'Result : ' , gv_result.

ENDFORM.