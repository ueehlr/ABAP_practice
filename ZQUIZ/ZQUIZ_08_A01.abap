*&---------------------------------------------------------------------*
*& Report ZQUIZ_08_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_08_a01.

*문제: 화면에서 고객 ID를 입력받아 고객의 상세 정보를 2개 테이블에서 조회하여 출력하는 프로그램

" 1. SCUSTOM과 T005T 테이블을 참조하여 Local Structure Type을 정의하시오.
"   - TS_CUSTOM
"     > 구성요소: 고객ID, 고객 이름, 고객 국가ID, 국가 텍스트, 고객지역, 할인율
"     > 국가 텍스트 컴포넌트는 T005T의 NARIO50 필드 참고
"
" 2. 1에서 정의한 스트럭쳐 타입을 이용하여 스트럭쳐 변수를 정의하시오.
"
" 3. 2번에서 정의한 스트럭쳐 변수에 값을 SCUSTOM과 T005T 테이블을 각각 SELECT하여 해당 스트럭쳐의 모든 Component 값을 모두 채우시오.
"    HINT. Select 2번 진행
"
" 4. 2번에서 정의한 스트럭쳐 변수의 모든 요소를 WRITE 하시오.
"
" 주의점. 해당 고객의 국가(국적) 텍스트는 사용자가 로그인한 언어의 텍스트로 출력하시오.
"    e.g. US 고객인 경우
"         한국어 로그인 -> 미국인
"         영어 로그인  -> American

*테이블 SCUSTOM
*ID: 고객 ID
*NAME: 고객이름
*COUNTRY: 고객 국가 ID
*CITY: 고객 지역
*DISCOUNT: 할인율
*테이블 T005T
*NATI050: 국가 텍스트



***************************************************************************
"structur type을 저장하는 변수생성 -> 이건 편의상 만드는건가용..?
* 참조변수 만들어서 접근하는 것 처럼 따지자면 편의상 맞죠..~
DATA : gs_scustom TYPE scustom,
       gs_t005t   TYPE t005t.


*고객 상세정보 저장할 데이터 -> 구조를 타입으로
TYPES : BEGIN OF ts_scustomt005t,
          id       TYPE scustom-id,
          name     TYPE scustom-name,
          country  TYPE scustom-country,
          city     TYPE scustom-city,
          discount TYPE scustom-discount,
          natio50  TYPE t005t-natio50,
        END OF ts_scustomt005t.


*고객 id 입력받기
PARAMETERS : ps_id TYPE scustom-id. "테이블 안에 있는 유효한 id의 값만 받기 위해 타입을 scustom-id (scustom 스트럭처의 id값으로 지정해줌)

*gs_scustom에다가 scustom에 해당하는 값 select

DATA: gs_scustom_t005t TYPE ts_scustomt005t. "결과 저장용 구조

* select문 gs_scustom_t005t안에 해당 정보들 저장
SELECT SINGLE id name country city discount
  INTO (gs_scustom_t005t-id,
        gs_scustom_t005t-name,
        gs_scustom_t005t-country,
        gs_scustom_t005t-city,
        gs_scustom_t005t-discount)
  FROM scustom
  WHERE id = ps_id.

SELECT SINGLE natio50
  INTO gs_scustom_t005t-natio50
  FROM t005t
  WHERE land1 = gs_scustom_t005t-country "Country key=NATIO50
    AND spras = sy-langu. "Language Key = 현재 로그온언어

IF sy-subrc <> 0.
  WRITE : | Invalid customer information. |.
  EXIT.
ENDIF.

*할인율 i형변환
gs_scustom_t005t-discount =  | { CONV i( gs_scustom_t005t-discount ) } , % | .


WRITE : | 고객ID : { gs_scustom_t005t-id }| ,
/ | 이름 : { gs_scustom_t005t-name } | ,
/  | 언어 : { gs_scustom_t005t-country } |,
/ | 국가 : { gs_scustom_t005t-city } | ,
/ | 할인율 : {  gs_scustom_t005t-discount } | ,
/ | { gs_scustom_t005t-natio50 } |.
