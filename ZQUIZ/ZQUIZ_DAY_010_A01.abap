*&---------------------------------------------------------------------*
*& Report ZQUIZ_DAY_010_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZQUIZ_DAY_010_A01.

*검색조건에서 고객 ID를 입력 받아서 해당 고객 예약한 총 항공권 건수와 취소한 건수를 출력하는 프로그램을 구현하시오.
*데이터 취득) CL_BC400_FLIGHTMODEL
*Method: get bookings by _cust

*입력 예시
*Customer: 1
*출력 예시
*Customer 1 SAP AG
*Total Bookings:
*32 Count
*Confirm Bookings: 30 Count Cancel Bookings: 2 Count
*아이디와 이름 줄력
*(쥐소된 내역은 CANCELLED 값이 '※인 건이 취소된 건수임


"변수하나씩 정의 (DATA 정의라고 생각하새요)
TYPES: BEGIN OF g_cusinfo,     "->라인 타입 정의 (스트럭쳐 타입)
         ID   TYPE scustom-id,
         NAME TYPE scustom-name,
       END OF g_cusinfo.

*사용자에게 ID받기
PARAMETERS pa_id TYPE BC400_S_BOOKING-CUSTOMID. "scustom에 있는 id만 고객한테 받으려고 type을 테이블로 지정


DATA: gt_bookings TYPE bc400_t_bookings, "
      gs_booking  TYPE bc400_s_booking, "work area
      lv_total    TYPE i, "총집계
      lv_cancel   TYPE i, "취소건수
      lv_confirm  TYPE i, "합계
      gv_name     TYPE scustom-name.

SELECT SINGLE name INTO gv_name FROM scustom WHERE id = pa_id.


* 데이터 취득 메소드 호출
TRY.
CALL METHOD cl_bc400_flightmodel=>get_bookings_by_cust
  EXPORTING
    iv_customid = pa_id
  IMPORTING
    et_bookings = gt_bookings.

 CATCH cx_bc400_no_data .
ENDTRY.

*총계수
lv_total = lines( gt_bookings ).

*고객이름 READ로 뽑기 -> 이미 select문으로 이름 뽑아놨으니까 할 필요x
"-> 왜냐면 이번 경우에는 변수에 넣어뒀으닊까요~.
*READ TABLE gt_bookings INTO gs_booking INDEX 1.
*IF sy-subrc = 0.
*  gv_name = gs_booking-name.
*ENDIF.

* 취소건수 계산
LOOP AT gt_bookings INTO gs_booking.
  IF gs_booking-cancelled = 'X'.
    lv_cancel = lv_cancel + 1.
  ENDIF.
ENDLOOP.

lv_confirm =  lv_total - lv_cancel.

*입력 예시
*Customer: 1
*출력 예시
*Customer 1 SAP AG
*Total Bookings:
*32 Count
*Confirm Bookings: 30 Count Cancel Bookings: 2 Count
*아이디와 이름 줄력
*(쥐소된 내역은 CANCELLED 값이 '※인 건이 취소된 건수임

WRITE : | Total Bookings: { lv_total } |,
/ | Confirm Bookings: { lv_confirm } |,
/ | Count Cancel Bookings: { lv_cancel } |,
/ | ID: { pa_id } |, | NAME: { gv_name } |.
