Class Isc.JSONFiltering.DynObjSearchCriteria Extends %RegisteredObject [ Deprecated ]
{

Parameter DOCDBNAME = "Isc.JSONFiltering.JSONFiltering";

Parameter OBJSEPARATOR = "__";

Property inputJSON As %DynamicArray;

Property searchCriteria As %DynamicArray;

Property tempDBName As %String [ InitialExpression = {..#DOCDBNAME _ $Increment(^Isc.JSONFiltering.JSONFiltering)}, Private ];

Property db As %DocDB.Database [ Private ];

ClassMethod cmSearchCriteria(inputJSON As %DynamicArray, searchCriteria As %DynamicArray) As %DynamicArray
{
    Return:inputJSON.%Size()=0 inputJSON
    Set dynObjSearching = ..%New(inputJSON,searchCriteria)
    Return dynObjSearching.search()
}

Method search() As %DynamicArray
{
    Set resultArray = []
    Try {
        Do ..generateDocDB()
        Do ..fillDocDB()
        Set result = ..db.%FindDocuments(..searchCriteria)
        
        If (result.sqlcode'=100) && (result.sqlcode'=0) {
            $$$ThrowStatus($$$ERROR($$$SQLError, result.sqlcode, result.message))
        }

        Set iter = result.content.%GetIterator()
        While iter.%GetNext(.key , .item ) {
            ;Do resultArray.%Push({}.%FromJSON(item.%Doc))
        }

        Do ..deleteDocDB()
    } Catch (ex) {
        Try { Do ..deleteDocDB() } Catch (e) {}
        Throw ex
    }
    Return resultArray
}

Method %OnNew(inputJSON As %DynamicArray, searchCriteria As %DynamicArray) As %Status [ Private ]
{
    Set ..inputJSON = inputJSON
    Set ..searchCriteria = searchCriteria
    If (searchCriteria.%Size() > 0) && ('$Isobject(searchCriteria.%Get(0))) {
        Set ..searchCriteria = [].%Push(searchCriteria)
    }
    Return $$$OK
}

Method fillDocDB() [ Private ]
{
    Set iter = ..inputJSON.%GetIterator()
    While iter.%GetNext(.key , .document ) {
        Do ..db.%SaveDocument(document)
    }
    Return
}

Method getDocDB() As %DocDB.Database [ Private ]
{
    Return ##class(%DocDB.Database).%GetDatabase(..tempDBName)
}

Method generateDocDB() As %DocDB.Database [ Private ]
{
   Set ..db = ##class(%DocDB.Database).%CreateDatabase(..tempDBName)
   Do ..createProperties()
   Return ..db
}

Method createProperties() [ Private ]
{
    Set iter = ..searchCriteria.%GetIterator()
    While iter.%GetNext(.key , .nestedTab ) {
        Set property = nestedTab.%Get(0)
        Set type = ..getType(property)
        Set expression = ..getExpression(property)
        Do ..db.%CreateProperty(property, type , expression, 0)
    }

    Return
}

Method getType(property As %String) As %String [ Private ]
{
    Set item = ..inputJSON.%Get(0)

    If property '[ ..#OBJSEPARATOR {
        
        Set type = item.%GetTypeOf(property)

    } Else {

        Set tmpList = $Listfromstring(property,..#OBJSEPARATOR), ptr = 0

        While $Listnext(tmpList,ptr,key) {
            Set temp = $Property(item,key)
        }

        Set type = item.%GetTypeOf(temp)

    }

    Return:type="number" "%Numeric"
    Return:type="boolean" "%Boolean"
    Return "%String"
}

Method getExpression(property As %String) As %String [ Private ]
{
    Return "$." _ $Replace(property,..#OBJSEPARATOR,".")
}

Method deleteDocDB() As %Boolean [ Private ]
{
    Return ##class(%DocDB.Database).%DropDatabase(..tempDBName)
}

}
