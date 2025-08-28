@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[A01] Inner Join'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDDLA0102 
as select from ZDDLA0101 as a
inner join scarr as b
on a.carrid = b.carrid 
{
    key a.carrid,
    key a.connid, //이거는 겹치는거 아니라 a. 안써줘도 되지만, 명시적으로 작성해주는게 좋음
    a.ftype, //아까 만들었던 view인 -> ZDDLA0101 이거를 from절에 사용해줬기때문에 이것도 사용 가능
    b.carrname
}










