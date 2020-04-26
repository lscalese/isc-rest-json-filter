Class UnitTest.Isc.JSONFiltering.Services.FilteringServices Extends %UnitTest.TestCase
{

Method TestFilterProperty() As %Status
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

    Set filter = ["p1","p2"]
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer", "p2":"uiop" }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter.%ToJSON())

    Set filter = ["p1","sub","sub.subp1"]
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" } }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter.%ToJSON())

    Set minFilter = "p1,sub[subp1],arr[arrp1,tab]"
    Set filter = ##class(Isc.JSONFiltering.Utils).cvtMinifiedFilterToDynArray(minFilter)
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" },"arr" : [ {"arrp1":"arrp1value","tab" : [1,2,3,4,5]}]  }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter.%ToJSON())
    
    Set minFilter = "p1,sub55[subp1],arr[arrp1,tab]"
    Set filter = ##class(Isc.JSONFiltering.Utils).cvtMinifiedFilterToDynArray(minFilter)
    Set filteredJson = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer","arr" : [ {"arrp1":"arrp1value","tab" : [1,2,3,4,5]}]  }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter.%ToJSON())

    Return tSc
}

Method TestSearchCriteria() As %Status
{
    Set tSc = $$$OK

    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set searchCriteria = [["city","Namur","="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator =")

    Set searchCriteria = [["city","Ch","%STARTSWITH"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator %STARTWITH")

    Set searchCriteria = [["city","","NOT NULL"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = json
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator NOT NULL")

    Set jsonNull = [{"name":"John", "city":""},{"name":"Tony","city":""},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set searchCriteria = [["city","","NULL"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(jsonNull,searchCriteria)
    Set expectedResult = [{"name":"John", "city":""},{"name":"Tony","city":""}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator NULL")


    Set searchCriteria = [["city","Mons,Bruges","IN"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator IN")

    Set searchCriteria = [["city","Namur","!="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator !=")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set searchCriteria = [["number",20,"<"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(jsonNum,searchCriteria)
    Set expectedResult = [{"number":10}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator <")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set searchCriteria = [["number",20,"<="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(jsonNum,searchCriteria)
    Set expectedResult = [{"number":10},{"number":20}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator <=")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set searchCriteria = [["number",20,">"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(jsonNum,searchCriteria)
    Set expectedResult = [{"number":40},{"number":30}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator >")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set searchCriteria = [["number",20,">="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(jsonNum,searchCriteria)
    Set expectedResult = [{"number":40},{"number":30},{"number":20}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator >=")

    Set searchCriteria = [["city","Charleroi","<"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"Alain","city":"Bruges"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator < with string value")

    Set searchCriteria = [["city","Charleroi","<="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Alain","city":"Bruges"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator <= with string value")

    Set searchCriteria = [["city","Charleroi",">"]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Aurélien","city":"Mons"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator > with string value")

    Set searchCriteria = [["city","Charleroi",">="]]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
    Set expectedResult = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Aurélien","city":"Mons"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Search criteria operator >= ")

    Return tSc
}

Method TestSort() As %Status
{
    Set tSc = $$$OK
    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set sort = ["name","desc"]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).sort(json,sort)
    Set expectedResult = [{"name":"Alain","city":"Bruges"},{"name":"Alessio","city":"Namur"},{"name":"Aurélien","city":"Mons"},{"name":"John","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Tony","city":"Charleroi"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Sort string desc")

    Set sort = ["name","asc"]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).sort(json,sort)
    Set expectedResult = [{"name":"Tony","city":"Charleroi"},{"name":"Matteo","city":"Namur"},{"name":"Lorenzo","city":"Namur"},{"name":"John","city":"Charleroi"},{"name":"Aurélien","city":"Mons"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Sort string asc")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set sort = ["number","desc"]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).sort(jsonNum,sort)
    Set expectedResult = [{"number":10},{"number":20},{"number":30},{"number":40}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Sort number desc")

    Set jsonNum = [{"number":40},{"number":10},{"number":30},{"number":20}]
    Set sort = ["number","asc"]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).sort(jsonNum,sort)
    Set expectedResult = [{"number":40},{"number":30},{"number":20},{"number":10}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Sort number asc")

    Return tSc
}

Method TestCombinationCriteriaFilter() As %Status
{
    Set tSc = $$$OK
    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
    Set searchCriteria = [["city","Namur","="]]
    Set filter = ["name"]
    Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).applyAllFilterParameters(json,filter,searchCriteria)
    Set expectedResult = [{"name":"Lorenzo"},{"name":"Matteo"},{"name":"Alessio"}]
    Do $$$AssertEquals(expectedResult.%ToJSON(),result.%ToJSON(),"Combination Search criteria and property filter")
    Return tSc
}

}
