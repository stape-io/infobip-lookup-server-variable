const BigQuery = require('BigQuery');
const createRegex = require('createRegex');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeTableMap = require('makeTableMap');
const Object = require('Object');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');
const Promise = require('Promise');
const templateDataStorage = require('templateDataStorage');
const makeInteger = require('makeInteger');
const encodeUriComponent = require('encodeUriComponent');

/*==============================================================================
  MAIN EXECUTION
==============================================================================*/

const eventData = getAllEventData();
const chosenApi = 'PersonLookup';
const apiMethodsMapping = {
  PersonLookup: personLookupHandler
};
const requestConfig = handleRequestConfig(data);

if (shouldExitEarly(eventData)) return;

return sendRequest(requestConfig);

/*==============================================================================
 VENDOR RELATED FUNCTIONS
==============================================================================*/

function sendRequest(requestConfig) {
  const cacheKey = sha256Sync('infobip' + chosenApi + requestConfig.url + data.identifier + data.apiKey || '');
  const cacheKeyTimestamp = cacheKey + '_timestamp';
  const cacheExpirationTimeMillis = data.expirationTime && makeInteger(data.expirationTime) * 60 * 60 * 1000;
  const now = getTimestampMillis();

  if (data.storeResponse) {
    let cachedValues = templateDataStorage.getItemCopy(cacheKey);
    const cachedValueTimestamp = templateDataStorage.getItemCopy(cacheKeyTimestamp);

    if (data.expirationTime) {
      if (cachedValueTimestamp && now - makeInteger(cachedValueTimestamp) >= cacheExpirationTimeMillis) {
        cachedValues = '';
        templateDataStorage.removeItem(cacheKey);
        templateDataStorage.removeItem(cacheKeyTimestamp);
      }
    }
    if (cachedValues) return Promise.create((resolve) => resolve(createReturningObject(cachedValues)));
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

  const keysToReturn = data.outputKeys ? data.outputKeysList.split(',').map((s) => s.trim()) : undefined;
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

function handleRequestConfig(data) {
  const protocolRegex = createRegex('https?:\\/\\/');
  let apiBaseUrl = data.baseUrl.replace(protocolRegex, '');
  const apiPath = apiMethodsMapping[chosenApi]('path');
  const apiQueries = apiMethodsMapping[chosenApi]('queries');
  const requestConfig = {
    url: 'https://' + apiBaseUrl + apiPath + apiQueries,
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
  if (method === 'path') return '/people/2/persons';
  if (method === 'queries') {
    const queriesUrl = [];
    const queries = {
      type: data.type,
      identifier: data.identifier,
      sender: data.sender
    };
    for (let key in queries) {
      if (queries[key]) queriesUrl.push(key + '=' + encodeUriComponent(queries[key]));
    }
    return '?' + queriesUrl.join('&');
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

function mergeObjects() {
  const objectToReturn = {};
  if (getType(arguments) === 'array' && arguments.length) {
    arguments.forEach((object) => {
      if (getType(object) === 'object') {
        for (let key in object) {
          objectToReturn[key] = object[key];
        }
      }
    });
  }
  return objectToReturn;
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
  const isDebug = !!(containerVersion && (containerVersion.debugMode || containerVersion.previewMode));

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
