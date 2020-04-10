Include jsonfilter

Class Isc.JSONFiltering.Services.FilteringServices
{

ClassMethod filterJSON(json As %DynamicObject, filterString As %String = {$$$JSFilterDefaultFlds}) As %DynamicObject
{
    Return:filterString="" json ; No filter string, original object is returned
    Return ##class(Isc.JSONFiltering.DynObjFiltering).cmFilter(json, filterString)
}

ClassMethod searchCriteria(json As %DynamicObject, searchCriteria As %String = {$$$JSFilterDefaultCriteria}) As %DynamicObject
{
    Return:searchCriteria="" json ; No searchCriteria, original object is returned.
    Return:'json.%IsA("%DynamicArray") json ; NA for non DynamicArray.

    If '$IsObject(searchCriteria) { 
        Set searchCriteria = [].%FromJSON(searchCriteria)
    }

    If $$$JSCriteriaOldVersion { 
        ; For comparison purpose.  
        ; Add $$$JSCriteriaSetOldVerFlag(1) in your process to force the old version usage.
        ; Old version use a new %DocDB for each request.  
        ; It was a bad approach.  A fail to story that I wish to share with you :p .
        ; We shouldn't use a new temp %DocDB for each request.
        ; ^%SYS.MONLBL show an high fixed cost for %CreatePoperty and %CreateDatabase.
        ; Report ^%SYS.MONLBL is available in others/monlbl.csv 
        Set result = ##class(Isc.JSONFiltering.DynObjSearchCriteria).cmSearchCriteria(json,searchCriteria)
    } Else {
        ; Added in version 1.3.0
        ; Significant Increase performance (up to 150 times more faster).
        Set result = ##class(Isc.JSONFiltering.DynObjSearchCriteriaPerf).cmSearchCriteria(json,searchCriteria)
    }
    
    Return result
}

ClassMethod searchCriteriaAndFilter(json As %DynamicObject, filterString As %String = {$$$JSFilterDefaultFlds}, searchCriteria As %String = {$$$JSFilterDefaultCriteria}) As %DynamicObject
{
    Return ..filterJSON(..searchCriteria(json,searchCriteria),filterString)
}

}
