Class Iris.JSON.FilteringServices
{

ClassMethod filterJSON(json As %DynamicObject, filterString As %String = { $Select($Isobject(%request):$Get(%request.Data("flds",1)),1:"")}) As %DynamicObject
{
    Return:filterString="" json
    Return ##class(Isc.JSONFiltering.DynObjFiltering).cmFilter(json, filterString)
}

}
