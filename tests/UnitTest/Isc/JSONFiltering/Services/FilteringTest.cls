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

}
