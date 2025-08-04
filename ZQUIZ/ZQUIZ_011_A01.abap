*&---------------------------------------------------------------------*
*& Report ZQUIZ_011_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_011_a01.

*사용할 테이블 : BC400_S_BOOKING
*메소드/함수 : CL_BC400_FLIGHTMODEL / get bookings

*라인타입 정의
TYPES : BEGIN OF t_flyinfo,

  end of t_flyinfo.

*필요한 데이터 선언
DATA : gt_flyinfo TYPE BC400_T_BOOKINGS, "인터널 테이블
      gs_flyinfo TYPE BC400_S_BOOKING,  "work area
      custtype TYPE S_CUSTTYPE, " 비즈니스: B / 프라이빗 : P
      total TYPE i, "총예약건수 = 확정 + 취소
      confirm TYPE , "확정
      cancel TYPE S_CANCEL, "취소
      percent TYPE f LENGTH 4 DECIMALS 2.




*고객에게 입력받기 ( 항공사코드, 항공편, 항공일자 )
PARAMETERS : pa_carrier TYPE s_carr_id, "항공사코드
             pa_conn    TYPE s_conn_id, "항공편
             pa_date    TYPE s_date.  "항공일자

*booking id에 넘길거


*데이터 취득 기능
TRY.
CALL METHOD cl_bc400_flightmodel=>get_bookings
  EXPORTING
    iv_carrid   = pa_carrier
    iv_connid   = pa_conn
    iv_fldate   = pa_date
  IMPORTING
    et_bookings = .

 CATCH cx_bc400_no_data .
 CATCH cx_bc400_no_auth .
ENDTRY.
