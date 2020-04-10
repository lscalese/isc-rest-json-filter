ROUTINE jsonfilter [Type=INC]

#define JSFilterIDX                         %zzJSONFilteringI
#define JSFilterDefaultFlds                 $Select($Isobject(%request):$Get(%request.Data("flds",1)),1:"")
#define JSFilterDefaultCriteria             $Select($Isobject(%request):$Get(%request.Data("searchCriteria",1)),1:"")

#define JSFilterCollation                   7

#define JSCriteriaOldVersionVar             %zCriteriaOldVersion
#define JSCriteriaSetOldVerFlag(%arg)       Set $$$JSCriteriaOldVersionVar = %arg
#define JSCriteriaOldVersion                $Get($$$JSCriteriaOldVersionVar,0)

#define JSFilterDef(%json)                  ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(%json)
#define JSFilterOnlyDef(%json)              ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%json)
#define JSCriteriaOnlyDef(%json)            ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%json)

#define JSFilter(%json,%filter,%criteria)   ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(%json,%filter,%criteria)
#define JSFilterOnly(%json,%filter)         ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%json,%filter)
#define JSCriteriaOnly(%json,%criteria)     ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%json,%criteria)