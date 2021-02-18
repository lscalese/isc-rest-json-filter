Include jsonfilter

Class Isc.JSONFiltering.DynObjSorter Extends %RegisteredObject
{

Property inputJSON As %DynamicArray;

Property sortBy As %String;

Property sortOrder As %Integer;

Property collation As %Integer [ InitialExpression = {$$$JSFilterCollation} ];

ClassMethod cmSort(inputJSON As %DynamicArray, sortOptions As %DynamicArray) As %DynamicArray
{
    Set sortBy = sortOptions.%Get(0)
    Set order = $Zcvt(sortOptions.%Get(1),"l")
    Set order = $Select(order="" : 1, order="desc" : -1, 1: 1)
    Set sorter = ..%New(inputJSON, sortBy, order)
    Return sorter.sort()
}

Method %OnNew(inputJSON As %DynamicArray, sortBy As %DynamicArray, sortOrder As %Integer = 1, collation As %Integer = {$$$JSFilterCollation}) As %Status [ Private ]
{
    Set ..inputJSON = inputJSON
    Set ..sortBy = sortBy
    Set ..sortOrder = sortOrder
    Set ..collation = collation
    Return $$$OK
}

Method sort() As %DynamicArray
{
    Set result = []

    Set iter = ..inputJSON.%GetIterator()
    While iter.%GetNext(.key , .item ) {
        Set value = ##class(Isc.JSONFiltering.Utils).getPropertyValue(item, ..sortBy)
        If $Isvalidnum(value) {
            Set srt(value,key)=""
        } Else {
            Set srt($System.Util.Collation(value,..collation,32768),key) = ""
        }
    }
    
    Set k1 = $Order(srt(""),..sortOrder)
    While k1'="" {
        Set k2 = $Order(srt(k1,""))
        While k2'="" {
            Do result.%Push(..inputJSON.%Get(k2))
            Set k2 = $Order(srt(k1,k2))
        }
        Set k1 = $Order(srt(k1),..sortOrder)
    }
    Kill srt
    
    Return result
}

}
