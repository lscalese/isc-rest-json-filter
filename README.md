## Isc-Rest-Json-Filter

This is a tool for easily adding a feature allowing to return a partial JSON response to your REST services.  
The most often, REST services return a large number of fields.  
The bandwidth usage can be very excessive and the parsing process too heavy for a client application (web, mobile...).  
Providing functionality to select fields can be very useful for clients app.

Clients app must simply add "flds" parameter following this structure :  ?flds=field1,field2,field3,... 
Separate each field with a comma.  
You can filter a nested object using ?flds=field1,field2[nestedProperty1,nestedProperty2],field3,...  
Multiple nested level is supported ?flds=field1,field2[nestedProperty1[level2],nestedProperty2],field3,...  

In addition to that, you can also provide a basic search for your services wich return a json array.  
No additional SQL is needed. Let's use **%DocDB.Database** and the *restriction predicate syntax* :  [["property","value","operator"],["property2","value2","operator2"]]  
Client app can be use the server-side json search with the argument searchCriteria.  
Example : &searchCriteria=[["age",22,"="],["index",2,">"]]


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

## Filter examples

### Top level field

*/csp/irisapprest/demoresponse?flds=name,age,tags*

Result : 
```
{
    "age": 22,
    "name": {
        "first": "Edith",
        "last": "Scott"
    },
    "tags": [
        "ipsum",
        "ullamco",
        "Lorem",
        "velit",
        "qui"
    ]
}
```

### Nested object filter

*/csp/irisapprest/demoresponse?flds=name[first]*  
Result : 
```
{
    "name": {
        "first": "Edith"
    }
}
```

*/csp/irisapprest/demoresponse?flds=name,friends[name]*  
Result : 
```
{
    "name": {
        "first": "Edith",
        "last": "Scott"
    },
    "friends": [
        {
            "name": "Perkins Cruz"
        },
        {
            "name": "Burns Sandoval"
        },
        {
            "name": "Miranda Barker"
        }
    ]
}
```

*/csp/irisapprest/demoresponse?flds=name,friends[name,address[city]],age*  
Result : 
```
{
    "age": 22,
    "name": {
        "first": "Edith",
        "last": "Scott"
    },
    "friends": [
        {
            "name": "Perkins Cruz",
            "address": [
                {
                    "city": "London"
                },
                {
                    "city": "Roma"
                }
            ]
        },
        {
            "name": "Burns Sandoval",
            "address": [
                {
                    "city": "London"
                },
                {
                    "city": "Roma"
                }
            ]
        },
        {
            "name": "Miranda Barker",
            "address": [
                {
                    "city": "London"
                },
                {
                    "city": "Roma"
                }
            ]
        }
    ]
}
```

## How to use

Call ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter) classmethod.  
The first argument is a dynamic object to filter and the second argument is the filter string.  
The classmethod return a filtered dynamic object.  

If filter string is empty, the return value is the original dynamic object without filtering.  

Filter Example :
```
Set json = {"name" : { "first" : "Edith", "last" : "Scott"}, "friends" : [{"name": "Perkins Cruz", "id":"1", "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]}]}
Set filter = "name[first],friends[name,address[city]]"
Set filteredJSON = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json,filter)
Write filteredJSON.%ToJSON()
```

If you don't pass the filter string argument, the filter by default is %request.Data("flds",1)) value.  
You can easily implement the feature in your REST services using this line : 

```
Write ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(json).%ToJSON()
```

Search Criteria Example :

Seach Criteria work only with dynamic array, *search predicate syntax* use the following structure [["property","value","operator"],["property2","value2","operator2"],...].  


```
Set json = [{"name":"John", "city":"Charleroi"},{"name":"Tony","city":"Charleroi"},{"name":"Lorenzo","city":"Namur"},{"name":"Matteo","city":"Namur"},{"name":"Alessio","city":"Namur"},{"name":"Alain","city":"Bruges"},{"name":"Aurélien","city":"Mons"}]
Set searchCriteria = [["city","Namur","="]]
Set result = ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteria(json,searchCriteria)
Write !,result.%ToJSON()
```

We can add a property filter to output only the name :  

```
Set filter = "name"
Set filteredJSON = ##class(Isc.JSONFiltering.Services.FilteringServices).filterJSON(result,filter)
Write !,filteredJSON.%ToJSON()
```

The simplest way to implement these two features in your REST services is :  

```
Write ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(json).%ToJSON()
```

This is a combination of filter property and search criteria.
By default, It retrieves filter in %request.Data("flds",1)) and search criteria in %request.Data("searchCriteria",1)).  

Tips:  

It's possible to use search criteria with a nested object property, for that use double underscore "__" as separator.  
[{"name": {"first": "Edith","last": "Scott"}}]  
For searching on property "last", you may use search criteria like this [["name__last","Scott","="]].  

## How to Test it

### Unit Test

Open IRIS terminal:

```
$ docker-compose exec iris irissession iris
USER>zn "IRISAPP"
IRISAPP>Set ^UnitTestRoot = "/opt/irisapp/tests/"
IRISAPP>Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
```

### Test page

Test page http://host:port/csp/jsonfilter/Isc.JSONFiltering.Rest.FilteringCSPDemo.cls  
Default : http://localhost:52773/csp/jsonfilter/Isc.JSONFiltering.Rest.FilteringCSPDemo.cls  

![test_page_capture](/img/test-page.png)

**Attention** : There is ajax requests using basic authentication with the default username\password (_system ...).  

### Postman collection  

For testing purpose a [Postman collection](postman/isc-rest-json-filter.postman_collection.json) is available with a fews filter examples.  

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

### Dockerfile-zpm

Dockerfile-zpm builds for you a container which contains ZPM package manager client so you are able to install packages from ZPM in this container.
As an example of usage in installs webterminal


### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)

## Links

If you are interested by these features, you will be probably interested by [GraphQL](https://graphql.org/) approach.  
An Objectscript implementation by Gevorg Arutiunian is available [here](https://openexchange.intersystems.com/package/GraphQL).  

Json icon provider [FriCONiX.com](https://friconix.com)