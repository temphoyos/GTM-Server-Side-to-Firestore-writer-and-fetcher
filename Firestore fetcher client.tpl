___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Firestore fetcher client",
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
    "valueHint": "GCP-PROJECT-ID",
    "help": "Name of the GCP project in which your Firestore collection is stored",
    "notSetText": "Please enter valid GCP project ID",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "collection",
    "displayName": "Collection",
    "simpleValueType": true,
    "valueHint": "collectionName",
    "help": "Name of the collection from which you want to retrieve the document.",
    "notSetText": "Please enter valid collection name",
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
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

//Necessary Client API's
const claimRequest = require('claimRequest');
const Firestore = require('Firestore');
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
if(getRequestPath() === data.requestPath && getRequestHeader('origin') === data.requestOrigin && getRequestMethod() === 'GET'){
  
  claimRequest();
  
  //Store userID queryParam in const
  const userID =  getRequestQueryParameter('userID');
  
  //Config response headers
  setResponseHeader("access-control-allow-credentials", "true");
  setResponseHeader("access-control-allow-origin", getRequestHeader("origin"));
  
  //Execute Firestore.read() API
  Firestore.read(data.collection + '/' + userID, {
  projectId: data.projectId,
  })
  .then(function(result){
    return result;
  })
  .then(function(result){
      setResponseBody(JSON.stringify(result));
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
                    "string": "read"
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

Created on 25/8/2024, 15:38:02


