___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id_infobip_lookup",
  "version": 1,
  "securityGroups": [],
  "displayName": "Infobip CDP Lookup Variable",
  "categories": [
    "DATA_WAREHOUSING",
    "UTILITY",
    "PERSONALIZATION"
  ],
  "description": "Variable that returns single contact information from your Infobip CDP Account.",
  "containerContexts": [
    "SERVER"
  ],
  "brand": {
    "displayName": "stape.io"
  }
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "configGroup",
    "displayName": "API Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "baseUrl",
        "displayName": "Base URL",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Your personal Infobip Base URL (e.g., xxxxx.api.infobip.com). Do not include \u0027https://\u0027, use the base URL given by the platform as is.",
        "valueHint": "xxxxx.api.infobip.com"
      },
      {
        "type": "TEXT",
        "name": "apiKey",
        "displayName": "API Key",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Your Infobip API Key found in the Developer Dashboard."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "lookupGroup",
    "displayName": "Lookup Parameters",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "helpLookup",
        "displayName": "Provide one unique identifier from the dropdown list below to lookup the profile."
      },
      {
        "type": "SELECT",
        "name": "type",
        "displayName": "Identifier Type",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "ID",
            "displayValue": "ID"
          },
          {
            "value": "EXTERNAL_ID",
            "displayValue": "External ID"
          },
          {
            "value": "PHONE",
            "displayValue": "Phone"
          },
          {
            "value": "EMAIL",
            "displayValue": "Email"
          },
          {
            "value": "LINE",
            "displayValue": "Line"
          },
          {
            "value": "FACEBOOK",
            "displayValue": "Facebook"
          },
          {
            "value": "TELEGRAM",
            "displayValue": "Telegram"
          },
          {
            "value": "PUSH",
            "displayValue": "Push"
          },
          {
            "value": "WEB_PUSH",
            "displayValue": "Web Push"
          },
          {
            "value": "LIVE_CHAT",
            "displayValue": "Live Chat"
          },
          {
            "value": "VIBER_BOTS",
            "displayValue": "Viber Bots"
          },
          {
            "value": "INSTAGRAM",
            "displayValue": "Instagram"
          },
          {
            "value": "INSTAGRAM_DM",
            "displayValue": "Instagram DM"
          },
          {
            "value": "TWITTER",
            "displayValue": "Twitter"
          },
          {
            "value": "APPLE_BUSINESS_CHAT",
            "displayValue": "Apple Business Chat"
          },
          {
            "value": "KAKAO_SANGDAM",
            "displayValue": "Kakao Sangdam"
          },
          {
            "value": "OPEN_CHANNEL",
            "displayValue": "Open Channel"
          },
          {
            "value": "ZALO_FOLLOWER",
            "displayValue": "Zalo Follower"
          },
          {
            "value": "TIKTOK_BM",
            "displayValue": "Tiktok BM"
          }
        ],
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "identifier",
        "displayName": "Identifier Value",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "type",
            "paramValue": "",
            "type": "PRESENT"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "sender",
        "displayName": "Sender",
        "simpleValueType": true,
        "valueValidators": [],
        "help": "Sender or Application ID. Required for all types except for: \u003cb\u003eID, External ID, Phone or Email\u003c/b\u003e."
      },
      {
        "type": "CHECKBOX",
        "name": "storeResponse",
        "checkboxText": "Store response in cache",
        "simpleValueType": true,
        "help": "Store the response in Template Storage. If all parameters of the request are the same, the response will be taken from the cache if it exists. Defaults to \u003cb\u003eenabled\u003c/b\u003e.",
        "subParams": [
          {
            "type": "TEXT",
            "name": "expirationTime",
            "displayName": "Cache Expiration Time (Hours)",
            "simpleValueType": true,
            "help": "Will update cache if data is expired.",
            "enablingConditions": [
              {
                "paramName": "storeResponse",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "POSITIVE_NUMBER"
              },
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": 12
          }
        ],
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "outputKeys",
        "checkboxText": "Extract keys from returned JSON object",
        "simpleValueType": true,
        "subParams": [
          {
            "type": "TEXT",
            "name": "outputKeysList",
            "displayName": "Key Names",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "outputKeys",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "valueHint": "id, firstName, contactInformation.email.0.address"
          },
          {
            "type": "RADIO",
            "name": "objectOutput",
            "displayName": "Output object structure",
            "radioItems": [
              {
                "value": "createFlatObject",
                "displayValue": "Create one-level deep (flat) object",
                "help": "All nested objects will be transformed it into a single-level object, with their keys joined with an underscore (\"_\"). \u003cbr/\u003e Any hyphens (\"-\") that might exist in the original keys will also be replaced with an underscore (\"_\")."
              },
              {
                "value": "createNestedObject",
                "displayValue": "Create nested object"
              }
            ],
            "simpleValueType": true,
            "help": "If you want some nested key to persist in the same nested position as the source object, mark \u003cb\u003eCreate Nested Object\u003c/b\u003e, otherwise it will return a flat object.",
            "enablingConditions": [
              {
                "paramName": "outputKeys",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "defaultValue": "createFlatObject"
          }
        ],
        "help": "Limit the returning object by choosing one or more specific keys you want to extract. \u003c/br\u003e If needed to extract nested values, use dot notation. \u003c/br\u003e(e.g. \u003ci\u003efoo.id\u003c/i\u003e, \u003ci\u003ebar.0.price\u003c/i\u003e).\u003c/br\u003e If multiple keys are listed, they will be returned in a key/value JSON format.\n\u003cb\u003eSeparate the keys/paths by comma.\u003c/b\u003e"
      }
    ]
  },
  {
    "displayName": "Logs Settings",
    "name": "logsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "logType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log"
          },
          {
            "value": "debug",
            "displayValue": "Log to console during debug and preview"
          },
          {
            "value": "always",
            "displayValue": "Always log to console"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "debug"
      }
    ]
  },
  {
    "displayName": "BigQuery Logs Settings",
    "name": "bigQueryLogsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "bigQueryLogType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log to BigQuery"
          },
          {
            "value": "always",
            "displayValue": "Log to BigQuery"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "no"
      },
      {
        "type": "GROUP",
        "name": "logsBigQueryConfigGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "logBigQueryProjectId",
            "displayName": "BigQuery Project ID",
            "simpleValueType": true,
            "help": "Optional. \u003cbr\u003e\u003cbr\u003e  If omitted, it will be retrieved from the environment variable \u003cI\u003eGOOGLE_CLOUD_PROJECT\u003c/i\u003e where the server container is running. If the server container is running on Google Cloud, \u003cI\u003eGOOGLE_CLOUD_PROJECT\u003c/i\u003e will already be set to the Google Cloud project\u0027s ID."
          },
          {
            "type": "TEXT",
            "name": "logBigQueryDatasetId",
            "displayName": "BigQuery Dataset ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "TEXT",
            "name": "logBigQueryTableId",
            "displayName": "BigQuery Table ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "bigQueryLogType",
            "paramValue": "always",
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const BigQuery = require('BigQuery');
const createRegex = require('createRegex');
const encodeUriComponent = require('encodeUriComponent');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const Promise = require('Promise');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');
const templateDataStorage = require('templateDataStorage');

/*==============================================================================
==============================================================================*/

const eventData = getAllEventData();

if (shouldExitEarly(eventData)) return;

return sendRequest();

/*==============================================================================
 VENDOR RELATED FUNCTIONS
==============================================================================*/

function sendRequest() {
  const chosenApi = 'PersonLookup';
  const requestConfig = handleRequestConfig(data, chosenApi);
  const cacheKey = sha256Sync(
    'infobip' + chosenApi + requestConfig.url + data.identifier + data.apiKey || ''
  );
  const cacheKeyTimestamp = cacheKey + '_timestamp';
  const cacheExpirationTimeMillis =
    data.expirationTime && makeInteger(data.expirationTime) * 60 * 60 * 1000;
  const now = getTimestampMillis();

  if (data.storeResponse) {
    let cachedValues = templateDataStorage.getItemCopy(cacheKey);
    const cachedValueTimestamp = templateDataStorage.getItemCopy(cacheKeyTimestamp);

    if (data.expirationTime) {
      if (
        cachedValueTimestamp &&
        now - makeInteger(cachedValueTimestamp) >= cacheExpirationTimeMillis
      ) {
        cachedValues = '';
        templateDataStorage.removeItem(cacheKey);
        templateDataStorage.removeItem(cacheKeyTimestamp);
      }
    }
    if (cachedValues)
      return Promise.create((resolve) => resolve(createReturningObject(cachedValues)));
  }

  log({
    Name: 'InfobipLookup',
    Type: 'Request',
    EventName: chosenApi,
    RequestMethod: requestConfig.options.method,
    RequestUrl: requestConfig.url
  });

  return sendHttpRequest(requestConfig.url, requestConfig.options)
    .then((result) => {
      log({
        Name: 'InfobipLookup',
        Type: 'Response',
        EventName: chosenApi,
        ResponseStatusCode: result.statusCode,
        ResponseHeaders: result.headers,
        ResponseBody: result.body
      });
      const parsedBody = JSON.parse(result.body || '{}');

      if (result.statusCode === 200) {
        let objectToStore = {};
        objectToStore = parsedBody;

        if (data.storeResponse) {
          templateDataStorage.setItemCopy(cacheKey, objectToStore);
          templateDataStorage.setItemCopy(cacheKeyTimestamp, now);
        }
        return createReturningObject(objectToStore);
      } else if (result.statusCode === 404) {
        log({
          Name: 'InfobipLookup',
          Type: 'Message',
          EventName: chosenApi,
          Message: 'Request failure',
          Reason: parsedBody.errorMessage
        });
        return;
      }
      return createReturningObject(parsedBody);
    })
    .catch((result) => {
      log({
        Name: 'InfobipLookup',
        Type: 'Message',
        EventName: chosenApi,
        Message: 'Request failed or timed out.',
        Reason: JSON.stringify(result)
      });
      return;
    });
}

function createReturningObject(sourceObject) {
  let returnObject = {};

  const keysToReturn = data.outputKeys
    ? data.outputKeysList.split(',').map((s) => s.trim())
    : undefined;
  if (!keysToReturn) {
    return sourceObject;
  } else if (getType(keysToReturn) === 'array') {
    if (keysToReturn.length === 1) {
      return extractKeyFromObject(keysToReturn[0], sourceObject);
    } else if (keysToReturn.length > 1) {
      returnObject = createNestedObject(sourceObject, keysToReturn);
      return data.objectOutput === 'createFlatObject' ? flattenObject(returnObject) : returnObject;
    }
  }
}

function handleRequestConfig(data, chosenApi) {
  const apiMethodsMapping = {
    PersonLookup: personLookupHandler
  };
  const apiPath = apiMethodsMapping[chosenApi]('path');
  const apiQueries = apiMethodsMapping[chosenApi]('queries');
  const protocolRegex = createRegex('https?:\\/\\/');
  let apiBaseUrl = data.baseUrl;
  let requestConfig = {};

  apiBaseUrl = apiBaseUrl.match(protocolRegex)
    ? apiBaseUrl.replace(protocolRegex, 'https://')
    : 'https://' + apiBaseUrl;

  requestConfig = {
    url: apiBaseUrl + apiPath + apiQueries,
    options: {
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        Authorization: 'App ' + data.apiKey
      },
      method: apiMethodsMapping[chosenApi]('requestMethod')
    }
  };
  return requestConfig;
}

function personLookupHandler(method) {
  if (method === 'requestMethod') return 'GET';
  if (method === 'path') return '/people/2/persons?';
  if (method === 'queries') {
    const queriesUrl = [];
    const queries = {
      type: data.type,
      identifier: data.identifier,
      sender: data.sender
    };
    for (const key in queries) {
      if (queries[key]) queriesUrl.push(key + '=' + enc(queries[key]));
    }
    return queriesUrl.join('&');
  }
}

/*==============================================================================
  Helpers
==============================================================================*/

function shouldExitEarly(eventData) {
  const url = eventData.page_location || getRequestHeader('referer');
  if (url && url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return true;

  if (getType(data.baseUrl) !== 'string' || getType(data.apiKey) !== 'string') return true;

  if (!data.sender && !data.type.match('ID|EXTERNAL_ID|EMAIL|PHONE')) return true;
}

function enc(data) {
  if (['null', 'undefined'].indexOf(getType(data)) !== -1) data = '';
  return encodeUriComponent(makeString(data));
}

function flattenObject(ob) {
  const toReturn = {};
  for (let i in ob) {
    if (!ob.hasOwnProperty(i)) continue;
    if (['object', 'array'].indexOf(getType(ob[i])) !== -1) {
      const flatObject = flattenObject(ob[i]);
      for (let x in flatObject) {
        if (!flatObject.hasOwnProperty(x)) continue;
        toReturn[i + '_' + x] = flatObject[x];
      }
    } else {
      toReturn[i] = ob[i];
    }
  }

  return toReturn;
}

function createNestedObject(source, paths) {
  const result = {};
  paths.forEach((path) => {
    const keys = path.trim().split('.');
    let srcPtr = source;
    let resPtr = result;

    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];

      if (!srcPtr || !srcPtr[key]) return;

      const isLastKey = i === keys.length - 1;
      if (isLastKey) {
        resPtr[key] = srcPtr[key];
      } else {
        if (getType(resPtr[key]) === 'undefined') {
          resPtr[key] = getType(srcPtr[key]) === 'array' ? [] : {};
        }
        srcPtr = srcPtr[key];
        resPtr = resPtr[key];
      }
    }
  });
  return result;
}

function extractKeyFromObject(keyPath, sourceObject) {
  const keys = keyPath.split('.');
  return keys.reduce((object, key) => {
    if (sourceObject === undefined) return undefined;
    if (object.hasOwnProperty(key)) return object[key];
    return undefined;
  }, sourceObject);
}

function log(rawDataToLog) {
  const logDestinationsHandlers = {};
  if (determinateIsLoggingEnabled()) logDestinationsHandlers.console = logConsole;
  if (determinateIsLoggingEnabledForBigQuery()) logDestinationsHandlers.bigQuery = logToBigQuery;

  rawDataToLog.TraceId = getRequestHeader('trace-id');

  const keyMappings = {
    // No transformation for Console is needed.
    bigQuery: {
      Name: 'tag_name',
      Type: 'type',
      TraceId: 'trace_id',
      EventName: 'event_name',
      RequestMethod: 'request_method',
      RequestUrl: 'request_url',
      RequestBody: 'request_body',
      ResponseStatusCode: 'response_status_code',
      ResponseHeaders: 'response_headers',
      ResponseBody: 'response_body'
    }
  };

  for (const logDestination in logDestinationsHandlers) {
    const handler = logDestinationsHandlers[logDestination];
    if (!handler) continue;

    const mapping = keyMappings[logDestination];
    const dataToLog = mapping ? {} : rawDataToLog;

    if (mapping) {
      for (const key in rawDataToLog) {
        const mappedKey = mapping[key] || key;
        dataToLog[mappedKey] = rawDataToLog[key];
      }
    }

    handler(dataToLog);
  }
}

function logConsole(dataToLog) {
  logToConsole(JSON.stringify(dataToLog));
}

function logToBigQuery(dataToLog) {
  const connectionInfo = {
    projectId: data.logBigQueryProjectId,
    datasetId: data.logBigQueryDatasetId,
    tableId: data.logBigQueryTableId
  };
  dataToLog.timestamp = getTimestampMillis();

  ['request_body', 'response_headers', 'response_body'].forEach((p) => {
    dataToLog[p] = JSON.stringify(dataToLog[p]);
  });
  BigQuery.insert(connectionInfo, [dataToLog], { ignoreUnknownValues: true });
}

function determinateIsLoggingEnabled() {
  const containerVersion = getContainerVersion();
  const isDebug = !!(
    containerVersion &&
    (containerVersion.debugMode || containerVersion.previewMode)
  );

  if (!data.logType) {
    return isDebug;
  }

  if (data.logType === 'no') {
    return false;
  }

  if (data.logType === 'debug') {
    return isDebug;
  }

  return data.logType === 'always';
}

function determinateIsLoggingEnabledForBigQuery() {
  if (data.bigQueryLogType === 'no') return false;
  return data.bigQueryLogType === 'always';
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://*.api.infobip.com/*"
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
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
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
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_bigquery",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedTables",
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
                    "string": "datasetId"
                  },
                  {
                    "type": 1,
                    "string": "tableId"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
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
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
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
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
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
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 01/08/2026
}


