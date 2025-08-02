*&---------------------------------------------------------------------*
*& Report ZSTUDY_A01_W0201
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstudy_a01_w0201.

*SPFLI
*CARRID -> S_CARR_ID
*(Connection Number) -> CONNID -> S_CONN_ID

"밑에서 만들어준 select문이 들어갈 structure만들어줌
DATA : BEGIN OF airstruc ,
  CARRID type SPFLI-CARRID,
  CONNID type SPFLI-CONNID,
  AIRPFROM type SPFLI-AIRPFROM,
  AIRPTO type SPFLI-AIRPTO,
  END OF airstruc.

*파라미터 선언
PARAMETERS : pa_id   TYPE s_carr_id,
             pa_conn TYPE s_conn_id.

IF pa_id is INITIAL OR  pa_CONN is INITIAL. " is INITIAL -> 공백일때  ''이거 ㅅ거아님
  MESSAGE s002(zcal_a_01).
  RETURN. "exit을 써도 되긴 합니당~.
ENDIF.

* 정보 가져오기
SELECT SINGLE CARRID CONNID AIRPFROM AIRPTO "한 행만가져와라
  INTO ( airstruc-CARRID , airstruc-CONNID , airstruc-airpfrom , airstruc-AIRPTO ) "여기는 airstruc 에 넣을꺼라는말
  FROM SPFLI
  WHERE CARRID = PA_ID and connid = pa_conn.
*
*"예외처리
IF sy-subrc <> 0.
   MESSAGE s004(zcal_a_01) with pa_id pa_conn. "& & 에 해당파라미터를 이용한다는 말
   RETURN.
ENDIF.

IF airstruc IS NOT INITIAL. "스트럭쳐에 값이 잘 들어가있으면 듸우겠다

  cl_demo_output=>display_data( airstruc ).

ENDIF.
