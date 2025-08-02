*&---------------------------------------------------------------------*
*& Report ZSTUDY_A01_W0202
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstudy_a01_w0202.
INCLUDE zstudy_a01_w0202_top.



*사용할 테이블
*BC400_S_CARRIER
*CARRID
*CARRNAME

*테이블2
*ZBC400_S_FLIGHT
*FLDATE - S_DATE

"날짜 입력해서 그날 항공편 출력하기

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  "사용테이블 : sflight
  " carrid carrname connid fldate price currency
  "carrname  price currency
  PERFORM get_oupput. "서브루틴1
  PERFORM get_output2. "서브루틴2


* 예외처리 - 파라미터 빈값일떄
  IF pa_date IS INITIAL.
    MESSAGE s002(zcal_a_01).
    STOP.
  ENDIF.

  PERFORM get_oupput. "서브루틴1
  PERFORM get_output2. "서브루틴2

  PERFORM write_output. "출력





*&---------------------------------------------------------------------*
*&      Form  GET_OUPPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_oupput .

  SELECT carrid connid fldate price currency
  INTO CORRESPONDING FIELDS OF TABLE gs_info
  FROM sflight
  WHERE fldate = pa_date.

  "예외처리2 - 유효하지 않은값 입력
  IF gs_info IS INITIAL.
    MESSAGE s006(zcal_a_01).
    STOP.
    "리턴이나 스탑 엑시트 이런거 넣어야함 ..! -> 안되면 아예 실행 안되게 해야하니까
  ENDIF.
  """


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_OUTPUT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_output2 .

  LOOP AT gs_info INTO gt_into.
    SELECT SINGLE carrname
      INTO gt_into-carrname
      FROM scarr
      WHERE carrid = gt_into-carrid.

    MODIFY gs_info FROM gt_into.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  WRITE_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_output .

  IF sy-subrc = 0.
    cl_demo_output=>display( gs_info ).
  ENDIF.

ENDFORM.
