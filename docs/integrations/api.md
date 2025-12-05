---
title: Orb Cloud API
shortTitle: API
metaDescription: Build custom integrations with the Orb Cloud REST API.
section: Integrations
layout: guides
subtitle: 'Difficulty: Advanced 🧑‍💻'
---

# Orb Cloud API

The Orb Cloud API allows you to access Orb details, stream real-time data, and trigger speed tests via API for use in your customer-facing or back of house apps. 

:::info
API access requires an [Orb Cloud Business](https://orb.net/plans/business) or [Enterprise](https://orb.net/plans/enterprise) plan. A Business plan is available with a **14-day free trial**. For special considerations or questions about API access entitlements, please [contact the Orb team](https://orb.net/contact).
:::

## Features

- **Device Management**: Retrieve information about all Orb devices in your organization
- **Real-time Data Streaming**: Stream live connectivity metrics from your devices
- **Temporary Dataset Configuration**: Configure custom data collection with webhook endpoints
- **Organization Access**: Query devices across your organization hierarchy

## API Reference

The full API specification is available at:

**[https://panel.orb.net/api/v1/docs](https://panel.orb.net/api/v1/docs)**

## Authentication

The Orb Cloud API uses Bearer token authentication. You'll need to create an API key from the Orb Cloud dashboard.

### Creating an API Key

1. Log into [Orb Cloud](https://cloud.orb.net/)
2. Navigate to the **Orchestration** tab

![Orb Cloud Orchestration Tab](../../images/integrations/hamina-orchestration.png)

3. In the **API Keys** section, click the **New API Key** button.
4. In the **Create API Key** window:
   - Give the API key a name of your choosing
   - Select the appropriate permissions based on your use case:
     - **Organizations**: Read access to list and query organizations
     - **Devices**: Read access to list devices, Stream access for real-time data
     - **Datasets**: Write access to configure temporary data collection
5. Click the **Create** button.
6. In the **API Keys** section, the new key will appear. Click on it to copy it to the clipboard.

### Using the API Key

Include your API key in the `Authorization` header of all requests:

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://panel.orb.net/api/v1/organizations
```

## Python Client Library

For Python developers, we provide an official client library that simplifies API integration.

### Installation

```bash
pip install orb-cloud-client
```

**Requirements:**
- Python 3.8 or higher
- httpx >= 0.24.0
- pydantic >= 2.0.0

### Quick Start

```python
from orb_cloud_client import OrbCloudClient

# Initialize the client
client = OrbCloudClient(
    base_url="https://panel.orb.net",
    token="YOUR_API_KEY"
)

# Get all devices in an organization
devices = client.get_organization_devices(organization_id="your-org-id")

for device in devices:
    print(f"Device: {device.name}")
    print(f"  ID: {device.id}")
    print(f"  Connected: {device.connection_status}")

# Close the client when done
client.close()
```

### Available Methods

The `OrbCloudClient` class provides these methods:

| Method | Description |
|--------|-------------|
| `get_organization_devices(organization_id)` | Retrieve all devices for an organization |
| `configure_temporary_datasets(device_id, temp_datasets_request)` | Configure temporary data collection with custom endpoints |
| `request(method, endpoint, **kwargs)` | Make custom HTTP requests to the API |
| `close()` | Close the HTTP client connection |

### Data Models

The library uses Pydantic models for type-safe data handling:

- **Device**: Represents an Orb device with properties like `id`, `name`, `connection_status`, geo-IP info, and network details
- **TempDatasetsRequest**: Configuration for temporary data collection
- **Datasets**: Data collection settings with push configuration
- **DataPush**: External webhook endpoint configuration
- **GeoIPInfo**: Geographic location information from IP address
- **DeviceInfo**: Hardware and software specifications
- **NetworkInterface**: Network adapter details

### Available Datasets

When configuring data collection, these dataset types are available:

- `responsiveness_{timeframe}` (e.g., `responsiveness_1s`, `responsiveness_1m`)
- `scores_{timeframe}` (e.g., `scores_1m`, `scores_5m`)
- `speed_results`
- `web_responsiveness_results`

### Error Handling

The client raises standard httpx exceptions:

```python
from httpx import HTTPStatusError, RequestError, TimeoutException

try:
    devices = client.get_organization_devices(org_id)
except HTTPStatusError as e:
    print(f"HTTP error: {e.response.status_code}")
except RequestError as e:
    print(f"Request failed: {e}")
except TimeoutException:
    print("Request timed out")
```

### More Information

- **PyPI Package**: [orb-cloud-client](https://pypi.org/project/orb-cloud-client/)

## Example: Webhook Integration

Configure an Orb device to push data to your own endpoint:

```python
from orb_cloud_client import (
    OrbCloudClient,
    TempDatasetsRequest,
    Datasets,
    DataPush
)

client = OrbCloudClient(token="YOUR_API_KEY")

# Configure temporary data collection with webhook
config = TempDatasetsRequest(
    datasets=Datasets(
        responsiveness_1s=DataPush(
            url="https://your-server.com/webhook/orb-data",
            headers={"X-Custom-Header": "value"}
        )
    ),
    duration_seconds=3600  # Collect for 1 hour
)

client.configure_temporary_datasets(
    device_id="your-device-id",
    temp_datasets_request=config
)

client.close()
```

## Rate Limits

API requests are subject to rate limiting. If you exceed the limits, you'll receive a `429 Too Many Requests` response. Implement exponential backoff in your applications to handle rate limiting gracefully.

## Support

For help with the Orb Cloud API:

- **API Reference**: [panel.orb.net/api/v1/docs](https://panel.orb.net/api/v1/docs)
- **Discord Community**: [discord.gg/orbforge](https://discord.gg/orbforge)
- **Contact**: [orb.net/contact](https://orb.net/contact)
