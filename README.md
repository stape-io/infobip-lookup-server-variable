# Infobip CDP Lookup Variable for GTM Server-Side

This Google Tag Manager Server-Side variable allows you to retrieve a single contact profile information given an identifier from Infobip People CDP using the Infobip People CDP API.

## Features

- **Multiple Identifiers**: Lookup profiles by ID, External ID, Email, Phone, Facebook, Telegram, and many others.
- **Built-in Caching**: Stores API responses in Template Storage to reduce API calls and latency (configurable expiration).
- **Flexible Output**: Extract specific keys or return the full object. Supports flattening nested JSON responses.
- **BigQuery Logging**: Native support for logging request and response data to BigQuery.

## Configuration

### 1. API Configuration

- **Base URL**: Your Infobip Base URL (e.g., `xxxxx.api.infobip.com`) found in the [Developer Tools > API Keys](https://portal.infobip.com/dev/api-keys) page Do not include `https://`.
- **API Key**: Your Infobip API Key found in the [Developer Tools > API Keys](https://portal.infobip.com/dev/api-keys) page.
  - **Scopes**: at least one of the following scopes `people:manage` and `people:read`

### 2. Lookup Parameters

- **Identifier Type**: Select the type of identifier to use for the lookup (e.g., Email, Phone, External ID, etc.).
- **Identifier Value**: The actual value to search for.
- **Sender**: The Sender or Application ID. Required for specific types (not required for ID, External ID, Phone, or Email).

### 3. Cache Settings

- **Store response in cache**: If enabled, saves the API response to Template Storage.
- **Cache Expiration Time**: Time in hours before the cache invalidates (default: 12).

### 4. Output Settings

- **Extract keys**: Option to limit the returned object to specific keys (supports dot notation).
- **Output object structure**: Choose between creating a **Flat object** (underscore separated) or a **Nested object**.

## Open Source

The **Infobip CDP Lookup Variable by Stape** is developed and maintained by the [Stape Team](https://stape.io/) under the Apache 2.0 license.
