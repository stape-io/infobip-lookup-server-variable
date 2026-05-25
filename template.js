const encodeUriComponent = require('encodeUriComponent');
const getAllEventData = require('getAllEventData');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
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
  const cacheKey = sha256Sync('infobip' + chosenApi + requestConfig.url + data.apiKey);
  const cacheKeyTimestamp = cacheKey + '_timestamp';
  const cacheExpirationTimeMillis = makeInteger(data.expirationTime || 12) * 60 * 60 * 1000;
  const now = getTimestampMillis();

  if (data.storeResponse) {
    const cachedValues = templateDataStorage.getItemCopy(cacheKey);
    const cachedValueTimestamp = templateDataStorage.getItemCopy(cacheKeyTimestamp);

    if (
      cachedValueTimestamp &&
      now - makeInteger(cachedValueTimestamp) >= cacheExpirationTimeMillis
    ) {
      templateDataStorage.removeItem(cacheKey);
      templateDataStorage.removeItem(cacheKeyTimestamp);
    } else if (cachedValues) {
      return Promise.create((resolve) => resolve(createReturningObject(cachedValues)));
    }
  }

  return sendHttpRequest(requestConfig.url, requestConfig.options)
    .then((result) => {
      if (result.statusCode === 200) {
        const parsedBody = JSON.parse(result.body || '{}');
        if (data.storeResponse) {
          templateDataStorage.setItemCopy(cacheKey, parsedBody);
          templateDataStorage.setItemCopy(cacheKeyTimestamp, now);
        }
        return createReturningObject(parsedBody);
      } else {
        return;
      }
    })
    .catch((result) => {
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
  const apiBaseUrl = 'https://' + data.baseUrl.replace('https://', '').replace('http://', '');
  const requestConfig = {
    url: apiBaseUrl + apiPath + apiQueries,
    options: {
      headers: {
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
    for (const key in queries) {
      if (queries[key]) queriesUrl.push(enc(key) + '=' + enc(queries[key]));
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
