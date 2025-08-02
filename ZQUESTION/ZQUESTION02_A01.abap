*&---------------------------------------------------------------------*
*& Report ZQUESTION02_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquestion02_a01.

INCLUDE <icon>.

*임시변수
DATA : index        TYPE c, "이름 그룹바이한거 인텍스 넣는변수
       lv_prev_name TYPE scustom-name, "이전고객명: lv_prev_name, 현재: gs_output-name
       lv_nr        TYPE i VALUE 1, "nr담기 전에 담는 임시변수
       lv_id        TYPE i VALUE 0. "고객아이디 임시변수

* bestcustom
DATA: lv_best_name TYPE scustom-name,
      lv_best_n    TYPE i VALUE 0,
      lv_count     TYPE i VALUE 0,
      lv_nothers   TYPE i VALUE 0.

*      classstr TYPE string.  "이코노미 비즈니스



"이전고객명: lv_prev_name, 현재: gs_output-name

"라인타입 정의
TYPES : BEGIN OF ts_output,
          id         TYPE scustom-id,
          nr         TYPE i,
          name       TYPE scustom-name,
          order_date TYPE sbook-order_date,
          class      TYPE sbook-class, "출력시 classt 사용
          classt     TYPE c LENGTH 10,
          invoice    TYPE sbook-invoice,
          luggweight TYPE sbook-luggweight,
          fldate     TYPE sbook-fldate,
          days       TYPE i, "남은날짜 계산해서 담아주는 변수
        END OF ts_output.
TYPES : tt_output TYPE TABLE OF ts_output. "Table Type : tt_output
" 인터널테이블 타입(전체):tt_output , 구조(한줄): ts_output

* 인터널 테이블: gt_output, 워크에리아 :gs_output
DATA: gt_output TYPE tt_output,
      gs_output TYPE ts_output.


* Variable(출력 조건 위한 변수)

"사용자입력
TABLES: scustom.
TABLES: sbook.
SELECT-OPTIONS so_id FOR scustom-id OBLIGATORY.
SELECT-OPTIONS so_date FOR sbook-order_date OBLIGATORY.


INITIALIZATION.
  CLEAR so_date[]. " 먼저 테이블 비워주고
  so_date-sign   = 'I'.
  so_date-option = 'BT'.
  so_date-low    = sy-datum+0(4) && '0101'.
  so_date-high   = sy-datum.

  APPEND so_date TO so_date.

*AT SELECTION-SCREEN. -> 권한 (딱히없는듯)

START-OF-SELECTION.
  PERFORM get_output. "selec문
  PERFORM incon. " 아이콘 분기

* 출력
  PERFORM write_ouput.


  PERFORM count_cust.
  PERFORM write_bestcust.







*&---------------------------------------------------------------------*
*&      Form  INCON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM incon .
  "ICON_CHECKED

  "테이블에서, 워크에리아에 한줄씩 빼서 -> 인보이스-아이콘 분기
  LOOP AT gt_output INTO gs_output.
    IF sbook-invoice = 'X'.
      gs_output-invoice = icon_checked.
    ENDIF.
    MODIFY gt_output FROM gs_output.
    CLEAR gs_output-invoice.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_output .

  SELECT id name order_date class invoice luggweight fldate
  INTO  CORRESPONDING FIELDS OF TABLE gt_output
  FROM sbook INNER JOIN scustom
    ON sbook~customid = scustom~id
  WHERE sbook~fldate IN so_date
  AND sbook~customid IN so_id.
    SORT gt_output BY id ASCENDING order_date DESCENDING.

*  cl_demo_output=>display( gt_output ).


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CAL_NR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_ouput. "출력까지
* nr증가 및 name이 바뀔 경우 분기
*DATA(lv_pad) = '           '. "앞에 붙일 공백
*WRITE: lv_pad && sy-lisel.

  LOOP AT gt_output INTO gs_output.

    IF gs_output-id <> lv_id.
      ULINE.
      lv_id = gs_output-id. "id다르니까 담아줌
      WRITE :  gs_output-id.
      WRITE :  gs_output-name.
      SKIP. "한줄건너뛰기
      lv_nr = 1.
    ENDIF.

    DATA classstr TYPE str.

    "Class 분기
    CASE gs_output-class.
      WHEN 'C'.
        classstr = 'Business'.      " 비즈니스
      WHEN 'Y'.
        classstr = 'Economy'.     " 이코노미
      WHEN 'F'.
        classstr = 'First'.        " 퍼스트
    ENDCASE.


*   PERFORM cal_days. "비행까지 남은 날짜 (비행일-주문날짜)
    gs_output-days = CONV i( gs_output-fldate - gs_output-order_date ).
    MODIFY gt_output FROM gs_output TRANSPORTING days.




**************** [ 출력 ]

    WRITE: |{ lv_nr WIDTH = 15 ALIGN = RIGHT }|,"nr
           |{ gs_output-order_date WIDTH = 14 ALIGN = RIGHT }|, " orderDate
           |{ classstr WIDTH = 14 ALIGN = RIGHT }      |."class

    IF gs_output-invoice = 'X'. "invoice(아이콘처리)
      WRITE : icon_checked AS ICON.
    ELSE.
      WRITE : space.
    ENDIF.

    WRITE: |{ gs_output-luggweight WIDTH = 11 ALIGN = RIGHT DECIMALS = 2 } KG|, "lugg.weight
           |{ gs_output-days WIDTH = 15 ALIGN = RIGHT }|." Days Ago

    lv_nr = lv_nr + 1.
    SKIP. "한줄건너뛰기

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  WRITE_BESTCUST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_bestcust .

*      lv_best_name  -> best customer 이름
*      lv_best_n  -> best customer id
*      lv_count   -> nothers 구하기 위한 변수


  SORT gt_output BY name ASCENDING nr DESCENDING. "이름은asc, nr은 desc로 정렬

  LOOP AT gt_output INTO gs_output.
    "첫 등장 고객만 처리 (nr > 0)
    IF gs_output-nr > 0.
      IF gs_output-nr > lv_best_n.
        lv_best_n = gs_output-nr.
        lv_best_name = gs_output-name.
        lv_count = 1.
      ELSEIF gs_output-nr = lv_best_n AND gs_output-name <> lv_best_name.
        lv_count = lv_count + 1.
      ENDIF.
    ENDIF.

  ENDLOOP.

  lv_nothers = lv_count - 1.

  "출력
  ULINE.
  WRITE: / 'Best Customer:', lv_best_n, lv_best_name.
  IF lv_count > 1.
    WRITE: 'and', lv_nothers, 'Others'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COUNT_CUST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM count_cust .

*      lv_best_name TYPE scustom-name, -> best customer 이름
*      lv_best_n    TYPE i VALUE 0, -> best customer 이름
*      lv_nothers   TYPE i VALUE 0.

*  고객 이름별 예약 수 계산 (이전에 계산했던거 지우고 로직 처리하는)
CLEAR: lv_prev_name, lv_nr.
LOOP AT gt_output INTO gs_output.

  IF gs_output-name <> lv_prev_name.
    " 해당 고객이름 COUNT
    lv_nr = 0.
    LOOP AT gt_output INTO DATA(ls_temp) WHERE name = gs_output-name.
      lv_nr = lv_nr + 1.
    ENDLOOP.

    "해당고객 1번인덱스에 예약건수저장
    gs_output-nr = lv_nr.
    MODIFY gt_output FROM gs_output TRANSPORTING nr.
    lv_prev_name = gs_output-name.
  ENDIF.

ENDLOOP.


ENDFORM.
