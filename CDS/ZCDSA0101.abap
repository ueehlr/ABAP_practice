@AbapCatalog.sqlViewName: 'ZCDSA0101_S'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[A01] CDS - Old 1'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDSA0101 as select from scarr
{   
    key carrid, carrname
}
