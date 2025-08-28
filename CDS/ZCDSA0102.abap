@AbapCatalog.sqlViewName: 'ZCDSA0102_S'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[A01] CDS - OLD2'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDSA0102 
with parameters p_car : abap.char(3) //s_carr_id
as select from sflight
{
    key carrid,
    key connid,
    key fldate,
//    @semantics.amount.currencyCode: 'CURRENCY'
     price @<Semantics.amount.currencyCode: 'CURRENCY',
//    price,
    currency
} where carrid = $parameters.p_car
