---
title: Endpoints & Engines
shortTitle: Endpoints
metaDescription: Configure testing endpoints, test engines, and run your own Orb servers.
section: Deploy & Configure
---

# Endpoints & Engines

:::danger
These features are experimental, and not yet intended for production environments. We appreciate your testing and feedback. Please use our [Help & Support](https://orb.net/support) page or [Discord](https://discord.gg/orbforge) to report issues and ask questions.
:::

## Orb Server

Every Orb Sensor runs a built-in server component (as of version 1.5), allowing you to perform responsiveness and speed testing directly to that Orb. This can be useful for:

* Testing a leg of your local network rather than to internet infrastructure to troubleshoot where a bottleneck is occurring, test your Wi-Fi in isolation, or test a multi-gigabit switch or router.
* ISPs wishing to test servers within their network infrastructure in addition to internet infrastructure.
* Organizations in highly-regulated or industrial environments that can only test to infrastructure they control.

The server listens on port `7443` by default. If you wish to use a different port, set the `ORB_MEASURE_SERVER_PORT` environment variable (e.g. `ORB_MEASURE_SERVER_PORT=8080`). See the [Configuration](/docs/deploy-and-configure/configuration) documentation for more details.

If you need to disable the server, set the environment variable `ORB_MEASURE_SERVER_ENABLED=0`, or push the following via the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) configuration sections under the "Advanced" tab:

```json
"sensor_api.measure_server_enabled": ["false"]
```

For testing purposes, you can explicitly run `orb server` to run a standalone server-only mode.

### Testing to your Orb Server

To configure an Orb to test against another Orb's built-in server, visit the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

Add the following to your configuration, replacing `<ip>` with the routable IP address of the Orb Server. This single key automatically configures both Responsiveness and Speed testing to point at your server:

```json
"orb.endpoint": ["<ip>:7443"]
```

If you configured a different port via `ORB_MEASURE_SERVER_PORT`, update the port accordingly.

You can optionally assign a display name to the endpoint using `orb.endpoint_name`. This requires `orb.endpoint` to be set:

```json
"orb.endpoint_name": ["My Local Server"]
```

## Speed Test Engine

As of version 1.5, Orb uses the "wave" engine by default for Peak Speed tests against Cloudflare infrastructure. The "wave" engine achieves higher throughput in a shorter duration compared to the legacy "orb" engine and many other legacy speed test tools.

You can customize which speed servers are used by visiting the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

### Custom test with "wave"

To configure speed testing with the "wave" engine:

```json
"collectors.bandwidth.speed_servers": [
  "wave://<host or ip>"
]
```

## Experimental Fastly speed test

In addition to our existing collaboration with Cloudflare, Orb now partners with Fastly as well to support responsiveness, reliability, and speed testing. By supporting both Cloudflare and Fastly to measure internet experience, Orb provides an unparalleled platform for measuring real-world application experience. Orb already supports measuring responsiveness and reliability to Fastly. We are looking to our community and partners to test a new Fastly-powered speed test before making it more widely available and seamlessly integrated.

To configure Orbs to perform speed tests to Fastly infrastructure, visit the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

```json
"collectors.bandwidth.speed_servers": [
  "wave://fastly-measure.prod.orb.net"
]
```

When multiple speed servers are configured, Orb chooses among them according to `collectors.bandwidth.server_selection_method`:

- **`best`**: Pings each candidate and selects the closest server by network path (lowest latency)
- **`round_robin`**: Cycles through servers in order
- **`random`**: Randomly selects a server for each test
- Default (if not specified): `best`

For example, to test against both Cloudflare and Fastly and let Orb pick the nearest:

```json
"collectors.bandwidth.speed_servers": [
  "wave://speed.cloudflare.com",
  "wave://fastly-measure.prod.orb.net"
]
```

Or to randomly distribute tests between them instead:

```json
"collectors.bandwidth.speed_servers": [
  "wave://speed.cloudflare.com",
  "wave://fastly-measure.prod.orb.net"
],
"collectors.bandwidth.server_selection_method": [
  "random"
]
```

:::warning
This features is experimental, and not yet intended for production environments. We appreciate your testing and feedback. Please use our [Help & Support](https://orb.net/support) page or [Discord](https://discord.gg/orbforge) to report issues and ask questions.
:::

## Custom Responsiveness Endpoints

Orb measures network responsiveness by conducting latency measurements to various internet endpoints. Orb can be configured to use alternative endpoints should you wish to:

* Configure some Orbs to measure your local network or Wi-Fi exclusively.
* Comply with InfoSec policies for highly-regulated or industrial environments.
* Measure point-to-point experience.
* Monitor connectivity to datacenters, clouds, or internet exchanges you utilize.

:::warning
This features is experimental, and not yet intended for production environments. We appreciate your testing and feedback. Please use our [Help & Support](https://orb.net/support) page or [Discord](https://discord.gg/orbforge) to report issues and ask questions.
:::

### Configuration Format

Endpoints are specified as a list of endpoint URLs using the format `protocol://host:port`. Supported protocols are:

- **`icmp`**: ICMP ping tests (e.g., `icmp://<host or ip>`)
- **`https`**: HTTPS connection tests (e.g., `https://<host or ip>:443`)
- **`h3`**: HTTP/3 connection tests (e.g., `h3://<host or ip>`)

If no port is specified, the default port for the protocol will be used. HTTPS tests do not include packet loss.

### Configuration

To configure custom responsiveness endpoints, visit the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

Modify the below example as desired, and add to your configuration:

```json
{
  "collectors.response.lag_endpoints": [
    "icmp://<host or ip>",
    "https://<host or ip>",
    "h3://<host or ip>"
  ]
}
```

You may specify Orb Servers as endpoints. Responsiveness data is included in [Responsiveness Datasets](/docs/deploy-and-configure/datasets#responsiveness) and Orb Cloud Analytics.

## Custom Web Responsiveness Endpoints

Once per minute, the default Orb configuration conducts Web Responsiveness tests to Orb infrastructure partners. This allows you to view Time to First Byte (TTFB) and DNS Resolution Time metrics in the Orb apps, Orb Cloud Analytics, and Orb Local Analytics. You can optionally specify custom web endpoints and testing parameters should you want to periodically test web endpoints that are critical to you or your users. The following configuration options are available:

- **`collectors.bandwidth.web_urls`**: List of HTTPS URLs to test
- **`collectors.bandwidth.web_interval`**: Interval between tests
- **`collectors.bandwidth.web_timeout`**: Timeout for individual tests
- **`collectors.bandwidth.web_selection_method`**: Method for choosing which URL to test

### Configuration Parameters

**Web URLs (`web_urls`)**
- Specify a list of HTTPS URLs for DNS resolution and TTFB testing

**Test Interval (`web_interval`)**
- Controls how frequently web responsiveness tests are performed
- Minimum value: `5s` (5 seconds)
- Default value: `1m` (1 minute) 
- Format: Duration string (e.g., `10s`, `1m`, `30s`)

**Test Timeout (`web_timeout`)**
- Maximum time to wait for a test to complete before considering it failed
- Minimum value: `100ms` (100 milliseconds)
- Maximum value: `20s` (20 seconds)
- Default value: `20s`(20 seconds)
- Must be less than the web_interval value
- Format: Duration string (e.g., `5s`, `2s`, `500ms`)

**Selection Method (`web_selection_method`)**
- **`round_robin`**: Cycles through URLs in order
- **`random`**: Randomly selects a URL for each test
- Default (if not specified): `round_robin`

### Configuration

To configure custom web responsiveness endpoints, visit the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

Modify the below example as desired, and add to your configuration:

```json
{
  "collectors.bandwidth.web_urls": [
    "https://www.orb.net",
    "https://orb.horse"
  ],
  "collectors.bandwidth.web_interval": [
    "1m"
  ],
  "collectors.bandwidth.web_timeout": [
    "20s"
  ],
  "collectors.bandwidth.web_selection_method": [
    "round_robin"
  ]
}
```

Web responsiveness data is included in [Web Responsiveness Datasets](/docs/deploy-and-configure/datasets#web-responsiveness) and Orb Cloud Analytics.