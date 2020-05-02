Class Isc.JSONFiltering.Rest.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "description":"JSON Filter Demo API",
    "version":"1.0.0",
    "title":"JSON Filter API",
    "contact":{
      "name":"Lorenzo Scalese",
      "email":"lorenzo.scalese@gmail.com"
    },
    "license":{
      "name":"MIT",
      "url":"https://github.com/lscalese/isc-rest-json-filter/blob/master/LICENSE"
    }
  },
  "basePath":"/csp/jsonfilterrest",
  "tags":[
    {
      "name":"developers",
      "description":"Operations available to regular developers"
    }
  ],
  "schemes":[
    "http"
  ],
  "security":[
    {
      "basicAuth":[
      ]
    }
  ],
  "paths":{
    "/ping":{
      "get":{
        "tags":[
          "developers"
        ],
        "summary":"test service",
        "description":"Return a pong with the current date time.\n",
        "produces":[
          "application/json"
        ],
        "operationId":"ping",
        "parameters":[
        ],
        "responses":{
          "200":{
            "description":"pong response",
            "schema":{
              "$ref":"#/definitions/inline_response_200"
            }
          }
        }
      }
    },
    "/_spec":{
      "get":{
        "tags":[
          "developers"
        ],
        "summary":"OpenAPI spec 2.0",
        "description":"OpenAPI spec 2.0 .\n",
        "produces":[
          "application/json"
        ],
        "operationId":"SwaggerSpec",
        "parameters":[
        ],
        "responses":{
          "200":{
            "description":"OpenAPI spec 2.0 in json format."
          }
        }
      }
    },
    "/demoresponse":{
      "get":{
        "tags":[
          "developers"
        ],
        "summary":"return demo data for testing json filter features",
        "description":"Return a JSON with some properties and nested properties in order to\ntest the different capabilities of json filter features.\n",
        "produces":[
          "application/json"
        ],
        "operationId":"demoresponse",
        "parameters":[
          {
            "name":"jsflt",
            "in":"query",
            "description":"Property filter in order return only a fews json fields.\nexample name,age,friends[address[city]]\n",
            "required":false,
            "type":"string"
          },
          {
            "name":"jsfltsc",
            "in":"query",
            "description":"Search Criteria example [\"age\",25,\">\"].\nApplicable only if the response is an Array.  \nIf the response is not an array the limit parameter is ignored.\n",
            "required":false,
            "type":"string"
          },
          {
            "name":"jsfltsrt",
            "in":"query",
            "description":"Sort by example name.first,desc or name.first,asc\nIf sort order is ommited desc is selected by default.\nApplicable only if the response is an Array.\nIf the response is not an array the limit parameter is ignored.\n",
            "required":false,
            "type":"string"
          },
          {
            "name":"jsfltlmt",
            "in":"query",
            "description":"Maximum number of records to return.\nApplicable only if the response is an Array.\nIf the response is not an array the limit parameter is ignored.\n",
            "required":false,
            "type":"string"
          }
        ],
        "responses":{
          "200":{
            "description":"search results matching criteria",
            "schema":{
              "type":"array",
              "items":{
                "$ref":"#/definitions/inline_response_200_1"
              }
            }
          },
          "400":{
            "description":"bad input parameter."
          },
          "500":{
            "description":"Internal error, check parameters value."
          }
        }
      }
    }
  },
  "securityDefinitions":{
    "basicAuth":{
      "type":"basic"
    }
  },
  "definitions":{
    "demoresponse_address":{
      "type":"object",
      "properties":{
        "city":{
          "type":"string"
        },
        "street":{
          "type":"string"
        }
      }
    },
    "inline_response_200_1":{
      "type":"object",
      "properties":{
        "name":{
          "$ref":"#/definitions/demoresponse_name"
        },
        "friends":{
          "type":"array",
          "items":{
            "$ref":"#/definitions/demoresponse_friends"
          }
        }
      }
    },
    "inline_response_200":{
      "type":"object",
      "properties":{
        "pong":{
          "type":"string"
        }
      }
    },
    "demoresponse_friends":{
      "type":"object",
      "properties":{
        "id":{
          "type":"integer"
        },
        "name":{
          "type":"string"
        },
        "address":{
          "type":"array",
          "items":{
            "$ref":"#/definitions/demoresponse_address"
          }
        }
      }
    },
    "demoresponse_name":{
      "type":"object",
      "properties":{
        "first":{
          "type":"string"
        },
        "last":{
          "type":"string"
        }
      }
    }
  }
}
}

}
