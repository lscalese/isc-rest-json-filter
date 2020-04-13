Include jsonfilter

Class Isc.JSONFiltering.Services.FilteringServices
{

ClassMethod applyAllFilterParameters(json As %DynamicAbstractObject, filterString As %String = {$$$JSFilterGetFlds}, searchCriteria As %String = {$$$JSFilterGetSearchCriteria}, sortOptions As %String = {$$$JSFilterGetSort}, limitResult As %Integer = {$$$JSFilterGetLimit}) As %DynamicAbstractObject
{
    ; First step select only matching result with search criteria
    Set result = ..searchCriteria(json,searchCriteria)

    ; Apply sort
    Set result = ..sort(result, sortOptions)
    
    ; Apply property filter
    Set result = ..filterJSON(result,filterString)
    
    ; Apply limit result
    Set result = ..limitResult(result,limitResult)
    Return result
}

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
ClassMethod filterJSON(json As %DynamicAbstractObject, filter As %DynamicArray = {$$$JSFilterGetFlds}) As %DynamicAbstractObject
{
    Return:filter="" json ; No filter, original object is returned

    Return ##class(Isc.JSONFiltering.DynObjFiltering).cmFilter(json, filter)
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
ClassMethod searchCriteria(json As %DynamicObject, searchCriteria As %String = {$$$JSFilterGetSearchCriteria}) As %DynamicAbstractObject
{
    Return:searchCriteria="" json ; No searchCriteria, original object is returned.
    Return:'json.%IsA("%DynamicArray") json ; NA for non DynamicArray.

    ; Old version use a new %DocDB for each request.  
    ; It were a bad approach.
    ; We shouldn't use a new temp %DocDB for each request.
    ; ^%SYS.MONLBL show an high fixed cost for %CreatePoperty and %CreateDatabase.
    ; Report ^%SYS.MONLBL is available in others/monlbl.csv 
    ; Set result = ##class(Isc.JSONFiltering.DynObjSearchCriteria).cmSearchCriteria(json,searchCriteria)
    
    ; Added in version 1.3.0
    ; Significant Increase performance (up to 150 times more faster).
    Set result = ##class(Isc.JSONFiltering.DynObjSearchCriteriaPerf).cmSearchCriteria(json,searchCriteria)
    
    Return result
}

ClassMethod sort(json As %DynamicArray, sortOptions As %DynamicArray = {$$$JSFilterGetSort}) As %DynamicArray
{
    Return:sortOptions="" json

    Return ##class(Isc.JSONFiltering.DynObjSorter).cmSort(json,sortOptions)
}

ClassMethod limitResult(json As %DynamicArray, limit As %Integer = {$$$JSFilterGetLimit}) As %DynamicArray
{
    Return:+limit'>0 json

    Set result = []
    Set cnt = 0
    Set iter = json.%GetIterator()
    While iter.%GetNext(.key , .item ) {
        Do result.%Push(item)
        Set cnt = cnt + 1
        Quit:cnt=limit
    }
    
    Return result
}

}
