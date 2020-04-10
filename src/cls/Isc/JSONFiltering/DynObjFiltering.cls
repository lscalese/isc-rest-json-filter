Class Isc.JSONFiltering.DynObjFiltering Extends %RegisteredObject
{

Property filter As %String;

Property inputDynamicObject As %DynamicObject;

Property tFilter As %Binary [ MultiDimensional, Private ];

ClassMethod cmFilter(inputDynamicObject As %DynamicObject, filter As %String) As %DynamicObject
{
    Set filtering = ..%New(inputDynamicObject, filter)
    Set tOutputDynamic = filtering.filterDynamicObject(filtering.inputDynamicObject)
    Return tOutputDynamic
}

Method %OnNew(inputDynamicObject As %DynamicObject, filter As %String) As %Status [ Private ]
{
    Set ..filter = filter
    Set ..inputDynamicObject = inputDynamicObject
    Do ..processFilter(filter,.arr)
    Merge i%tFilter = arr
    Return $$$OK
}

Method filterDynamicObject(inputDynamicObject As %DynamicObject, tFilter As %String = "") As %DynamicObject [ Private ]
{
    Set tFilterKey = tFilter
    Set isArray = inputDynamicObject.%IsA("%DynamicArray")
    Set outputDynamicObject = $Select( isArray : [], 1: {} )
    
    Set iter = inputDynamicObject.%GetIterator()
   
	While iter.%GetNext(.key , .tProperty ) {
        Set:('isArray)&&(tFilterKey'="*") tFilterKey = $Select( tFilter="" : key , 1 : tFilter _ "." _ key) 
        If $IsObject(tProperty) {
            Set:..inFilter(tFilterKey,.partial) $Property(outputDynamicObject, key) = ..filterDynamicObject(tProperty, $Select( partial : tFilterKey , 1 :"*" ) )
        } Else {
            Set:..inFilter(tFilterKey) $Property(outputDynamicObject, key) = tProperty
        }
	}
    Return outputDynamicObject
}

Method inFilter(tFilterKey As %String, ByRef partial As %Boolean = 0) As %Boolean [ Private ]
{
    Set partial = 0
    
    If tFilterKey="*" {
    
        Return 1
    
    } ElseIf tFilterKey="" { ;top node is an array.
        
        Set partial = 1
        Return 1 
    
    } ElseIf $Data(i%tFilter(tFilterKey),value) {
        
        Set partial = value = "partial"
        Return 1
    
    }
    Return 0
}

ClassMethod processFilter(filter As %String, ByRef arr As %Binary) As %Status
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
            Set arr( parent ) = "partial"
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
