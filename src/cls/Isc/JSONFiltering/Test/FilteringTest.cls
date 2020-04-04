Class Isc.JSONFiltering.Test.FilteringTest Extends %UnitTest.TestCase
{

ClassMethod SetUnitTestRoot(directory As %String) As %Status
{
    Set ^UnitTestRoot=##class(%File).NormalizeDirectory(directory)
    Return $$$OK
}

ClassMethod StartUnitTest()
{
    Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
    Quit
}

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
    Set filteredJson = ##class(Iris.JSON.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer", "p2":"uiop" }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Set filter = "p1,sub[subp1]"
    Set filteredJson = ##class(Iris.JSON.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" } }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Set filter = "p1,sub[subp1],arr[arrp1,tab]"
    Set filteredJson = ##class(Iris.JSON.FilteringServices).filterJSON(json,filter)
    Set expectedResponse = { "p1":"azer",  "sub" : { "subp1" : "azer" },"arr" : [ {"arrp1":"arrp1value","tab" : [1,2,3,4,5]}]  }
    Do $$$AssertEquals(expectedResponse.%ToJSON(),filteredJson.%ToJSON(),filter)

    Return tSc
}

}
