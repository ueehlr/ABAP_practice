*&---------------------------------------------------------------------*
*&  Include           MZA01901F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_ALV_OBJECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_alv_object .

  IF go_con IS NOT INITIAL.
    RETURN.
  ENDIF.

  CREATE OBJECT go_con
    EXPORTING
*     parent                      =
      container_name              = 'ALL_CON'
*     style                       =
*     lifetime                    = lifetime_default
*     repid                       =
*     dynnr                       =
*     no_autodef_progid_dynnr     =
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE a999(zmbc99) WITH 'Create Container Error'.
  ENDIF.


  CREATE OBJECT go_alv
    EXPORTING
*     i_shellstyle      = 0
*     i_lifetime        =
      i_parent          = go_con
*     i_appl_events     = space
*     i_parentdbg       =
*     i_applogparent    =
*     i_graphicsparent  =
*     i_name            =
*     i_fcat_complete   = SPACE
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE a999(zmbc99) WITH 'Create Container Error'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =
      i_structure_name              = 'ZTA01M02'
*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'
      is_layout                     = gs_layo
*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =
    CHANGING
      it_outtab                     = gt_emp
      it_fieldcatalog               = gt_fcat
      it_sort                       = gt_sort
*     it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DEFAULT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_default .
  "기본조건 설정
  PERFORM set_default_condition.

  "기본 list
  PERFORM get_emp_list USING zta01m01-carrid CHANGING gt_emp.

  "ALV기본설정
  PERFORM set_default_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DEFAULT_CONDITION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_default_condition .

*  zta01m01-carrid = 'AA'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_EMP_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*PERFORM get_emp_list USING zta01m01-carrid gt_emp.
*PERFORM get_emp_list USING zta01m02-carrid gt_emp.


FORM get_emp_list USING VALUE(pv_carrid) TYPE s_carr_id
*                  USING VALUE(변수1) LIKE zta01m01-carrid.
                  CHANGING ct_emp LIKE gt_emp.

  SELECT a~carrid
         b~carrname
         a~armdm
         c~lname
         c~fname
    INTO CORRESPONDING FIELDS OF TABLE ct_emp
    FROM zta01m01 AS a
    INNER JOIN scarr   AS b ON a~carrid = b~carrid
    INNER JOIN ztb0001 AS c ON a~armdm  = c~pernr
    WHERE a~carrid = pv_carrid.

  PERFORM get_concat_name. "이름 합치기


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DEFAULT_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_default_alv .

  PERFORM set_alv_layout.

  PERFORM set_alv_fcat.

  PERFORM set_alv_sort.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_ALV_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_alv_layout .

  CLEAR gs_layo.
*  gs_layo-cwidth_opt = 'X'.
  gs_layo-zebra = 'X'.
  gs_layo-sel_mode = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_ALV_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_alv_fcat .

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
  gs_fcat-coltext = '항공사코드'.
  gs_fcat-just      = 'L'.
  gs_fcat-outputlen = '7'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRNAME'.
  gs_fcat-coltext = '항공사명'.
  gs_fcat-just      = 'L'.
  gs_fcat-outputlen = '15'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ARMDM'.
  gs_fcat-coltext = '담당자'.
  gs_fcat-just      = 'L'.
  gs_fcat-outputlen = '9'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'NAME'.
  gs_fcat-coltext = '담당자명'.
  gs_fcat-just      = 'L'.
  gs_fcat-outputlen = '6'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LNAME'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FNAME'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_ALV_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_alv_sort .



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_NEW_EMP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM insert_new_emp .

  IF zta01m01-armdm IS INITIAL. "사번입력 안했을 경우 화면제어
    MESSAGE i007(zcal_a_01) DISPLAY LIKE 'E'.
    RETURN.
  ELSE. "사번 입력 했을 경우
    INSERT zta01m01 FROM zta01m01.

    IF sy-subrc <> 0. "실패
      MESSAGE i013(zcal_a_01) WITH zta01m01-carrid zta01m01-armdm.
    ELSE. "성공
      COMMIT WORK.
      MESSAGE i014(zcal_a_01) WITH zta01m01-carrid zta01m01-armdm.
    ENDIF.

    PERFORM refresh_display. "데이터 갱신 후 초기화면으로 이동

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHANGE_NEW_EMP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_new_emp .

  "선택된 레코드 담당자 불러오기
  DATA : lt_row TYPE lvc_t_row,
         ls_row LIKE LINE OF lt_row,
         lv_cnt TYPE sy-tabix.


  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_row
*     et_row_no     =
    .

  DESCRIBE TABLE lt_row LINES lv_cnt.

  CASE lv_cnt.
    WHEN '0'. "False
      sy-subrc = 4.
    WHEN '1'.
      READ TABLE lt_row INDEX 1 INTO ls_row.
      CLEAR gs_emp.
      READ TABLE gt_emp INDEX ls_row-index INTO gs_emp.

      SELECT SINGLE carrid armdm
        FROM zta01m01
        INTO CORRESPONDING FIELDS OF zta01m02
        WHERE carrid = gs_emp-carrid AND armdm = gs_emp-armdm.

  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_NEW_EMP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_new_emp .

*  헷갈렸던 부분 : input한 값을 db랑 비교해줘야 하는지 / 화면단이랑 비교해줘야 하는지
*  화면 값으로 비교 해줘야함.
*  아직 db에 반영되기 전이기 때문에 -> db로 비교해봤자 정확히 처리 안됨
*  if문으로 분기처리 해서,
*  해당되면 update타게하고 / 해당이 안되면 return 하던지 빠져나가든지 처리하기
******************************************************************

*  화면이랑 input이랑 비교하는 분기문 -> 체크 먼저
  IF gs_emp-armdm <> zta01m01-armdm.
    "if문에서 참이면 update
    UPDATE zta01m01
      SET armdm = zta01m01-armdm
      WHERE armdm = zta01m02-armdm
      AND carrid = zta01m02-carrid.

    "insert 성공/실패
    IF sy-subrc <> 0. "실패시
      ROLLBACK WORK.
      MESSAGE i016(pn) WITH '담당자 변경에 실패하였습니다.' DISPLAY LIKE 'E'.
      LEAVE TO SCREEN sy-dynnr. "현재 스크린 번호 (sy-dynnr)
    ELSE. "성공시
      COMMIT WORK.
      MESSAGE i012(zcal_a_01) WITH zta01m02-carrid zta01m01-armdm.
      PERFORM refresh_display. "데이터 갱신 후 초기화면으로
    ENDIF.

    "if문에서 거짓이면 update를 아예 안타게
  ELSE.
    MESSAGE i016(pn) WITH '담당자 변경에 실패하였습니다.' DISPLAY LIKE 'E'.
    LEAVE TO SCREEN sy-dynnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REFRESH_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM refresh_display .

  PERFORM get_emp_list USING zta01m01-carrid CHANGING gt_emp.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ROW_EMP_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM row_emp_info .

  "선택된 레코드 담당자 불러오기
  DATA : lt_row TYPE lvc_t_row,
         ls_row LIKE LINE OF lt_row,
         lv_cnt TYPE sy-tabix.


  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_row
*     et_row_no     =
    .

  DESCRIBE TABLE lt_row LINES lv_cnt.

  CASE lv_cnt.
    WHEN '0'. "False
      sy-subrc = 4.
      MESSAGE i016(zcal_a_01) DISPLAY LIKE 'E'.
      LEAVE TO SCREEN sy-dynnr.
    WHEN '1'.
      READ TABLE lt_row INDEX 1 INTO ls_row.
      CLEAR gs_emp.
      READ TABLE gt_emp INDEX ls_row-index INTO gs_emp.

      SELECT SINGLE carrid armdm
        FROM zta01m01
        INTO CORRESPONDING FIELDS OF zta01m02
        WHERE carrid = gs_emp-carrid AND armdm = gs_emp-armdm.
    WHEN OTHERS.
*      RETURN.
      MESSAGE i015(zcal_a_01) DISPLAY LIKE 'E'.
      LEAVE TO SCREEN sy-dynnr.
  ENDCASE.

*  PERFORM get_info. "담당자 정보
  PERFORM get_info USING gs_emp CHANGING zta01m03. "담당자 정보

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*PERFORM get_info USING gs_emp CHANGING zta01m03.
FORM get_info USING VALUE(ps_emp) LIKE gs_emp
              CHANGING cs_zta01m03 TYPE zta01m03.

  SELECT SINGLE carrid carrname currcode
  FROM scarr
  INTO CORRESPONDING FIELDS OF cs_zta01m03
*  WHERE carrid = gs_emp-carrid.
  WHERE carrid = ps_emp-carrid.



  SELECT SINGLE gesch entdt money waers orgeh lname fname dname
  FROM ztb0001 AS a
  INNER JOIN ztb0002_t AS b
  ON a~orgeh = b~depid
  INTO CORRESPONDING FIELDS OF cs_zta01m03
  WHERE a~pernr = ps_emp-armdm.

  CONCATENATE cs_zta01m03-lname cs_zta01m03-fname INTO cs_zta01m03-name.

  PERFORM get_value_range. "성별가져오기
*  PERFORM get_dept_name. "이름가져오기
*  팀명가져오기는 어디있지..?

*zta01m01-armdm이랑 같으면 zta01m03-name.이거 넣어줌
  IF zta01m01-armdm IS NOT INITIAL.
    PERFORM get_dept_name.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CARRID_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_carrid_list .

  SELECT a~carrid
         b~carrname
         a~armdm
         c~lname
         c~fname
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    FROM zta01m01 AS a
    INNER JOIN scarr   AS b ON a~carrid = b~carrid
    INNER JOIN ztb0001 AS c ON a~armdm  = c~pernr
    WHERE a~carrid = zta01m01-carrid.

  PERFORM get_concat_name. "이름 합치기


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CONCAT_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_concat_name .

  LOOP AT gt_emp INTO gs_emp.
    CONCATENATE gs_emp-lname gs_emp-fname INTO gs_emp-name.
    MODIFY gt_emp FROM gs_emp.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_VALUE_RANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_value_range .

  PERFORM get_domain_value.

  READ TABLE gt_value WITH KEY domvalue_l = zta01m03-gesch INTO gs_value.
  zta01m03-gesch_t = gs_value-ddtext.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DEPT_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_dept_name .

  "사번에 맞는 이름만 가져오기
  SELECT SINGLE lname fname
  FROM ztb0001
  INTO CORRESPONDING FIELDS OF zta01m03
*  WHERE pernr = gs_emp-armdm.
  WHERE pernr = zta01m01-armdm.

  CONCATENATE zta01m03-lname zta01m03-fname INTO zta01m03-name.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DOMAIN_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_domain_value .

  IF gt_value IS INITIAL.

    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = 'GESCH'
        text            = 'X'
*       FILL_DD07L_TAB  = ' '
      TABLES
        values_tab      = gt_value
*       VALUES_DD07L    =
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.
  ENDIF.

  IF sy-subrc <> 0.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_CLEAR_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_clear_name .

  "사번입력 안했을때, name값 지우기
  IF zta01m01-armdm IS INITIAL.
    CLEAR zta01m03-name.
  ENDIF.

*  ZTA01M01-ARMDM 이거 없으면 zta01m03-name.이거 지우기

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_INFO_200
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_info_200 USING VALUE(pt_emp) TYPE zta01m01
                  CHANGING cs_zta01m03 LIKE zta01m03.

  SELECT SINGLE carrid carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF cs_zta01m03
  WHERE carrid = pt_emp-carrid.

  SELECT SINGLE lname fname
  FROM ztb0001
  INTO CORRESPONDING FIELDS OF cs_zta01m03
  WHERE pernr = pt_emp-armdm.

  CONCATENATE cs_zta01m03-lname cs_zta01m03-fname INTO cs_zta01m03-name.


ENDFORM.
