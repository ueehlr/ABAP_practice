*&---------------------------------------------------------------------*
*& Report ZRA01W1215
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zra01w1215_review1.

*1. 클래스 생성 
*2. 객체생성 , 참조변수생성 
*3. 필요한 필드(변수)생성 
*4. 메소드 생성
*생성자 생성
*그외 메소드 생성

CLASS lcl_emp DEFINITION.

  PUBLIC SECTION.
    METHODS : constructor IMPORTING iv_pernr TYPE ztb0001-pernr
                                    iv_ename TYPE zeb00_ename
                                    iv_eflag TYPE char1, "정규직1 / partTime2
      get_emp_info EXPORTING ev_info TYPE string.
    DATA : gv_info TYPE string.

  PRIVATE SECTION.
    DATA : pernr TYPE ztb0001-pernr, "사원번호
           ename TYPE zeb00_ename, "사원명
           pernr TYPE char1. "type c "정규직1, part time2

    CLASS-DATA : tot_pernr TYPE i. "총사원수

    METHODS set_emp IMPORTING iv_ename TYPE zeb00_ename
                              iv_eflag TYPE string.

ENDCLASS.
CLASS lcl_emp IMPLEMENTATION. "<구현부>

  METHOD constructor.
    "사원번호 설정
    DATA lv_num4(4) TYPE n.
    lc_emp=>tot_cnt = lcl_emp=>lcl_cnt + 1.
    lv_num4 = lcl_emp=>lcl_cnt. "결과 잠깐 저장하는 변수에 담아줌
    CONCATENATE sy-datum+0(4) lv_num4 INTO me->pernr. "현재년도+사원수
    "전달받은 값 설정
*    me->ename = iv_ename. -> 이거 대신에 밑에 me->set으로 구현
*    me->eflag = iv_eflag.

    me->set_emp(
      EXPORTING iv_ename = iv_ename
                iv_eflag = iv_eflag
    ).
  ENDMETHOD.

  METHOD set_emp.
    CLEAR : me->ename, me->eflag.
    me->ename = iv_ename.
    me->eflag = iv_eflag.
  ENDMETHOD.

  METHOD get_emp_info.
    ev_info = me->pernr && me->ename && me->eflag && lcl_emp=>tot_cnt. "CONCATENATE랑 같은건데 이게 최신문법 -> &&
  ENDMETHOD.

ENDCLASS.

"객체 및 참조변수 생성
DATA : go_emp TYPE REF TO lcl_emp,
*       gt_emp TYPE TABLE OF REF TO lcl_emp. "밑에랑 같음. 근데 난 이게 편한댕
       gt_emp LIKE TABLE OF go_emp.

START-OF-SELECTION. "<호출부>
  CREATE OBJECT go_emp
    EXPORTING
      iv_ename = '강길동'
      iv_eflag = '1'.
*      iv_pernr =  '1'  "'2025000 + lcl_emp=>tot_pernr

  APPEND go_emp TO gt_emp.
  CLEAR go_emp. "원래만든 객체는 인터널테이블인 gt_emp에서 참조중이라 인터널테이블에서 여전히 존재함

  CREATE OBJECT go_emp
    EXPORTING
      iv_ename = '신길동'
      iv_eflag = '2'.
  APPEND go_emp TO gt_emp.
  CLEAR go_emp.

*  LOOP AT gt_emp TO go_emp.
*    CLEAR go_emp.
*    CALL METHOD ->get_emp_info "...? 여기 다시 보기 모륷
*    IMPORTING
*      ev_info
*
*  ENDLOOP.

  LOOP AT gt_emp TO go_emp.
    CLEAR gv_info.
    CALL METHOD go_emp->get_emp_info
      IMPORTING
        ev_info = gv_info.
    WRITE gv_info.
    NEW-LINE.
    CLEAR go_emp.
  ENDLOOP.
