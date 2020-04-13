Class Isc.JSONFiltering.Utils
{

ClassMethod getPropertyValue(item As %DynamicObject, property As %String) As %String
{
    Set tList = $Listfromstring(property,".")
    Set ptr = 0
    Set propertyValue = item

    While $Listnext(tList,ptr,propertyName) {
        Quit:'$Isobject(propertyValue)
        Set propertyValue = $Property( propertyValue, propertyName )
    }

    Return propertyValue
}

ClassMethod cvtMinifiedFilterToDynArray(filter As %String) As %DynamicArray
{
    Set propertyFilter = []
    Do ..processMinifiedFilter(filter,.arr)
    Return:'$Data(arr) propertyFilter
    Set key = ""
    For  {
        Set key = $Order(arr(key))
        Quit:key=""
        Do propertyFilter.%Push(key)
    }
    Return propertyFilter
}

ClassMethod processMinifiedFilter(filter As %String, ByRef arr As %Binary) As %Status
{
    Kill arr
    Set tSc = $$$OK, parent = "", tBuff = "", prevChar = ""

    For pos=1:1:$Length(filter) {
        
        Set char = $Extract(filter,pos)
        
        If (char = ",") && (prevChar '= "]") {

            Set arr( ..buildKey(parent,tBuff) ) = ""
            Set tBuff = ""

        } ElseIf char = "[" {
            
            Set parent = parent _ $s(parent'="":".",1:"") _tBuff
            ;Set arr( parent ) = "partial"
            Set tBuff = ""

        } ElseIf char = "]" {
            
            Set arr( ..buildKey(parent,tBuff) ) = ""
            Set tBuff = ""
            Set parent = $Piece(parent,".",*-1)

        } ElseIf char '= "," {
            
            Set tBuff = tBuff _ char
            
        }

        Set prevChar = char
    }

    If tBuff '= "" {
        Set arr( ..buildKey(parent,tBuff) ) = ""
    }
    
    Return tSc
}

ClassMethod buildKey(parent As %String, tBuff As %String) As %String [ CodeMode = expression, Private ]
{
$Select(parent="":tBuff,1:parent _ "." _ tBuff)
}

}
