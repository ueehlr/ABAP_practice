*&---------------------------------------------------------------------*
*& Include ZRMKBDCVD_TOP                                     Report ZRMKBDCVD
*&
*&---------------------------------------------------------------------*
REPORT zrmkbdcvd.

* Record_TOP
DATA : gs_bdc TYPE bdcdata,
       gt_bdc TYPE TABLE OF bdcdata.


* Excel Data_TOP
TABLES: sscrfields.

TYPES: BEGIN OF ty_data,
         lifnr TYPE zemk_lifnr,
         depid TYPE zemk_depid,
         vtype TYPE zemk_type,
         vorgn TYPE zemk_orgnm,
         vname TYPE zemk_bpname,
         vstra TYPE zemk_bpaddr,
         vpstl TYPE zemk_bppstlz,
         vphon TYPE zemk_bpphone,
         vpblk TYPE sperr,
       END OF ty_data.
" 실제 변수
DATA: gs_data TYPE ty_data,
      gt_data TYPE TABLE OF ty_data.


PARAMETERS: pa_file TYPE rlgrap-filename. "F4에 쓰일 파라미터

"Selection-Screen에 커스텀버튼 추가하는 선언
SELECTION-SCREEN : FUNCTION KEY 1, FUNCTION KEY 2.


* 유효성 검사 테이블
DATA: gt_valid TYPE TABLE OF ty_data, "유효성검사 성공
      gs_valid TYPE ty_data,
      gt_error TYPE TABLE OF ty_data, "유효성검사 실패
      gs_error TYPE ty_data.

DATA: gt_msg TYPE TABLE OF bdcmsgcoll, "메시지 테이블 (실패띄울거)
      gs_msg TYPE bdcmsgcoll.
