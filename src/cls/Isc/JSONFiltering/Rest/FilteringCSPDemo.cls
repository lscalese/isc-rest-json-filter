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

                <div class="btn-group" role="group" aria-label="Basic example">
                    <button type="button" class="btn btn-secondary" onclick="jQuery('#filterString').val('age,name');filterJSON();">Simple</button>
                    <button type="button" class="btn btn-secondary" onclick="jQuery('#filterString').val('name[first],friends');filterJSON();">Nested object</button>
                    <button type="button" class="btn btn-secondary" onclick="jQuery('#filterString').val('name[first],friends[name,address[city]]');filterJSON();">Nest object multi level</button>
                    <button type="button" class="btn btn-secondary" onclick="jQuery('#filterString').val('');filterJSON();">Clear</button>
                </div>
                 
                <div class="form-group">
                    &nbsp;<br/>
                    <label for="filterString">Filter string #(..EscapeHTML("?flds="))#</label>
                    <input type="text" class="form-control" id="filterString"  placeholder="put your filter string, example : age,isActive,name[first],friends[name,address[city]],email">
                </div>
                <button type="button" class="btn btn-primary" onclick="filterJSON();">Submit</button>
                

                <div class="form-group">
                    &nbsp;<br/>
                    <label for="jsonResponse">JSON Response</label>
                    <textarea class="form-control" id="jsonResponse" rows="30" readonly ></textarea>
                </div>
            </div>

            
            
            <!-- Optional JavaScript -->
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
            <script type="text/javascript">
                jQuery(function() {
                    jQuery("#filterString").on("keypress", function(e){
                        if (e.which == 13){
                            filterJSON();
                        }
                    });
                });

                function filterJSON() {
                    jQuery.ajax({
                        type: "GET",
                        url: "/csp/irisapprest/demoresponse",
                        async: true,
                        dataType: 'json',
                        data: {"flds":jQuery("#filterString").val()},
                        success: function (data){
                            var json = JSON.stringify(data,null,2)
                            jQuery("#jsonResponse").val(json);
                        },
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader ("Authorization", "Basic " + btoa("_system:SYS"));
                        }
                    });
                }

            </script>
        </body>
        </html>
    >
    Return $$$OK
}

}
