*&---------------------------------------------------------------------*
*& Report  ZRMKBDCVD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

INCLUDE zrmkbdcvd_top                           .    " global Data

INCLUDE zrmkbdcvd_o01                           .  " PBO-Modules
INCLUDE zrmkbdcvd_i01                           .  " PAI-Modules
INCLUDE zrmkbdcvd_f01                           .  " FORM-Routines

*PERFORM get_data. "하드코딩 버전 -> 사용x -> 얘 대신에 get_excel_data 서브루틴 만들어준것

INITIALIZATION. "selection-screen 필드에 기본값 세팅 -> 한 번만 실행 -> 모듈풀에서 load-of-program과 같음
  sscrfields-functxt_01 = 'function1'. "버튼이름-> [엑셀업로드] 용도로 사용할 예정
  sscrfields-functxt_01 = 'function2'. "[검증실행]


* Selection-Screen = F8 눌렀을 때 나오는 입력창
AT SELECTION-SCREEN OUTPUT. "모듈풀로 따지면 PBO같은느낌 (Selection-Screen전용 PBO
  "-> 근데 사용자 행동제어(OK_CODE)는 제어 못함
  "-> 화면  필드 속성만 동적으로 제어 가능
  "ex) 필드에대해-> 숨기기/보이기, 입력 가능/불가능, 필드텍스트 변경

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_file.
  "AT SELECTION-SCREEN ON VALUE-REQUEST FOR <파라미터명> => F4도움말 눌렀을때 실행됨
  PERFORM f4_data_file.

AT SELECTION-SCREEN. "->이벤트 처리 하는 곳 (pai의 case문으로 이벤트 처리 하는 것 처럼)
  CASE sscrfields-ucomm.
    WHEN 'FC01'. "Function Key1
      MESSAGE i000(ymc00) WITH 'function1: 엑셀 업로드 버튼'.
    WHEN 'FC02'. "Function Key2
      MESSAGE i000(ymc00) WITH 'function2: 검증 실행 버튼 클릭'.
  ENDCASE.


START-OF-SELECTION.
  PERFORM get_excel_data. "1단계: 엑셀 읽기
  cl_demo_output=>display_data( gt_data ). "엑셀 업로드 → 내부테이블(gt_data)에 데이터 잘 들어옴 확인

  PERFORM check_data.       "2단계: 유효성 검사
  PERFORM insert_data.      "3단계: DB 인서트
  PERFORM display_data.     "4단계: ALV 출력
