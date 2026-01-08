# Infobip CDP Lookup Variable for GTM Server-Side

This Google Tag Manager Server-Side variable allows you to retrieve contact information using the Infobip API.

## Features

* **Multiple Identifiers**: Lookup profiles by ID, External ID, Email, Phone, Facebook, Telegram, and many others.
* **Built-in Caching**: Stores API responses in Template Storage to reduce API calls and latency (configurable expiration).
* **Flexible Output**: Extract specific keys or return the full object. Supports flattening nested JSON responses.
* **BigQuery Logging**: Native support for logging request and response data to BigQuery.

## Configuration

### 1. API Configuration

* **Base URL**: Your Infobip Base URL (e.g., `xxxxx.api.infobip.com`). Do not include `https://`.
* **API Key**: Your Infobip API Key found in the Developer Dashboard.

### 2. Lookup Parameters

* **Identifier Type**: Select the type of identifier to use for the lookup (e.g., Email, Phone, External ID, etc.).
* **Identifier Value**: The actual value to search for.
* **Sender**: The Sender or Application ID. Required for specific types (not required for ID, External ID, Phone, or Email).

### 3. Cache Settings

* **Store response in cache**: If enabled, saves the API response to Template Storage.
* **Cache Expiration Time**: Time in hours before the cache invalidates (default: 12).

### 4. Output Settings

* **Extract keys**: Option to limit the returned object to specific keys (supports dot notation).
* **Output object structure**: Choose between creating a **Flat object** (underscore separated) or a **Nested object**.

### 5. Logging

* **Logs Settings**: Controls console logging (No, Debug, or Always).
* **BigQuery Logs**: Enable to stream event data to a BigQuery table.
* **Project ID**: Google Cloud Project ID (defaults to environment variable if empty).
* **Dataset ID**: Target Dataset.
* **Table ID**: Target Table.



## Permissions

This template requires the following permissions:

* **Send HTTP Requests**: Grants access to `https://*.api.infobip.com/*`.
* **Access Template Storage**: Required for caching functionality.
* **Access BigQuery**: Required if BigQuery logging is enabled.
* **Access Global Variables**: Reads event data and container context.

## Open Source

The **Infobip Lookup Variable by Stape** is developed and maintained by the [Stape Team](https://stape.io/) under the Apache 2.0 license.
