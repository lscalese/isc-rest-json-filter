# JSON Filter

This is an application for adding a fews helpful features to your rest services :

* [Property filtering](#Property-filtering)
* [Searching](#Searching)
* [Sorting](#Sorting)
* [Limit result](#Limit-result)

Some basic features required in most rest services.  

## Quick start

Include **jsonfilter inc file** to your REST services class and apply **$$$JSFilter(json)** macro to a %DynamicObject Or %DynamicArray.  

```
Include jsonfilter

Class Isc.JSONFiltering.Rest.FilteringDemo Extends %CSP.REST
{

Parameter CONTENTTYPE = {..#CONTENTTYPEJSON};

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/demoresponse" Method="GET" Call="demoJsonResponse" Cors="true"/>
</Routes>
}

ClassMethod demoJsonResponse() As %DynamicObject
{
    Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]

    Write $$$JSFilter(json).%ToJSON()
    
    Return $$$OK
}
}
```

**$$$JSFilter(json)** macro apply all json filter features automatically.

## Property filtering

It's an interesting feature for your client app that need to reduce the bandwith usage.  

Property filter is a simple dynamic array which contain the list of properties.  
You can use dot as a separator to specify a nested property.  
```
Set json = {"name" : { "first" : "Edith", "last" : "Scott"}, "friends" : [{"name": "Perkins Cruz", "id":"1", "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]}]}

Set propertyFilter = ["name.first","friends.name","friends.address.city"]
Set filteredJSON = $$$JSFilterProperty(json,propertyFilter)

Write filteredJSON.%ToJSON()
```

For testing purpose in an Iris terminal, you can use a classmethod call instead of $$$JSFilterProperty macro.  
```
Set filteredJSON = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,propertyFilter) 
```
We recommand to always use macro in your app.  It would be useful if a class is renamed in a further version.  

*Result*
```
{"name":{"first":"Edith"},"friends":[{"name":"Perkins Cruz","address":[{"city":"London"},{"city":"Roma"}]}]}
```

## Searching

Seach Criteria work with dynamic array parameters following this syntax [["property","value","operator"],["property2","value2","operator2"],...].  
It's the same structure of *restriction predicate syntax* used with %FindDocuments (%DocDB.Database).  


```
Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]

Set searchCriteria = [["city","Namur","="]]
Set result = $$$JSFilterCriteria(json,searchCriteria)
Write !,result.%ToJSON()
```

You can use the folowing classmethod instead of $$$JSFilterCriteria for testing purpose : 
```
Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
```

*Result*  
```
[{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"}]
```

## Sorting

Sort parameter is a dynamic array with two items.  
The first item is the "sort by" property and the second item is the order "desc" or "asc".  
If the second item is missing, "desc" is selected by default.  
The used property to sort can be a nested property, but not a list or a property in a nested list of object.  


```
Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]

Set sort = ["city","desc"]
Set result = $$$JSFilterSort(json,searchCriteria)
Write !,result.%ToJSON()
```

You can use the folowing classmethod instead of $$$JSFilterSort for testing purpose : 
```
Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).sort(json,sort)
```

*Result*  
```
[{"name":"Alain","city":"Bruges"},{"name":"John","city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Aurélien","city":"Mons"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"}]
```

## Limit result

Maximum number of records to return.

```
Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]

Set limit = 3
Set result = $$$JSFilterLimit(json,limit)
Write !,result.%ToJSON()
```

You can use the folowing classmethod instead of $$$JSFilterLimit for testing purpose : 
```
Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).limitResult(json,limit)
```

*Result*  
```
[{"name":"John","city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"}]
```

## How it works with REST client app

Client REST app can use these features just by adding request parameters.  
See the following tab:  

| Feature | Request Parameter Name | Example Value | 
|:--|:--|--:|
| Property filtering | jsflt | ``name,friends[name,address[city]]`` |
| Searching | jsfltsc | ``["name.first","Edith","="]`` |
| Sorting | jsfltsrt | ``name.first,desc`` |
| Limit | jsfltlmt | ``5`` |

There is no mandatory query parameter.

## Back-end REST app

Backend application retrieve filter data provided by client app and process it with **$$$JSFilter** macro.  
In the following example, the macro return a filtered %DynamicObject or %DynamicArray.  
json is a %DynamicObject or %DynamicArray to filter.

```
Set filteredJSON = $$$JSFilter(json)
```

The macro $$$JSFilter retrieve all filter data in %request.Data and call the appropriate process.  

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/lscalese/isc-rest-json-filter.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```


## How to Test it

### Unit Test

Open IRIS terminal:

```
$ docker-compose exec iris irissession iris
USER>zn "IRISAPP"
IRISAPP>Set ^UnitTestRoot = "/opt/irisapp/tests/"
IRISAPP>Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
```

### Swagger-UI

There is Open API Specification 2.0.  
Swagger-UI can be used:  

 * Go to this page http://localhost:52773/swagger-ui/index.html
 * put ``http://localhost:52773/csp/jsonfilterrest/_spec`` in search bar
 * click explore

 ![swagger-ui](https://github.com/lscalese/isc-rest-json-filter/raw/master/img/swagger-ui.png)


### Test page

Basic test page : http://localhost:52773/csp/jsonfilter/Isc.JSONFiltering.Rest.FilteringCSPDemo.cls  

![test_page_capture](https://github.com/lscalese/isc-rest-json-filter/raw/master/img/test-page.png)

This page is now useless with [swagger-ui](#Swagger-UI) feature.  


### Postman collection  

For testing purpose a [Postman collection](postman/isc-rest-json-filter.postman_collection.json) is available with some filter examples.  

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.  

## How to start coding
This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.
Open /src/cls/PackageSample/ObjectScript.cls class and try to make changes - it will be compiled in running IRIS docker container.
![docker_compose](https://user-images.githubusercontent.com/2781759/76656929-0f2e5700-6547-11ea-9cc9-486a5641c51d.gif)

Feel free to delete PackageSample folder and place your ObjectScript classes in a form
/src/Package/Classname.cls
[Read more about folder setup for InterSystems ObjectScript](https://community.intersystems.com/post/simplified-objectscript-source-folder-structure-package-manager)

The script in Installer.cls will import everything you place under /src into IRIS.


## What's inside the repository

### Dockerfile

The simplest dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates IRISAPP Namespace and imports ObjectScript code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.
Use .env/ file to adjust the dockerfile being used in docker-compose.

### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)

## Links

If you are interested by these features, you will be probably interested by [GraphQL](https://graphql.org/) approach.  
An Objectscript implementation by Gevorg Arutiunian is available [here](https://openexchange.intersystems.com/package/GraphQL).  
