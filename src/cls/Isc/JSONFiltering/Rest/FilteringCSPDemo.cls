Class Isc.JSONFiltering.Rest.FilteringCSPDemo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    &html<
        <!doctype html>
        <html lang="en">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
            <title>Filter JSON - test page</title>
        </head>
        <body onload="filterJSON();">
            <nav class="navbar navbar-dark bg-dark">
                <span class="navbar-brand mb-0 h1">Test JSON Filter</span>
                <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                    <li class="nav-item active">
                    <a class="nav-link" href="https://github.com/lscalese/isc-rest-json-filter">Github</a>
                </li>
                </ul>   
                
            </nav>
            &nbsp;<br/>
            <div class="container">

                


                <div class="btn-toolbar" role="toolbar" aria-label="Toolbar with button groups">
                    <div class="btn-group mr-2" role="group" aria-label="Basic example">
                        <button type="button" class="btn btn-secondary" onclick="updatePropertyFilter('age,name,eyeColor,company');">Simple filter</button>
                        <button type="button" class="btn btn-secondary" onclick="updatePropertyFilter('name[first],friends,eyeColor,company');">Nested object</button>
                        <button type="button" class="btn btn-secondary" onclick="updatePropertyFilter('name[first],friends[name,address[city]],eyeColor,company');">Multi level</button>
                        <button type="button" class="btn btn-secondary" onclick="updatePropertyFilter('');">Clear Fitler</button>
                    </div>
                    
                
                    <div class="btn-group mr-2" role="group" aria-label="Basic example">
                        <button type="button" class="btn btn-secondary" onclick="updateSearchCriteria(JSON.stringify(searchCriteria1));">Simple Criteria</button>
                        <button type="button" class="btn btn-secondary" onclick="updateSearchCriteria(JSON.stringify(searchCriteria2));">AND</button>
                        <button type="button" class="btn btn-secondary" onclick="updateSearchCriteria(JSON.stringify(searchCriteria3));">IN</button>
                        <button type="button" class="btn btn-secondary" onclick="updateSearchCriteria('');">Clear Criteria</button>
                    </div>
                    
                </div>

                <div class="form-group">
                    &nbsp;<br/>
                    <label for="filterString">Filter string #(..EscapeHTML("/csp/irisapprest/demoresponse?flds="))#</label>
                    <input type="text" class="form-control" id="filterString"  placeholder="put your filter string, example : age,isActive,name[first],friends[name,address[city]],email">
                </div>
               
                <div class="form-group">
                    <label for="searchCriteria" data-toggle="tooltip" data-placement="top" title="#(..EscapeHTML("Operator list : =, !=, <, >, <=, >=, <>, %STARTSWITH, NULL, IN, and NOT NULL"))#">#(..EscapeHTML("&searchCriteria="))#</label>
                    <input type="text" class="form-control" id="searchCriteria"  placeholder="Search criteria example : #(..EscapeHTML("[[""age"",22,""=""]]"))#">
                </div>
                <button type="button" class="btn btn-primary" onclick="filterJSON();">Submit</button>

                <div class="form-group">
                    &nbsp;<br/>
                    <label for="jsonResponse">JSON Response</label>
                    <textarea class="form-control" id="jsonResponse" rows="20" readonly ></textarea>
                </div>
            </div>

            
            
            <!-- Optional JavaScript -->
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    >
    Do ..writeJS()
    &html<
        </body>
        </html>
    >
    Return $$$OK
}

ClassMethod writeJS() As %Status
{
    Set tSc = $$$OK
    Write "<script type=""text/javascript"">"
    &js<
        /*<*/ var searchCriteria1 = [["age",25,">"]]
        /*<*/ var searchCriteria2 = [["age",22,">"],["eyeColor","brown","="]]
              var searchCriteria3 = [["company","TWIGGERY,COASH","IN"]]

              var basicDefaultAuth = true;
        function filterJSON() {
            jQuery.ajax({
                type: "GET",
                url: "/csp/jsonfilterrest/demoresponse",
                async: true,
                dataType: 'json',
                data: {"flds":jQuery("#filterString").val(),"searchCriteria":jQuery("#searchCriteria").val()},
                success: function (data){
                    var json = JSON.stringify(data,null,2)
                    jQuery("#jsonResponse").val(json);
                },
                error: function(jqXHR, textStatus, errorThrown ) {
                    if (jqXHR.status==401) {
                        basicDefaultAuth = false; // force browser prompt for next query
                    }
                },
                beforeSend: function (xhr) {
                    if (basicDefaultAuth) {
                        xhr.setRequestHeader ("Authorization", "Basic " + btoa("_system:SYS"));
                    }
                }
            });
        }

        function flashElem(id) {
            // only the first time
            jQuery("#"+id).fadeOut(100).fadeIn(100);
        }

        function updatePropertyFilter(v) {
            flashElem('filterString');
            jQuery('#filterString').val(v);
            filterJSON();
        }

        function updateSearchCriteria(v) {
            flashElem('searchCriteria');
            jQuery('#searchCriteria').val(v);
            filterJSON();
        }

        jQuery(function() {
            jQuery("#filterString, #searchCriteria").on("keypress", function(e){
                if (e.which == 13){
                    filterJSON();
                }
            });
            jQuery('[data-toggle="tooltip"]').tooltip()
        });

        
    >
    Write "</script>"
    Return tSc
}

}
