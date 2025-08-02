*&---------------------------------------------------------------------*
*& Report ZQUESTION01_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquestion01_a01_1.
*구현 못한거 마저 구현하기~. (250727)


INCLUDE <icon>. "아이콘출력 ->아이콘 상수 가능하게 함
INCLUDE zquestion01_a01_1TOP.

*이벤트 시작
INITIALIZATION.
  PERFORM set_date. "기본날짜초기화

AT SELECTION-SCREEN.
  PERFORM check-authority."조회권한_권한체크

START-OF-SELECTION.
  PERFORM get_data. "값 넣어주기
  PERFORM flightdate_cal. "비행날계산
  PERFORM class_cal. "좌석클래스 계산
  PERFORM write. "출력문




*&---------------------------------------------------------------------*
*&      Form  GETWRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write .

* 조건 추가된 출력
  WRITE : | Flight Date    Booking    ID        Name      Class      Order Date           Days  Passenger Name          Cancelled |.
  ULINE.
  LOOP AT gt_book INTO gs_book.

    " 좌석 클래스 텍스트 변환
    CASE gs_book-class.
      WHEN 'Y'. lv_class_text = 'Economy'.
      WHEN 'F'. lv_class_text = 'First'.
      WHEN 'C'. lv_class_text = 'Business'.
      WHEN OTHERS. lv_class_text = 'Unknown'.
    ENDCASE.


**출력분기
    " Passenger Name 빈값 노랑색으로 출력
    IF gs_book-passname IS INITIAL.
      lv_passname = 'Unknown'.
    ELSE.
      lv_passname = gs_book-passname.
    ENDIF.

    " 출력
    WRITE: / gs_book-fldate,
             gs_book-bookid,
             gs_book-customid,
             gs_book-name,
             lv_class_text,
             gs_book-order_date,
             gs_book-ddays.

    "색상 바꾸는 부분
    IF gs_book-passname IS INITIAL.
      WRITE: lv_passname COLOR COL_GROUP.
    ELSE.
      WRITE: lv_passname.
    ENDIF.

    "취소건 아이콘 출력
    IF gs_book-cancelled = 'X'.
      WRITE: icon_cancel AS ICON.
    ELSE.
      WRITE: gs_book-cancelled.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLASS_CAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM class_cal .

  "좌석클래스 계산
  LOOP AT gt_book INTO gs_book.
    " 각 행에 대해 클래스 텍스트 계산
    CASE gs_book-class.
      WHEN 'Y'. lv_class_text = 'Economy'.
      WHEN 'F'. lv_class_text = 'First'.
      WHEN 'C'. lv_class_text = 'Business'.
      WHEN OTHERS. lv_class_text = 'Unknown'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FLIGHTDATE_CAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM flightdate_cal .

  LOOP AT gt_book INTO gs_book. "비행날까지 남은날 계산
    gs_book-ddays = gs_book-fldate - gs_book-order_date.
    MODIFY gt_book FROM gs_book TRANSPORTING ddays.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT sbook~fldate
         sbook~bookid
         sbook~customid
         scustom~name
         sbook~class
         sbook~order_date
         sbook~passname
         sbook~cancelled
  INTO CORRESPONDING FIELDS OF TABLE gt_book
  FROM sbook INNER JOIN scustom
  ON sbook~customid = scustom~id
  WHERE sbook~carrid = pa_carr
    AND sbook~connid = pa_conn
    AND sbook~fldate IN so_tdays
  ORDER BY sbook~cancelled DESCENDING
    sbook~order_date ASCENDING.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK-AUTHORITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check-authority .

  AUTHORITY-CHECK OBJECT 'S_CARRID'
  ID 'CARRID' FIELD pa_carr
  ID 'ACTVT' FIELD '03'. "-> 조회권한 있는지 확인 (조회권한 03)
  IF sy-subrc <> 0.
    MESSAGE : 'You do not have permission to view.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_date .

  DATA ls_range LIKE LINE OF so_tdays. "구조체 (날짜입력칸에 넣어줄)w

  so_tdays-low = sy-datum.
  lv_year = sy-datum+0(4). "년도만 잘라서 문자로 저장
  CONCATENATE lv_year '1231' INTO so_tdays-high.
  APPEND ls_range TO so_tdays.

ENDFORM.
