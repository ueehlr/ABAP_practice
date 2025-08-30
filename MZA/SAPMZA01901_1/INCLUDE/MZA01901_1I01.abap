*&---------------------------------------------------------------------*
*&  Include           MZA01901I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
*      PERFORM set_clear_name.
      PERFORM get_carrid_list. "해당되는 항공사만 조회.
**      CLEAR gs_emp-armdm.
      CLEAR : ZTA01M01-ARMDM, ZTA01M03-NAME.
    WHEN 'SEARCH'.
      PERFORM get_carrid_list. "해당되는 항공사만 조회.
    WHEN 'EMPADD'. "<신규 담당자 등록_200>
      CALL SCREEN 200.
      CLEAR : ZTA01M01-ARMDM, ZTA01M03-CARRNAME, ZTA01M03-NAME.
    WHEN 'CHANGEEMP'. "<담당자 변경_300>
      PERFORM row_emp_info. "선택된 레코드 담당자 정보
      CALL SCREEN 300.
      CLEAR : zta01m01-armdm.
    WHEN 'SEARCHEMP'. "<담당자 상세조회_400>
      PERFORM row_emp_info. "선택된 레코드 담당자 정보
      CALL SCREEN 400.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  CASE sy-ucomm.
    WHEN 'CANC'.
      LEAVE SCREEN.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      CLEAR : ZTA01M01-ARMDM, ZTA01M03-CARRNAME, ZTA01M03-NAME.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
*     PERFORM get_info. "사원명/항공사명 가져오기
      PERFORM get_info_200 USING zta01m01 CHANGING zta01m03. "사원명/항공사명 가져오기
    WHEN 'ADDNEWEMP'. "<신규담당자 등록>
      PERFORM insert_new_emp.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.

    WHEN 'SEARCH'.

    WHEN 'CHANGENEW'.
      PERFORM change_new_emp. "선택된 레코드 담당자 불러오기
*      PERFORM get_info. "직원명 가져오기
      PERFORM get_info USING gs_emp CHANGING zta01m03. "직원명 가져오기
      PERFORM update_new_emp. "담당자 변경

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.

    WHEN 'SEARCH'.

  ENDCASE.


ENDMODULE.
