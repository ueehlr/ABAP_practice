@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[A01] DDL Source 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDDLA0101 as select from spfli
{
    key carrid,
    key connid,
    countryfr,
    countryto,
    case countryfr 
    when countryto
    then 'D'
    else 'I'
    end as ftype
}
