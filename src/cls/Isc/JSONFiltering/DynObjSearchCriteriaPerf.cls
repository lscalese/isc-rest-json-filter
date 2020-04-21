Include jsonfilter

/// Added in versoin 1.3.0<br/>
/// Replace Isc.JSONFiltering.DynObjSearchCriteria class<br/> in order to increase performance<br/>
/// Use cmSearchCriteria classmethod with an DynamicArray and search criteria<br/>
Class Isc.JSONFiltering.DynObjSearchCriteriaPerf Extends %RegisteredObject
{

/// Dynamic array to perform a search.
Property inputJSON As %DynamicArray;

/// Criteria for searching into inputJSON property <br/>
/// It's the restriction predicate syntax <br/>
/// example [["name","Edith","="],["company","ACCEL","="]] </br>
/// operator list : =, !=, <, >, <=, >=, <>, %STARTSWITH, NULL, IN, and NOT NULL
Property searchCriteria As %DynamicArray;

/// Internal use<br/>
Property requestId As %Integer [ InitialExpression = {$Increment(^Isc.JSONFiltering.JSONFiltering)}, Private ];

/// Used collation for string properties (Default is 7)
Property collation As %Integer [ InitialExpression = {$$$JSFilterCollation} ];

ClassMethod cmSearchCriteria(inputJSON As %DynamicArray, searchCriteria As %DynamicArray) As %DynamicArray
{
    Return:inputJSON.%Size()=0 inputJSON
    Set dynObjSearching = ..%New(inputJSON,searchCriteria)
    Return dynObjSearching.search()
}

Method %OnNew(inputJSON As %DynamicArray, searchCriteria As %DynamicArray, collation As %Integer = {$$$JSFilterCollation}) As %Status [ Private ]
{
    Set ..inputJSON = inputJSON
    Set ..searchCriteria = searchCriteria
    Set ..collation = collation

    If (searchCriteria.%Size() > 0) && ('$Isobject(searchCriteria.%Get(0))) {
        Set ..searchCriteria = [].%Push(searchCriteria)
    }
    
    Return $$$OK
}

Method search() As %DynamicArray [ Private ]
{
    Set resultArray = []
    
    ; Build a small temp indices in memory
    Do ..buildIndices()
    
    ; Search matching item in indices
    Set keyResult = ..find()

    ; Push matching result to resultArray
    Set iter = keyResult.%GetIterator()
    While iter.%GetNext(.key , .id ) {
        Do resultArray.%Push(..inputJSON.%Get(id))
    }

    ; Desctruct temp indices
    Kill $$$JSFilterIDX(..requestId) 

    Return resultArray
}

Method find() As %DynamicArray [ Private ]
{
    Set result = []
    
    Set id = ""
    For  {
        
        Set id = $Order($$$JSFilterIDX(..requestId, id))
        Quit:id=""

        Set iterSC = ..searchCriteria.%GetIterator()
        While iterSC.%GetNext(.keySC , .nestedTab ) {
            Set add = 1
            Set indexName = nestedTab.%Get(0)
            Set conditionValue = nestedTab.%Get(1)
            Set operator = $zcvt(nestedTab.%Get(2),"u")
            Set value = $Listget($$$JSFilterIDX(..requestId, id, indexName),2)
            Set nullvalue = ""

            Set collation = $Listget($$$JSFilterIDX(..requestId, id, indexName),1)
            If collation '= "" {
                If operator = "IN" {
                    Set conditionValue = $Listfromstring(conditionValue,",")
                    For i=1:1:$Listlength(conditionValue) {
                        Set $List(conditionValue,i)=$System.Util.Collation($List(conditionValue,i),collation,32768)
                    }
                } Else {
                    Set conditionValue =  $System.Util.Collation(conditionValue,collation,32768)
                }
                Set nullvalue = $System.Util.Collation(nullvalue,collation,32768)
            }
            
            If '..checkCondition(value,conditionValue,operator,nullvalue) {
                Set add = 0
                Quit 
            }
        }

        Do:add result.%Push(id)
    }

    Return result
}

ClassMethod checkCondition(value As %String, conditionValue As %String, operator As %String, nullvalue As %String = "") As %Boolean
{
    ;=, !=, <, >, <=, >=, <>, %STARTSWITH, NULL, IN, and NOT NULL
    Set check = 0

    ; We apply a specific operator for string value.
    Set isNum = $Isvalidnum(conditionValue) 

    If operator = "=" {
        Set check = (value = conditionValue)
    } ElseIf (operator = "!=") || (operator = "<>") {
        Set check = (value '= conditionValue)
    } ElseIf operator = "<" {
        If isNum {
            Set check = (value < conditionValue)
        } Else {
            ; conditionValue sort after value
            Set check = (conditionValue ]] value)
        }
    } ElseIf operator = ">" {
        If isNum {
            Set check = (value > conditionValue)
        } Else {
            ; value sort after conditionValue
            Set check = (value ]] conditionValue)
        }
    } ElseIf operator = "<=" {
        If isNum {
            Set check = (value '> conditionValue)
        } Else {
            ; value sort NOT after conditionValue
            Set check = (value ']] conditionValue)
        }
    } ElseIf operator = ">=" {
        If isNum {
            Set check = (value '< conditionValue)
        } Else {
            ; conditionValue NOT sort after value
            Set check = (conditionValue ']] value)
        }
    } ElseIf operator = "NULL" {
        Set check = (value = nullvalue)
    } ElseIf operator = "NOT NULL" {
        Set check = (value '= nullvalue)
    } ElseIf operator = "IN" {
        Set check = ( $Listfind(conditionValue,value) > 0 )
    } ElseIf operator = "%STARTSWITH" {
        Set check = ( $Extract(value,1,$Length(conditionValue)) = conditionValue )
    }
    Return check
}

/// Build indices based on criteria properties <br/>
/// These small indices are builded in memory and removed after the searching process. <br/>
Method buildIndices() [ Private ]
{
    Set iter = ..inputJSON.%GetIterator()
    While iter.%GetNext(.key , .document ) {
        
        Set iterSC = ..searchCriteria.%GetIterator()
        While iterSC.%GetNext(.keySC , .nestedTab ) {
            Set indexName = nestedTab.%Get(0)
            Do ..buildIndex(indexName, document, key)
        }

    }
    Return
}

Method buildIndex(index As %String, document As %DynamicObject, id As %Integer) As %Status [ Private ]
{
    Set tList = $Listfromstring($Replace(index,"__","."),".")   ; Compatibility with version less than 1.3.0 
    
    Set ptr = 0
    Set propertyValue = document
    Set type = "string"

    While $Listnext(tList,ptr,propertyName) {

        Quit:propertyValue=""
        
        Set type = propertyValue.%GetTypeOf(propertyName)
        Set propertyValue = $Property( propertyValue, propertyName )
    }
    
    Set collation = ""
    If '$Isvalidnum(propertyValue) {
        Set propertyValue = $System.Util.Collation(propertyValue,..collation,32768)
        Set collation = ..collation
    }
    Set $$$JSFilterIDX(..requestId, id, index) = $Listbuild(collation,propertyValue)
    
    Return
}

}
