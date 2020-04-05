## Isc-Rest-Json-Filter

This is a tool for easily adding a feature allowing to return a partial JSON response to your REST services.  
The most often, REST services return a large number of fields.  
The bandwidth usage can be very excessive and the parsing process too heavy for a client application (web, mobile...).  
Providing functionality to select fields can be very useful for clients app.

Clients app must simply add "flds" parameter following this structure :  ?flds=field1,field2,field3,... 
Separate each field with a comma.  
You can filter a nested object using ?flds=field1,field2[nestedProperty1,nestedProperty2],field3,...  
Multiple nested level is supported ?flds=field1,field2[nestedProperty1[level2],nestedProperty2],field3,...  

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

Call ##class(Iris.JSON.FilteringServices).filterJSON(json,filter) classmethod.  
The first argument is a dynamic object to filter and the second argument is the filter string.  
The classmethod return a filtered dynamic object.  

If filter string is empty, the return value is the original dynamic object without filtering.  

Example :
```
Set json = {"name" : { "first" : "Edith", "last" : "Scott"}, "friends" : [{"name": "Perkins Cruz", "id":"1", "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]}]}
Set filter = "name[first],friends[name,address[city]]"
Set filteredJSON = ##class(Iris.JSON.FilteringServices).filterJSON(json,filter)
Write filteredJSON.%ToJSON()
```

If you don't pass the filter string argument, the filter by default is %request.Data("flds",1)) value.  
You can easily implement the feature in your REST services using this line : 

```
Write ##class(Iris.JSON.FilteringServices).filterJSON(json).%ToJSON()
```

## How to Test it

### Unit Test

Open IRIS terminal:

```
$ docker-compose exec iris irissession iris
USER>zn "IRISAPP"
IRISAPP>Do ##class(Isc.JSONFiltering.Test.FilteringTest).StartUnitTest()
```

### Test page

Test page http://<host>:<port>/csp/irisapp/Isc.JSONFiltering.Rest.FilteringCSPDemo.cls  
Default : http://localhost:52773/csp/irisapp/Isc.JSONFiltering.Rest.FilteringCSPDemo.cls  

![test_page_capture](/img/test-page.png)

**Attention** : There is ajax requests using basic authentication with the default username\password (_system ...).  

### Postman collection  

For testing purpose a [Postman collection](postman/isc-rest-json-filter.postman_collection.json) is available with a fews filter examples.  

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.  

## Links

If you are interested by this feature, you will be probably interested by [GraphQL](https://graphql.org/) approach.  
An Objectscript implementation by Gevorg Arutiunian is available [here](https://openexchange.intersystems.com/package/GraphQL).  

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

### Dockerfile-web

Dockerfile-web starts IRIS does the same what Dockerfile does and also sets up the web app programmatically


### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)
