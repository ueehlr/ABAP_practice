*&---------------------------------------------------------------------*
*& Report ZQUIZ_012_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZQUIZ_012_A01.

* SCUSTOM
* 화면에서 국가 코드를 입력받아서 해당 국가의 모든 고객을 출력한느 프로그램을 구현하시오

DATA pa_contry TYPE SCUSTOM. "구조체생성


PARAMETERS pa_con TYPE SCUSTOM-COUNTRY. "국가코드 입력받기


SELECT *
  FROM SCUSTOM
  INTO CORRESPONDING FIELDS OF pa_contry
  WHERE COUNTRY = pa_con.
ENDSELECT.
*
**출력과 예외처리
*IF sy-dbcnt <> 0.
*  WRITE : pa_contry-id , pa_contry-name , pa_contry-telephone , pa_contry-email.
*ELSEIF pa_contry-email is INITIAL.
*  WRITE : 'Unknouwn' COLOR COL_NEGATIVE.
*ELSEIF pa_contry-telephone is INITIAL.
*   WRITE : 'Unknouwn' COLOR COL_NEGATIVE.
*ENDIF.

IF sy-dbcnt = 0.
  WRITE: '해당 국가에 고객이 없습니다.' COLOR COL_NEGATIVE.
ELSE.
  LOOP AT pa_contry INTO ty_contry.
    IF pa_contry-email IS INITIAL OR pa_contry-telephone IS INITIAL.
      WRITE: / 'Unknown' COLOR COL_NEGATIVE.
    ELSE.
      WRITE: / pa_contry-id, pa_contry-name, pa_contry-telephone, pa_contry-email.
    ENDIF.
  ENDLOOP.
ENDIF.

**출력
*WRITE : pa_contry-id , pa_contry-name , pa_contry-telephone , pa_contry-email.

"맨 위에 한 줄만 뜨는 경향이 있어서 다 나오게끔 해야함 !!!!!!
