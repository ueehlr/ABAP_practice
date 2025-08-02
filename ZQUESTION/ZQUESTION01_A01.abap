*&---------------------------------------------------------------------*
*& Report ZQUESTION01_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquestion01_a01.

* 0725 _ 제출본 : ZQUESTION01_A01
* 구현 못한 복사본으로 구현 : ZQUESTION01_A01_1


DATA ddays TYPE i. "비행까지 남은 날짜
DATA lv_class_text TYPE string. "좌석클래스 저장 : 비즈니스,이코노미,..
DATA lv_passname TYPE sbook-passname. "숭객이름 없을떄
DATA lv_year TYPE c LENGTH 4. "년도만 잘라서 저장

PARAMETERS : pa_carr TYPE spfli-carrid, "key값
             pa_conn TYPE spfli-connid. "key값

SELECT-OPTIONS : so_tdays FOR sy-datum. "오늘날짜 ~ xx.12.31


**************[ 이벤트 ]
INITIALIZATION.

*기본날짜초기화
  so_tdays-low = sy-datum.
  lv_year = sy-datum+0(4). "년도만 잘라서 문자로 저장
  CONCATENATE lv_year '1231' INTO so_tdays-high.



START-OF-SELECTION.


*****************


*라인타입 구성 (변수가 어떤 모양새로 들어갈건지)
  TYPES : BEGIN OF t_book,
            fldate     TYPE sbook-fldate, "비행날짜
            bookid     TYPE sbook-bookid, "예약번호
            customid   TYPE sbook-customid, "고객ID
            name       TYPE scustom-name, "고객이름
            class      TYPE sbook-class, "좌석 클래스
            order_date TYPE sbook-order_date,  "예매날짜
            ddays      TYPE i,
            passname   TYPE sbook-passname,
            cancelled  TYPE sbook-cancelled,
          END OF t_book.


  DATA gs_book TYPE t_book. "워크에리아(구조체)
  DATA gt_book TYPE STANDARD TABLE OF t_book. "인터널 테이블

*값 넣어주기
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

*비행날계산
  LOOP AT gt_book INTO gs_book. "비행날까지 남은날 계산
    gs_book-ddays = gs_book-fldate - gs_book-order_date.
    MODIFY gt_book FROM gs_book TRANSPORTING ddays.
  ENDLOOP.

*좌석클래스 계산
  LOOP AT gt_book INTO gs_book.
    " 각 행에 대해 클래스 텍스트 계산
    CASE gs_book-class.
      WHEN 'Y'. lv_class_text = 'Economy'.
      WHEN 'F'. lv_class_text = 'First'.
      WHEN 'C'. lv_class_text = 'Business'.
      WHEN OTHERS. lv_class_text = 'Unknown'.
    ENDCASE.
  ENDLOOP.



*****************************[ 출력 ]
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

    " Passenger Name 처리
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

    "Passenger Name이 비었을 경우
    IF gs_book-passname IS INITIAL.
      WRITE: lv_passname COLOR COL_GROUP.
    ELSE.
      WRITE: lv_passname.
    ENDIF.

    WRITE: gs_book-cancelled.

ENDLOOP.
