*&---------------------------------------------------------------------*
*&  Include           MZA01101I01
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  "INPUT에는 화면에 보이기 전, 화면 어떻게 보여줄지 정의

  CASE sy-ucomm.
    WHEN 'EXIT'. " 'Exit' 'EXIT' 안됨(대소문자 구분)
      LEAVE PROGRAM.
    WHEN 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN. "두줄 = LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'. "검색버튼
      "오픈SQL
      PERFORM get_info. "아직 using이랑 changing을 쓰지 말고 만들어보기
*      "우리 지금 사용 테이블 scarr임
*      clear ZBCA01003.
*      SELECT SINGLE CARRID CARRNAME CURRCODE "단일키라서 1개만 가져올 수 있어서 single 써줌
*        FROM scarr "scarr => 데이타베이스테이블
*        INTO CORRESPONDING FIELDS OF ZBCA01003 "속도가 너무 중요한거 아니면 corress 붙이기 (걍 항상 붙이새요)
*        WHERE carrid = ZSA001002-CARRID. "ZBCA01002- => structure valiable?
*        IF sy-subrc is not INITIAL.
*          MESSAGE i007(ZCAL_A_01).
*        ENDIF.

  ENDCASE.

ENDMODULE.
