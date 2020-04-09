Class UnitTest.Isc.JSONFiltering.Services.FilteringServices Extends %UnitTest.TestCase
{

Method TestFilter() As %Status
{
    Set tSc = $$$OK
    Set json = { 
        "p1":"azer", 
        "p2":"uiop", 
        "sub" : { 
            "subp1" : "azer" 
        }, 
        "arr" : [ {
            "arrp1":"arrp1value",
            "arrp2":"arrp2value",
            "tab" : [1,2,3,4,5]
        }] 
    }

    Set filter = "p1,p2"
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer", "p2":"uiop" }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Set filter = "p1,sub[subp1]"
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" } }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Set filter = "p1,sub[subp1],arr[arrp1,tab]"
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" },"arr" : [ {"arrp1":"arrp1value","tab" : [1,2,3,4,5]}]  }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Return tSc
}

Method TestSearchCriteria() As %Status
{
    Set tSc = $$$OK
    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set searchCriteria = [["city","Namur","="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria")
    Return tSc
}

Method TestCombinationCriteriaFilter() As %Status
{
    Set tSc = $$$OK
    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set searchCriteria = [["city","Namur","="]]
    Set filter = "name"
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(json,filter,searchCriteria)
    Set expectedResult = [{"name":"Lorenzo"},{"name":"Matteo"},{"name":"Alessio"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Combination Search criteria and property filter")
    Return tSc
}

}
