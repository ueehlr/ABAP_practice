*&---------------------------------------------------------------------*
*& Report ZQUIZ_06_A10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_07_a01.

* GET_CUSTOMER 함수 호출해서 구현
* 고객 ID입력이 3개이므로 함수도 3번 호출해야 함



*입력받을 고객 ID 3개
PARAMETERS: pa_id1 TYPE s_customer,
            pa_id2 TYPE s_customer,
            pa_id3 TYPE s_customer.



*파라미터 호출1 -> 자바에서 메서드 호출할때  getMessage(매개변수); 이것처럼 호출하는거에요~
* 여기서 get_info가 getMessage함수이고, pa_id가 매개변수값인 parameter.
PERFORM get_info USING      pa_id1.
*                 CHANGING   gv_result.
*파라미터 호출2
PERFORM get_info USING      pa_id2.
*                 CHANGING   gv_result.
*파라미터 호출3
PERFORM get_info USING      pa_id3.
*                 CHANGING   gv_result.



*************************************************************************************

FORM get_info USING VALUE(f_id)  TYPE s_customer.
*                 CHANGING f_result   TYPE string.


  DATA : lv_custname TYPE S_CUSTNAME,
         lv_address  TYPE scustom-id,
         lv_discount TYPE scustom-id,
         gv_grade    TYPE c LENGTH 10.


***********
  CALL FUNCTION 'GET_CUSTOMER'
    EXPORTING
      i_id             = pa_id1
    IMPORTING
      e_name           = lv_custname
      e_address        = lv_address
      e_discount       = lv_discount
    EXCEPTIONS
      invalid_customer = 1.

CASE sy-subrc.
  WHEN 0. "유효
    IF lv_discount >= 20.
      gv_grade = 'Gold'.
    ELSEIF lv_discount >= 10.
      gv_grade = 'Silver'.
    ELSEIF lv_discount > 0.
      gv_grade = 'Bronze'.
    ELSE.
      CLEAR gv_grade.
    ENDIF.
    WRITE: f_id, lv_custname, lv_address, lv_discount+1(2),'%', gv_grade.
    SKIP.
    ULINE.
  WHEN 1. "유효하지 않은 고객
    WRITE : 'Invalid Customer' COLOR COL_NEGATIVE.
    SKIP.
    ULINE.
    EXIT.
ENDCASE.
**********

ENDFORM.


*PERFORM get_info USING pa_id1.
*PERFORM get_info USING pa_id2.
*PERFORM get_info USING pa_id3.
