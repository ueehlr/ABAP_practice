*&---------------------------------------------------------------------*
*& Report ZQUIZ_02_A01_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquiz_02_a01_01.

PARAMETERS: fname TYPE c LENGTH 32 OBLIGATORY, "이름
            lname TYPE c LENGTH 16 OBLIGATORY, "성
            bday  TYPE d OBLIGATORY, "생일(YYYYMMDD)
            mode  TYPE c OBLIGATORY. "모드

DATA: today TYPE d, "오늘 날짜(YYYYMMDD)
      ydiff TYPE i, "년도 차이
      mdiff TYPE i, "달+날짜 차이
      age1  TYPE i, "만나이
      age2  TYPE i, "년나이
      name  TYPE string. "fullname (성+이름)

today = sy-datum. "시스템 현재 날짜(YYYYMMDD)

" 한국나이 계산
ydiff = today+0(4) - bday+0(4). "오늘 년도(YYYY) - 생일 년도(YYYY)
mdiff = today+4(4) - bday+4(4). "오늘 날짜(MMDD) - 생일 날짜(MMDD)
age1 = ydiff + 1.  "만나이 계산


IF mdiff < 0.   "생일이 지나지 않았다면, 1살 뺌
  age2 = ydiff - 1.
ELSE.
  age2 = ydiff.
ENDIF.


CONCATENATE fname lname INTO name SEPARATED BY ','. "성과 이름 합침

IF today < bday. "생일이 현재 날짜보다 뒤라면 오류 메시지 출력
  MESSAGE 'You could not enter a birth date in the future' TYPE 'E'.
ENDIF.

IF mode = '1'. "만나이일 때 출력
  WRITE: |Hi! { name } Korean legal age is { age2 }|.
ELSEIF mode = '2'. "한국나이일 때 출력
  WRITE: |Hi! { name } Korean age is { age1 }|.
ELSE. "mode가 1 또는 2가 아닐 때 처리
  MESSAGE 'The mode must be either 1 or 2' TYPE 'W'.
ENDIF.
