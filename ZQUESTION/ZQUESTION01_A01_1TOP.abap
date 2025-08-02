*&---------------------------------------------------------------------*
*&  Include           ZQUESTION01_A01_1TOP
*&---------------------------------------------------------------------*

"DATA ddays TYPE C LENGTH 11. "비행까지 남은 날짜
DATA ddays TYPE i. "비행까지 남은 날짜
DATA lv_class_text TYPE string. "좌석클래스 저장 : 비즈니스,이코노미,..
DATA lv_passname TYPE sbook-passname. "숭객이름 없을떄
DATA lv_year TYPE c LENGTH 4. "년도만 잘라서 저장

PARAMETERS : pa_carr TYPE spfli-carrid OBLIGATORY, "key값,항공사id
             pa_conn TYPE spfli-connid OBLIGATORY. "key값,항공편id

SELECT-OPTIONS : so_tdays FOR sy-datum. "->날짜입력칸 (오늘날짜 ~ xx.12.31)

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
