Include jsonfilter

Class Isc.JSONFiltering.Services.FilteringServices
{

/// json must be a DynamicObject or DynamicArray used for property filter<br/>
/// filterString is property filter using this syntax "property1,property2,property3"<br/>
/// ex : "name,friends"<br/>
/// You can filter nested object property with this syntax "property1[nestedproperty1],property2"<br/>
/// ex : "name[first],friends[name,address[city]]"<br/>
/// <code>
/// Set json = {"name" : { "first" : "Edith", "last" : "Scott"}, "friends" : [{"name": "Perkins Cruz", "id":"1", "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]}]}
/// Set filter = "name[first],friends[name,address[city]]"
/// Set filteredJSON = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
/// Write filteredJSON.%ToJSON()
/// </code><br/>
ClassMethod filterJSON(json As %DynamicAbstractObject, filterString As %String = {$$$JSFilterDefaultFlds}) As %DynamicAbstractObject
{
    Return:filterString="" json ; No filter string, original object is returned
    Return ##class(Isc.JSONFiltering.DynObjFiltering).cmFilter(json, filterString)
}

/// json must be a DynamicArray<br/>
/// searchCriteria for searching into json array <br/>
/// It's the restriction predicate syntax. <br/>
/// example [["name","Edith","="],["company","ACCEL","="]] </br>
/// operator list : =, !=, <, >, <=, >=, <>, %STARTSWITH, NULL, IN, and NOT NULL<br/>
/// <code>
/// Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
/// Set searchCriteria = [["city","Namur","="]]
/// Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
/// Write !,result.%ToJSON()
/// </code><br/>
ClassMethod searchCriteria(json As %DynamicObject, searchCriteria As %String = {$$$JSFilterDefaultCriteria}) As %DynamicAbstractObject
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
        ; It was a bad approach.  A fail to story that I wish to share with you :p
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
