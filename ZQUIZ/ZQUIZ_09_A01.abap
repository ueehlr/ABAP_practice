*&---------------------------------------------------------------------*
*& Report ZQUIZ_09_A01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_09_a01.


*1. 항공사코드, 고객아이디, 고객이름 으로 구성된 라인타입을 정의하 시오.
*2. 1번에 정의한 라인 타입을 이용해서 테이블 타입을 정의하시오.
*이름: TT_CARRIER_CUSTOM
*단) 데이터가 저장시 항공사 코드, 고객 ID로 자동 정렬되게
*설계하시오.
*항공사코드, 고객 ID가 중복되는 데이터는 삽입될 수 없도록 설계하시오.
*3. 2번에서 정의한 타입을 이용해서 인터널 테이블을 정의하시오.
*이름: GT_CAR_CUST

*scustom
*t005t

*TYPES : BEGIN OF ts_info,
*          carrid TYPE  bc400_s_flight-carrid,
*          id     TYPE scustom-id,
*          name   TYPE scustom-name,
*        END OF ts_info.
*
*TYPES : TT_CARRIER_CUSTOM TYPE STANDARD TABLE OF ts_info WITH UNIQUE KEY carrid id.
*
*
*TYPES: TT_CARRIER_CUSTOM TYPE SORTED TABLE OF ts_info
*                 WITH UNIQUE KEY carrid id.

TYPES: BEGIN OF ts_info,
         carrid TYPE bc400_s_flight-carrid,
         id     TYPE scustom-id,
         name   TYPE scustom-name,
       END OF ts_info.

TYPES: tt_carrier_custom TYPE SORTED TABLE OF ts_info
                          WITH UNIQUE KEY carrid id.

DATA gt_car_cust TYPE tt_carrier_custom.
