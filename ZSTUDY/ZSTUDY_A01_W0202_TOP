*&---------------------------------------------------------------------*
*&  Include           ZSTUDY_A01_W0202_TOP
*&---------------------------------------------------------------------*

*라인타입정의
TYPES : BEGIN OF ts_info,
          carrid   TYPE  sflight-carrid, "항공사코드 ->AA
          carrname TYPE scarr-carrname,
          connid   TYPE  sflight-connid, "항공편id
          fldate   TYPE  sflight-fldate,
          price    TYPE sflight-price,
          currency TYPE sflight-currency,
        END OF ts_info.

DATA : gs_info TYPE TABLE OF ts_info. "워크에리아 : gs_info
DATA : gt_into TYPE ts_info. "인터널테이블 : gt_info

PARAMETERS pa_date TYPE sflight-fldate.
