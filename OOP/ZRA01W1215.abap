*&---------------------------------------------------------------------*
*& Report ZRA01W1215
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1215.

*1. 클래스 생성 
*2. 객체생성 , 참조변수생성 
*3. 필요한 필드(변수)생성 
*4. 메소드 생성
*생성자 생성
*그외 메소드 생성

"사용자 입력
PARAMETERS : pa_date TYPE i.

CLASS lcl_emp DEFINITION.

  PUBLIC SECTION.
    METHODS : constructor IMPORTING iv_ename TYPE zeb00_ename
                                    iv_level TYPE char1,
      get_emp_info EXPORTING ev_print TYPE string.
    CLASS-DATA : tot_pernr TYPE n LENGTH 4. "총사원수(Static Attribute)

  PRIVATE SECTION.
    DATA : pernr   TYPE ztb0001-pernr, "사원번호
           ename   TYPE zeb00_ename, "사원명
           level   TYPE char1,
           time    TYPE i, "총근무시간
           gv_text TYPE string.
    METHODS : set_emp IMPORTING iv_ename TYPE zeb00_ename
                                iv_level TYPE char1,
      check_level IMPORTING iv_level TYPE char1,
      get_work_time IMPORTING pa_date TYPE i.

ENDCLASS.
CLASS lcl_emp IMPLEMENTATION. "<구현부>

  METHOD constructor.
    "사원번호 생성
    DATA lv_tot TYPE i.
    me->tot_pernr = me->tot_pernr + 1.
    lv_tot = CONV i( sy-datum+0(4) ) && me->tot_pernr.
    me->pernr = lv_tot.

    "setter메서드 호출
    me->set_emp(
      EXPORTING iv_ename = iv_ename
                iv_level = iv_level ).

    "사원레벨분기 메서드 호출
    me->check_level(
      EXPORTING iv_level = iv_level ).

    "근무시간계산 메서드 호출
    me->get_work_time(
      EXPORTING pa_date = pa_date ).

  ENDMETHOD.

  METHOD set_emp. "setter메소드
    me->ename = iv_ename.
    me->level = iv_level.
  ENDMETHOD.

  METHOD check_level. "사원레벨 분기
    CLEAR gv_text.
    IF me->level = '1'.
      gv_text = '정규'.
    ELSEIF me->level = '2'.
      gv_text = 'Part Time'.
    ENDIF.
  ENDMETHOD.

  METHOD get_emp_info. "출력메소드
    WRITE : |사원번호: { me->pernr } / 사원명: { me->ename }|,
            |/ 사원구분: { me->level }({ me->gv_text })|,
            |/ 총근무시간: { me->time }|.
  ENDMETHOD.

  METHOD get_work_time.
    CLEAR me->time.
    IF me->level = '1'. "정규
      me->time = pa_date * 8.
    ELSEIF me->level = '2'. "partTime
      me->time = pa_date * 6.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA : go_emp TYPE REF TO lcl_emp,
*       gt_emp TYPE TABLE OF REF TO lcl_emp.
       gt_emp LIKE TABLE OF go_emp.

START-OF-SELECTION.

  CREATE OBJECT go_emp "객체생성
    EXPORTING
      iv_ename = '김찰스'
      iv_level = '1'.
  APPEND go_emp TO gt_emp.
  CLEAR go_emp.

  CREATE OBJECT go_emp
    EXPORTING
      iv_ename = '박세라'
      iv_level = '2'.
  APPEND go_emp TO gt_emp.
  CLEAR go_emp.

  "출력
  LOOP AT gt_emp INTO go_emp.
    go_emp->get_emp_info( ).
    NEW-LINE.
  ENDLOOP.
