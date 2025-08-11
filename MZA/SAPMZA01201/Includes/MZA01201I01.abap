*&---------------------------------------------------------------------*
*&  Include           MZA01201I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

*  CASE sy-ucomm.
*  MESSAGE i007(zcal_a_01) with ok_code.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      "GET Connetion Info
      SELECT SINGLE a~carrid
              a~connid
              a~airpfrom
              a~airpto
              b~carrname
      INTO CORRESPONDING FIELDS OF zsa011102
      FROM spfli AS a
      INNER JOIN scarr AS b ON a~carrid = b~carrid
      WHERE a~carrid = zsa011101-carrid
        AND a~connid = zsa011101-connid.

      PERFORM get_airport_name. "공항 이름 정보
      PERFORM output_message. "정보없음 메시지

    WHEN 'ENTER'.
      "Get Airline name
      SELECT SINGLE carrname
        FROM scarr
        INTO zsa011101-carrname
        WHERE carrid = zsa011101-carrid.
    WHEN OTHERS. "search없으면 다 여기로 빠지니까 실행된거임 -> 근데 when에서 search를 만들면 거기로 가니까
*        PERFORM output_message. "정보없음 메시지
  ENDCASE.

ENDMODULE.
