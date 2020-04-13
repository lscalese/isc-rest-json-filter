ROUTINE jsonfilter [Type=INC]

#define JSFilterIDX                             %zzJSONFilteringI

#define JSFilterGetRequestParam                 $Select($Isobject($Get(%request)):$Get(%request.Data("jsfilter",1)),1:"")
#define JSFilterSerializeRequestParam           $Select($$$JSFilterGetRequestParam'="":{}.%FromJSON($$$JSFilterGetRequestParam),1:"")

#define JSFilterGetFlds(%jsfilter)              $Select($Isobject(%jsfilter):%jsfilter.flds,1:"")
#define JSFilterGetSearchCriteria(%jsfilter)    $Select($Isobject(%jsfilter):%jsfilter.sc,1:"")
#define JSFilterGetSort(%jsfilter)              $Select($Isobject(%jsfilter):%jsfilter.sort,1:"")
#define JSFilterGetLimit(%jsfilter)             $Select($Isobject(%jsfilter):%jsfilter.limit,1:"")
#define JSFilterGetMinifiedFlds(%jsfilter)      $Select($Isobject(%jsfilter):%jsfilter.mini,1:"")

#define JSFilterDefaultFlds                     $$$JSFilterGetFlds($$$JSFilterSerializeRequestParam)
#define JSFilterDefaultCriteria                 $$$JSFilterGetSearchCriteria($$$JSFilterSerializeRequestParam)
#define JSFilterDefaultSortOptions              $$$JSFilterGetSort($$$JSFilterSerializeRequestParam)
#define JSFilterDefaultLimitResult              $$$JSFilterGetLimit($$$JSFilterSerializeRequestParam)
#define JSFilterDefaultMinifiedFlds             $$$JSFilterGetMinifiedFlds($$$JSFilterSerializeRequestParam)

#define JSFilterCollation                       7

#def1arg JSFilter(%arg)                         ##class(Isc.JSONFiltering.Services.FilteringServices).applyAllFilterParameters(%arg)

#def1arg JSFilterOnly(%arg)                     ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%arg)
#def1arg JSFilterProperty(%arg)                 ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%arg)

#def1arg JSCriteriaOnly(%arg)                   ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%%arg)
#def1arg JSFilterCriteria(%arg)                 ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%%arg)

#def1arg JSFilterSort(%arg)                     ##class(Isc.JSONFiltering.Services.FilteringServices).sort(%%arg)


#def1arg JSFilterLimit(%arg)                    ##class(Isc.JSONFiltering.Services.FilteringServices).limitResult(%%arg)

#define JSFilterDef(%json)                      ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(%json)
#define JSFilterOnlyDef(%json)                  ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(%json)
#define JSCriteriaOnlyDef(%json)                ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(%json)