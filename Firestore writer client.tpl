___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Firestore writer client",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "requestOrigin",
    "displayName": "Request origin",
    "simpleValueType": true,
    "notSetText": "Please enter a valid request origin",
    "valueHint": "https://requestorigin.com",
    "help": "Origin header of the incoming http request eg. https://yoursite.com",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^https\\:\\/\\/.+"
        ]
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "requestPath",
    "displayName": "Request path",
    "simpleValueType": true,
    "help": "Path of the incoming http request eg /path",
    "valueHint": "/requestPath",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^\\/.+"
        ]
      }
    ],
    "notSetText": "Please enter valid request path"
  },
  {
    "type": "TEXT",
    "name": "projectId",
    "displayName": "Google Cloud Platform Project ID",
    "simpleValueType": true,
    "help": "Name of the GCP project in which your Firestore collection is stored",
    "valueHint": "GCP-PROJECT-ID",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "notSetText": "Please enter valid GCP project ID"
  },
  {
    "type": "TEXT",
    "name": "collection",
    "displayName": "Collection",
    "simpleValueType": true,
    "help": "Name of the collection in which you want to write or update document",
    "valueHint": "collectionName",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "[^\\/].+[^\\/]"
        ]
      }
    ],
    "notSetText": "Please enter valid collection name"
  }
]


___SANDBOXED_JS_FOR_SERVER___

//Necessary Client API's
const claimRequest = require('claimRequest');
const Firestore = require('Firestore');
const getRequestBody = require('getRequestBody');
const getRequestHeader = require('getRequestHeader');
const getRequestMethod = require('getRequestMethod');
const getRequestPath = require('getRequestPath');
const getRequestQueryParameter = require('getRequestQueryParameter');
const JSON = require('JSON');
const returnResponse = require('returnResponse');
const setResponseBody = require('setResponseBody');
const setResponseHeader = require('setResponseHeader');
const setResponseStatus = require('setResponseStatus');


//If client intercepts valid incoming http resquest...claim it!
if(getRequestPath() === data.requestPath && getRequestHeader('origin') === data.requestOrigin && getRequestMethod() === 'POST'){
  
  claimRequest();
  
  //Store userID queryParam in const
  const userID =  getRequestQueryParameter('userID');
  
  //Set response headers
  setResponseHeader("access-control-allow-credentials", "true");
  setResponseHeader("access-control-allow-origin", getRequestHeader("origin"));
  
  //Turning requestBody JSON string into an object and storing it in input CONST
  const input = JSON.parse(getRequestBody());
  
  //Start working with the Firestore API
  Firestore.write(data.collection + '/' + userID, input, {
    projectId: data.projectId,
    merge: true,
  })
  //Handle promise response
  .then(function(response){
    return response;
   })
  //Return response to client that sent the request
  .then(function(response){
    setResponseBody('I have written to the following Firestore document: ' + response);
    setResponseStatus(200);
    returnResponse();
  });
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "bodyAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "pathAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "return_response",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_firestore",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedOptions",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "projectId"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "mi-proyecto"
                  },
                  {
                    "type": 1,
                    "string": "miColeccion"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 1/7/2024, 22:00:35


