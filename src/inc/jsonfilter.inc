ROUTINE jsonfilter [Type=INC]

#define JSFilterGetRequestFields                $Select($Isobject($Get(%request)):$Get(%request.Data("jsflt",1)),1:"")
#define JSFilterGetRequestSearchCriteria        $Select($Isobject($Get(%request)):$Get(%request.Data("jsfltsc",1)),1:"")
#define JSFilterGetRequestSort                  $Select($Isobject($Get(%request)):$Get(%request.Data("jsfltsrt",1)),1:"")
#define JSFilterGetRequestLimit                 $Select($Isobject($Get(%request)):$Get(%request.Data("jsfltlmt",1)),1:"")


#define JSFilterGetFlds                         $Select($$$JSFilterGetRequestFields'="":$$$JSFilterCvtFieldsParam($$$JSFilterGetRequestFields),1:"")
#define JSFilterGetSearchCriteria               $Select($$$JSFilterGetRequestSearchCriteria'="":[].%FromJSON($$$JSFilterGetRequestSearchCriteria),1:"")
#define JSFilterGetSort                         $Select($$$JSFilterGetRequestSort'="":[].%FromJSON("["""_$Replace($$$JSFilterGetRequestSort,",",""",""")_"""]"),1:"")
#define JSFilterGetLimit                        +$$$JSFilterGetRequestLimit



#define JSFilterCvtFieldsParam(%arg)            ##class(Isc.JSONFiltering.Utils).cvtMinifiedFilterToDynArray(%arg)
#def1arg JSFilter(%arg)                         ##class(Isc.JSONFiltering.Services.FilteringServices).applyAllFilterParameters(%arg)
#def1arg JSFilterProperty(%arg)                 ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%arg)
#def1arg JSFilterCriteria(%arg)                 ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%%arg)
#def1arg JSFilterSort(%arg)                     ##class(Isc.JSONFiltering.Services.FilteringServices).sort(%%arg)
#def1arg JSFilterLimit(%arg)                    ##class(Isc.JSONFiltering.Services.FilteringServices).limitResult(%%arg)

#define JSFilterIDX                             %zzJSONFilteringI
#define JSFilterCollation                       7