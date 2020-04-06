Class Isc.JSONFiltering.Services.FilteringServices
{

ClassMethod filterJSON(json As %DynamicObject, filterString As %String = { $Select($Isobject(%request):$Get(%request.Data("flds",1)),1:"")}) As %DynamicObject
{
    Return:filterString="" json ; No filter string, original object is returned
    Return ##class(Isc.JSONFiltering.DynObjFiltering).cmFilter(json, filterString)
}

ClassMethod searchCriteria(json As %DynamicObject, searchCriteria As %String = { $Select($Isobject(%request):$Get(%request.Data("searchCriteria",1)),1:"")}) As %DynamicObject
{
    Return:searchCriteria="" json
    Set searchCriteria = [].%FromJSON(searchCriteria)
    Return ##class(Isc.JSONFiltering.DynObjSearchCriteria).cmSearchCriteria(json,searchCriteria)
}

ClassMethod searchCriteriaAndFilter(json As %DynamicObject, filterString As %String = { $Select($Isobject(%request):$Get(%request.Data("flds",1)),1:"")}, searchCriteria As %String = { $Select($Isobject(%request):$Get(%request.Data("searchCriteria",1)),1:"")}) As %DynamicObject
{
    ;Set output = ..searchCriteria(json,searchCriteria)
    ;Set output = ..filterJSON(output,filterString)
    ;Return output
    Return ..filterJSON(..searchCriteria(json,searchCriteria),filterString)
}

}
