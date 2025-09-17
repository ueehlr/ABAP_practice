*&---------------------------------------------------------------------*
*&  Include           ZRMKBDCVD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_EXCEL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_excel_data .

* 엑셀에 ROW / COL / VALUE가 저장되는 구조체 만들기
  DATA : lt_excel TYPE TABLE OF alsmex_tabline,
         ls_excel LIKE LINE OF lt_excel.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = pa_file
      i_begin_col             = 1 "열
      i_begin_row             = 2 "행
      i_end_col               = 9
      i_end_row               = 1000
    TABLES
      intern                  = lt_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE e398(00) WITH '엑셀 업로드 실패. 파일을 확인하세요.'.
  ENDIF.

  LOOP AT lt_excel INTO ls_excel.
    CASE ls_excel-col.
      WHEN '1'.
        gs_data-lifnr = ls_excel-value.
      WHEN '2'.
        gs_data-vorgn = ls_excel-value.
      WHEN '3'.
        gs_data-depid = ls_excel-value.
      WHEN '4'.
        gs_data-vtype = ls_excel-value.
      WHEN '5'.
        gs_data-vname = ls_excel-value.
      WHEN '6'.
        gs_data-vstra = ls_excel-value.
      WHEN '7'.
        gs_data-vpstl = ls_excel-value.
      WHEN '8'.
        gs_data-vphon = ls_excel-value.
      WHEN '9'.
        gs_data-vpblk = ls_excel-value.
    ENDCASE.

    AT END OF row. "한 줄의 필드를 다 채웠을때, 다음줄로 이동.
      "왜냐면 row=행(한줄) / col=열(필드)이기 때문에
      APPEND gs_data TO gt_data.
      CLEAR gs_data.
    ENDAT. "AT END OF row. 이거 닫아줌
    CLEAR ls_excel.
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

  "스크린100
  CLEAR : gt_bdc, gs_bdc.
  gs_bdc-program = 'SAPMZMK01VD'. "모듈풀 프로그램명
  gs_bdc-dynpro = '100'. "화면번호
  gs_bdc-dynbegin = 'X'. "화면의 첫줄표시 -> 'X' (화면 시작 표시)
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'BDC_OKCODE'.
  gs_bdc-fval = '=CREATE'. "필드입력
  APPEND gs_bdc TO gt_bdc.

  "스크린200
  CLEAR gs_bdc.
  gs_bdc-program = 'SAPMZMK01VD'.
  gs_bdc-dynpro = '200'.
  gs_bdc-dynbegin = 'X'.
  APPEND gs_bdc TO gt_bdc.

**
  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VTYPE'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VORGN'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-DEPID'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VTYPE'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VNAME'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VPHON'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VSTRA'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.

**

  CLEAR gs_bdc.
  gs_bdc-fnam = 'gs_data-VTYPE'.
  gs_bdc-fval = 'O'.
  APPEND gs_bdc TO gt_bdc.


  CLEAR gs_bdc.
  gs_bdc-fnam = 'BDC_OKCODE'.
  gs_bdc-fval = '=SAVE'.
  APPEND gs_bdc TO gt_bdc.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F4_DATA_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_data_file .

  DATA : lt_file TYPE filetable,
         ls_file TYPE file_table,
         lv_rc   TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    CHANGING
      file_table = lt_file
      rc         = lv_rc.

  READ TABLE lt_file INTO ls_file INDEX 1.
  IF sy-subrc = 0.
    pa_file = ls_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_data . "필드에 대한 유효성 검사

  LOOP AT gt_data INTO gs_data.

*  1) 필수값 입력 검증
    IF gs_data-vorgn IS INITIAL OR gs_data-depid IS INITIAL OR gs_data-vtype IS INITIAL
    OR gs_data-vname IS INITIAL OR gs_data-vphon IS INITIAL.
      APPEND gs_data TO gt_error.
      CONTINUE. "다음행 검증으로 넘어감
    ENDIF.

*&---------------------------------------------------------------------*

* 2) 입력값 검증
    "우편번호 5자리
    DATA : lv_length TYPE i. "<우편번호> 길이 저장
    lv_length = strlen( gs_data-vpstl ).
    IF gs_data-vpstl IS NOT INITIAL.
      IF lv_length <> 5.
        APPEND gs_data TO gt_error. CONTINUE.
      ENDIF.
    ENDIF.

    "구매부만 선택 가능
    IF gs_data-depid+0(3) <> 'MKP'.
      APPEND gs_data TO gt_error. CONTINUE.
    ENDIF.

    "전화번호 형식 검증
    DATA: lv_phone TYPE string, "전화번호 임시 변수
          lo_regex TYPE REF TO cl_abap_regex,
          lo_match TYPE REF TO cl_abap_matcher. "문자열에(lv_phone) 맞는지 검증

    lv_phone = gs_data-vphon. "화면 입력값 임시 변수에 담음

    CREATE OBJECT lo_regex "정규표현식식: 휴대폰(010)/서울(02)/기타지역(0xx)
      EXPORTING
        pattern = '^(010-\d{4}-\d{4}|02-\d{3}-\d{4}|0\d{2}-\d{3}-\d{4})$'.

    lo_match = lo_regex->create_matcher( text = lv_phone ).

    IF lo_match->match( ) = abap_true. "검증 성공 → 화면 필드에 반영
      gs_data-vphon = lv_phone.
    ELSE.
      APPEND gs_data TO gt_error.
      CONTINUE.
    ENDIF.

*&---------------------------------------------------------------------*
*    검증에 최종 통과한 한 행 -> gs_data
    APPEND gs_data TO gt_valid. "통과한 건에 대해서 -> 검증완료 인터널테이블에 넣어줌

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM insert_data .

  DATA : lv_num TYPE i,
         lv_success TYPE i.
  lv_num = lines( gt_valid ).

  WRITE |유효한데이터: { lv_num }건|.

  LOOP AT gt_valid INTO gs_valid.

    CLEAR gt_bdc.

    "dynpro 세팅
    PERFORM bdc_dynpro USING 'SAPMZMK01VD' '0100'.
    PERFORM bdc_field USING 'BDC_OKCODE' '=CREATE'.
    PERFORM bdc_dynpro USING 'SAPMZMK01VD' '0200'.
*    PERFORM bdc_field USING 'ZSMK01VD01-LIFNR' gs_valid-lifnr. "-> 화면에 존재하지 않기 때문에 없는게 맞음 -> BDC는 화면기준으로 진행하기 때문에
    PERFORM bdc_field USING 'ZSMK01VD01-VORGN' gs_valid-vorgn.
    PERFORM bdc_field USING 'ZSMK01VD01-DEPID' gs_valid-depid.
    PERFORM bdc_field USING 'ZSMK01VD01-VTYPE' gs_valid-vtype.
    PERFORM bdc_field USING 'ZSMK01VD01-VNAME' gs_valid-vname.
    PERFORM bdc_field USING 'ZSMK01VD01-VSTRA' gs_valid-vstra.
    PERFORM bdc_field USING 'ZSMK01VD01-VPSTL' gs_valid-vpstl.
    PERFORM bdc_field USING 'ZSMK01VD01-VPHON' gs_valid-vphon.
*    PERFORM bdc_field USING 'ZSMK01VD01-VPBLK' gs_valid-vpblk. "-> 화면에 존재하지 않기 때문에 없는게 맞음 -> BDC는 화면기준으로 진행하기 때문에


    " 저장 버튼
    PERFORM bdc_field USING 'BDC_OKCODE' '=SAVE'.

    " 트랜잭션 실행
    CALL TRANSACTION 'ZMK01VD'
      USING gt_bdc
      MODE 'N'
      MESSAGES INTO gt_msg.

    " 실행 결과 확인
    IF sy-subrc = 0.
      lv_success = lv_success + 1.
      WRITE: / |성공: { gs_valid-VORGN }|.
    ELSE.
      WRITE: / |실패: { gs_valid-VORGN }|.
    ENDIF.
  ENDLOOP.

  WRITE: |성공: { lv_success }건|.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0449   text
*      -->P_0450   text
*----------------------------------------------------------------------*
*PERFORM bdc_dynpro USING 'ZSMK01VD01' '0100'.
FORM bdc_dynpro USING p_program TYPE program
                       p_dynpro TYPE dynpnr. "dynpnr -> 스크린넘버 Data ele.

  CLEAR : gs_bdc.
  gs_bdc-program = p_program. "모듈풀 프로그램명
  gs_bdc-dynpro = p_dynpro. "화면번호
  gs_bdc-dynbegin = 'X'. "dynpro 시작표시 -> 'X' (화면 시작 표시)
  APPEND gs_bdc TO gt_bdc.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BDC_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0454   text
*      -->P_GS_VALID_LIFNR  text
*----------------------------------------------------------------------*
FORM bdc_field  USING  p_fnam TYPE fnam
                       p_fval TYPE any.

  CLEAR gs_bdc.
  gs_bdc-fnam = p_fnam.
  gs_bdc-fval = p_fval.
  APPEND gs_bdc TO gt_bdc.


ENDFORM.
