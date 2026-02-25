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

Orb can be run with an experimental server component, allowing you to perform responsiveness and speed testing directly to that Orb. This can be useful for:

* Testing a leg of your local network rather than to internet infrastructure to troubleshoot where a bottleneck is occurring, test your Wi-Fi in isolation, or test a multi-gigabit switch or router.
* ISPs wishing to test servers within their network infrastructure in addition to internet infrastructure.
* Organizations in highly-regulated or industrial environments that can only test to infrastructure they control.

The server component can be activated on an Orb Sensor by setting the environment variable `ORB_MEASURE_SERVER_ENABLED` to a value of `1` on Orb 1.4.10 and above.

If you wish to set an alternative port, the variable `ORB_MEASURE_SERVER_PORT` can be utilized (e.g. `ORB_MEASURE_SERVER_PORT=8080`). See the [Configuration](/docs/deploy-and-configure/configuration) documentation for more details.

For testing purposes, you can explicitly run `orb server` to run a standalone server-only mode. Or you can manually activate the server in a manual run of the sensor: `ORB_MEASURE_SERVER_ENABLED=1 orb sensor`.

:::warning
In Orb 1.4.10, there is no message in the startup logs indicating the server component is active.
:::

### Testing to your Orb Server

Now that you have an Orb configured to act as a server, you will need to configure a different Orb to utilize this server for testing.

Visit the Orb Cloud [Status](https://cloud.orb.net/status) or [Orchestration](https://cloud.orb.net/orchestration) sections to edit the configuration for an individual Orb, or in-bulk via *Configurations*, respectively. If this is your first time configuring an Orb remotely, see the [Remote Configuration documentation](/docs/deploy-and-configure/configuration#remote-configuration).

Changes will be made under the "Advanced" tab in the "Edit Configuration" screen.

#### Responsiveness

Add the following to your configuration to test Responsiveness to the previously configured server, replacing the `<ip>` placeholder with the routable IP address of the Orb Server:

```json
"collectors.response.lag_endpoints": [
  "h3://<ip>:7443"
],
```

#### Speed

Add the following to your configuration to test Content Speed and Peak Speed to the previously configured server, replacing the `<ip>` placeholder with the routable IP address of the Orb Server:

```json
"collectors.bandwidth.speed_servers": [
  "orb://<ip>:7443"
]
```

#### Experimental Speed Test Engine

Members of of the Orb community and Orb customers have requested that the "Peak Speed" test, which measures the maximum download and upload throughput a connection can achieve, deliver results more in-line with the tools they've utilized in the past so they can fully switch to Orb from legacy speed test tools.

Orb now offers an experimental "wave" engine, which can achieve higher throughput in a shorter duration when compared to the "orb" engine and many other legacy speed test tools.

Add the following to your configuration to test Content Speed and Peak Speed to the previously configured server, replacing the `<ip>` placeholder with the routable IP address of the Orb Server:

```json
"collectors.bandwidth.speed_servers": [
  "wave://<ip>:7443"
]
```

There is no configuration step needed for the "server" Orb.

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