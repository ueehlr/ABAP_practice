*&---------------------------------------------------------------------*
*& Report ZQUESTION01_A01_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquestion01_a01_2.

*Constants (상수선언)
CONSTANTS c_display TYPE c LENGTH 2 VALUE '03'. "권한체크에 필요한 상수 선언

*Type  -> 출력물 기준
*출력물을 기준으로 types 잡기
TYPES : BEGIN OF ts_output,
          fldate     TYPE sbook-fldate, "A  TYPE sbook-A -> 여기 A자리끼리의 이름을 맞춰줘야 편함
          bookid     TYPE sbook-bookid, "
          customid   TYPE sbook-customid,
          name       TYPE scustom-name,
          class      TYPE sbook-class,
          classt     TYPE c LENGTH 10, "클래스를 비즈니, 이코노미 이렇게 바꿔서 넣어줄거
          order_date TYPE sbook-order_date,
          days       TYPE i,
          passname   TYPE sbook-passname,
          cancelled  TYPE sbook-cancelled,
        END OF  ts_output.
TYPES : tt_output TYPE TABLE OF ts_output. "Table Type


*출력 변형을 위한?변수들
** Variable
* Summary Layout
DATA: gv_total  TYPE i,
      gv_cancle TYPE i,
      gv_cofirm TYPE i.
* Early Bird Layout
DATA: gv_early_id   TYPE  scustom-id,
      gv_early_name TYPE scustom-name,
      gv_early_ago TYPE i.
* Booking List Layout
DATA: gt_book TYPE tt_output,
      gw_book LIKE LINE OF gt_book.

*Selection  Screen
PARAMETERS pa_car     TYPE sbook-carrid.
PARAMETERS pa_con     TYPE sbook-connid.
SELECT-OPTIONS so_fld FOR gw_book-fldate.

*Logic
INITIALIZATION.
  PERFORM init_screen.

AT SELECTION-SCREEN.
  "권한체크
  PERFORM  check-auth.

START-OF-SELECTION.
  PERFORM get_bookings.

"출력.
*  PERFORM output_summary.
*  PERFORM output_early.
*  PEFFORM output_bookings.



*Logic
*&---------------------------------------------------------------------*
*&      Form  INIT_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_screen .
  "비행일자 초기화 = 오늘날짜 ~ 올해마지막날짜

  CLEAR so_fld.         "누구를 지우는 것= work area (clear so_fld[]. -> 이거는 인터널 테이블을 지우는거
  so_fld-sign = 'I'.        "Include
  so_fld-option = 'BT'. "       Between
  so_fld-low = sy-datum.         "오늘날짜
  so_fld-high   = sy-datum+0(4) && '1231'.       "올해 마지막일 2025.12.31

  APPEND so_fld TO so_fld. "so_fld 같은 이름이라 생략 가능하지만 넣어주는게 좋음
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK-AUTH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check-auth .

  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD pa_car
           ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e003(zcal_a_01) WITH pa_car.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BOOKINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_bookings .

  "관련테이블 2개 조인
  "원래 컬럼 다 나열하는게 정석(나 원래코드 짠것처럼)
  SELECT *   "<------- 원래는 컬럼 나열하는게 정석임.
   FROM sbook INNER JOIN scustom
     ON sbook~customid = scustom~id
   INTO CORRESPONDING FIELDS OF TABLE gt_book
  WHERE carrid  = pa_car
    AND connid  = pa_con
    AND fldate IN so_fld.

*    gv_total = lines( gt_book ). "토탈취득 방법1
*    gv_total = sy-dbcnt. "토탈취득 방법2

*  "데이터 잘 가져오나 확인 -> 얘는 gt_book에 데이터가 잘 채워지나 검증용니니까 하고 지워도 ok
*  CALL METHOD cl_demo_output=>display_data
*    EXPORTING
*      value  = gt_book.

*검증해보니 gt_book에 days랑 classt만 안채워짐
  "-> 이거는 로직으로채워야함 (로직으로 분기처리해서)
  LOOP AT gt_book INTO gw_book.
    "0)토탈,취소,확정 갯수 계산
    gv_total = gv_total + 1. "토탈취득 방법3

    "취소여부
    CASE gw_book-class.
      WHEN 'X'.
        gv_cancle = gv_cancle + 1.
      WHEN OTHERS.
        gv_cofirm = gv_cofirm + 1.
    ENDCASE.

    "loop 돌면서 채우기
    "1) days 계산하기
    gw_book-days = gw_book-fldate - gw_book-order_date.

    "2) class텍스트로 변한하는거 처리하기
    CASE gw_book-class.
      WHEN 'F'.
        gw_book-classt = 'First'.  "상수로 처리하면 좋음!
      WHEN 'C'.
        gw_book-classt = 'Business'.
      WHEN 'Y'.
        gw_book-classt = 'Economy'.
    ENDCASE.


    "3) 변경한 내용을 인터널 테이블에 반영하기
    MODIFY gt_book FROM gw_book INDEX sy-tabix.
    "인터널테이블 자체가 위에서 변경한다고해서 끝이 아니라,
    "꼭 modify로 넣어줘야 반영되는 구조임
  ENDLOOP.

  "Early Bird 읽기(빨리예약한사람)
  SORT gt_book by days DESCENDING.
  READ TABLE gt_book INTO gw_book INDEX 1.
  IF sy-subrc = 0.
    gv_early_id   = gw_book-customid.
    gv_early_name = gw_book-name.
    gv_early_ago  = gw_book-days.
  ENDIF.

ENDFORM.
