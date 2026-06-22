---
title: Orb Datasets
shortTitle: Datasets
metaDescription: Reference documentation for Orb dataset schemas including Scores, Responsiveness, and Speed data.
section: Deploy & Configure
---

# Orb Datasets

Orb applications and sensors are capable of producing **Datasets** for Scores, Responsiveness, Web Responsiveness, Speed, and Wi-Fi data. These datasets may be streamed to Orb Cloud, Orb Local Analytics, or a destination of your choice. This document describes the available datasets and their schemas. For details on configuring Orb to send Datasets to your desired backend, see [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration).

## Current Version

The current version of Orb Datasets is 1.5

:::info
Orb Datasets requires Orb app and sensor versions 1.3 and above.
:::

## Scores

The Scores Dataset focuses on Orb Score, its component scores (Responsiveness, Reliability, and Speed), and underlying measures used in these scores. For more details see [Orb Scores & Metrics](/docs/orb-app/orb-scores-metrics).

Scores data is available in 30 minute, 1 minute, and 1 second aggregated buckets.

### `scores_(30m|1m|1s)`

| column                 | description                                                                                                                                                                               |  type   |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
| **identifiers**        |                                                                                                                                                                                           |         |
| `orb_id`               | Orb Sensor identifier                                                                                                                                                                     | string  |
| `orb_name`             | Current Orb friendly name (masked unless identifiable=true)                                                                                                                               | string  |
| `device_name`          | Hostname or name of the device as identified by the OS (masked unless identifiable=true)                                                                                                  | string  |
| `timestamp`            | Interval start timestamp in epoch milliseconds                                                                                                                                            | integer |
| `interval_ms`          | Length of the aggregation window in milliseconds                                                                                                                                                  | integer |
| `score_version`        | Semantic version of scoring methodology                                                                                                                                                   | string  |
| `orb_version`          | Semantic version of collecting Orb                                                                                                                                                        | string  |
| `dataset`              | Dataset type identifier                                                                                                                                                                   | string  |
| **measures**           |                                                                                                                                                                                           |         |
| `orb_score`            | Orb Score over interval (0-100)                                                                                                                                                           |  float  |
| `responsiveness_score` | Responsiveness Score over interval (0-100)                                                                                                                                                |  float  |
| `reliability_score`    | Reliability Score over interval (0-100)                                                                                                                                                   |  float  |
| `speed_score`          | Speed (Bandwidth) Score over interval (0-100)                                                                                                                                             |  float  |
| `speed_age_ms`         | Age of speed used in milliseconds, if not in timeframe. If in timeframe, 0.                                                                                                               | integer |
| `lag_avg_us`           | Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive", avg if interval)                                                                                       |  float  |
| `download_avg_kbps`    | Content download speed in Kbps                                                                                                                                                            | integer |
| `upload_avg_kbps`      | Content upload speed in Kbps                                                                                                                                                              | integer |
| `unresponsive_ms`      | Time spent in unresponsive state in Milliseconds                                                                                                                                          | integer |
| `measured_ms`          | Time spent actively measuring in Milliseconds                                                                                                                                             | integer |
| `lag_count`            | Count of Lag samples included                                                                                                                                                             | integer |
| `speed_count`          | Count of speed samples included                                                                                                                                                           | integer |
| **dimensions**         |                                                                                                                                                                                           |         |
| `bssid`                | Access point MAC address (masked unless identifiable=true)                                                                                                                                | string  |
| `mac_address`          | Client MAC address (masked unless identifiable=true)                                                                                                                                      | string  |
| `network_name`         | Network name (SSID, if available, masked unless identifiable=true)                                                                                                                        | string  |
| `network_type`         | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`<br>`4: cellular`                                                                                       | integer |
| `network_state`        | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`         | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `state`                | Geocoded state or province name                                                                                                                                                           | string  |
| `city`                 | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`             | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`            | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `private_ip`           | Local IP address (masked unless identifiable=true)                                                                                                                                        | string  |
| `latitude`             | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`            | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source`      | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |
| `measure_endpoint`     | Measurement endpoint URL or IP address (only included when configured for Orb-to-Orb testing)                                                                                           | string  |
| `measure_endpoint_name` | Human-readable name of the measurement endpoint (only included when configured for Orb-to-Orb testing)                                                                                | string  |

## Responsiveness

The Responsiveness Dataset includes all measures related to network responsiveness, including lag, latency, jitter, and packet loss.

Responsiveness data is available in 30 minute, 1 minute, and 1 second aggregated buckets.

### `responsiveness_(30m|1m|1s)`

| column | description | type |
| ----- | ----- | :---: |
| **identifiers** |  |  |
| `orb_id` | Orb Sensor identifier | string |
| `orb_name` | Current Orb friendly name (masked unless identifiable=true) | string |
| `device_name` | Hostname or name of the device as identified by the OS (masked unless identifiable=true) | string |
| `orb_version` | Semantic version of collecting Orb | string |
| `timestamp` | Timestamp in epoch milliseconds | integer |
| `interval_ms` | Length of the aggregation window in milliseconds | integer |
| `dataset` | Dataset type identifier | string |
| **measures** |  |  |
| `lag_avg_us` | Avg Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive") | integer |
| `latency_avg_us` | Avg round trip latency in microseconds for successful round trip | integer |
| `jitter_avg_us` | Avg Interpacket interarrival difference (jitter) in microseconds | integer |
| `latency_count` | Count of round trip latency measurements that succeeded | integer |
| `latency_lost_count` | Count of round trip latency measurements that were lost | integer |
| `packet_loss_pct` | latency_lost_count / (latency_count+latency_lost_count) * 100 | float |
| `lag_count` | Lag sample count | integer |
| `router_lag_avg_us` | Avg Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive") | integer |
| `router_latency_avg_us` | Avg round trip latency in microseconds for successful round trip | integer |
| `router_jitter_avg_us` | Avg Interpacket interarrival difference (jitter) in microseconds | integer |
| `router_latency_count` | Count of round trip latency measurements that succeeded | integer |
| `router_latency_lost_count` | Count of round trip latency measurements that were lost | integer |
| `router_packet_loss_pct` | router_latency_lost_count / (router_latency_count+router_latency_lost_count) * 100 | float |
| `router_lag_count` | Lag sample count | integer |
| **dimensions** |  |  |
| `bssid` | Access point MAC address (masked unless identifiable=true) | string |
| `mac_address` | Client MAC address (masked unless identifiable=true) | string |
| `network_name` | Network name (SSID, if available, masked unless identifiable=true) | string |
| `network_type` | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`<br>`4: cellular` | integer |
| `network_state` | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code` | Geocoded 2-digit ISO country code | string |
| `state` | Geocoded state or province name | string |
| `city` | Geocoded city name | string |
| `isp_name` | ISP name from GeoIP lookup | string |
| `public_ip` | Public IP address (masked unless identifiable=true) | string |
| `private_ip` | Local IP address (masked unless identifiable=true) | string |
| `latitude` | Orb location latitude (max 2-decimals,unless identifiable=true) | float |
| `longitude` | Orb location longitude (max 2-decimals,unless identifiable=true) | float |
| `location_source` | Location Source<br>`0: unknown`<br>`1: geoip` | integer |
| `measure_endpoint` | Measurement endpoint URL or IP address (only included when configured for Orb-to-Orb testing) | string |
| `measure_endpoint_name` | Human-readable name of the measurement endpoint (only included when configured for Orb-to-Orb testing) | string |
| `pingers` | List (CSV) of {protocol}|{endpoint}|{ipversion} strings of all active pingers (measurers) | string |

## Web Responsiveness

The Web Responsiveness Dataset includes Orb's measures of web responsiveness: Time to First Byte (TTFB) for web page load, and DNS resolver response time. These measurements are indicative of the device or network's overall web browsing experience health.

Web Responsiveness measurements are conducted once per minute by default. Therefore, raw results are provided rather than time-bucketed aggregates.

### `web_responsiveness_results`

| column            | description                                                                                                                                                                               |  type   |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
| **identifiers**   |                                                                                                                                                                                           |         |
| `orb_id`          | Orb Sensor identifier                                                                                                                                                                     | string  |
| `orb_name`        | Current Orb friendly name (masked unless identifiable=true)                                                                                                                               | string  |
| `device_name`     | Hostname or name of the device as identified by the OS (masked unless identifiable=true)                                                                                                  | string  |
| `orb_version`     | Semantic version of collecting Orb                                                                                                                                                        | string  |
| `timestamp`       | Timestamp in epoch milliseconds                                                                                                                                                           | integer |
| `interval_ms`     | Length of the aggregation window in milliseconds                                                                                                                                                  | integer |
| `dataset`         | Dataset type identifier                                                                                                                                                                   | string  |
| **measures**      |                                                                                                                                                                                           |         |
| `ttfb_us`         | Time to First Byte loading a web page in microseconds (MAX 5000000 at which point considered “unresponsive”)                                                                              | integer |
| `dns_us`          | DNS resolver response time in microseconds (MAX 5000000 at which point the lag considered “unresponsive”)                                                                                 | integer || `sample_count`    | Number of samples aggregated into this record                                                                                                                                             | integer || **dimensions**    |                                                                                                                                                                                           |         |
| `bssid` | Access point MAC address (masked unless identifiable=true) | string |
| `mac_address` | Client MAC address (masked unless identifiable=true) | string |
| `network_name`    | Network name (SSID, if available, masked unless identifiable=true)                                                                                                                        | string  |
| `network_type`    | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`<br>`4: cellular`                                                                                       | integer |
| `network_state`   | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`    | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `state`           | Geocoded state or province name                                                                                                                                                           | string  |
| `city`            | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`        | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`       | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `private_ip` | Local IP address (masked unless identifiable=true) | string |
| `latitude`        | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`       | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source` | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |
| `measure_endpoint` | Measurement endpoint URL or IP address (only included when configured for Orb-to-Orb testing)                                                                                          | string  |
| `measure_endpoint_name` | Human-readable name of the measurement endpoint (only included when configured for Orb-to-Orb testing)                                                                           | string  |
| `web_url`         | URL endpoint for web test                                                                                                                                                                 | string  |

## Speed

The Speed Dataset includes the results of Orb's [speed tests](/docs/orb-app/speed).

Content speed measurements are conducted once per hour by default. Therefore, raw results are provided rather than time-bucketed aggregates.

### `speed_results`

| column              | description                                                                                                                                                                               |  type   |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
| **identifiers**     |                                                                                                                                                                                           |         |
| `orb_id`            | Orb Sensor identifier                                                                                                                                                                     | string  |
| `orb_name`          | Current Orb friendly name (masked unless identifiable=true)                                                                                                                               | string  |
| `device_name`       | Hostname or name of the device as identified by the OS (masked unless identifiable=true)                                                                                                  | string  |
| `orb_version`       | Semantic version of collecting Orb                                                                                                                                                        | string  |
| `timestamp`         | Timestamp in epoch milliseconds                                                                                                                                                           | integer |
| `interval_ms`       | Length of the aggregation window in milliseconds                                                                                                                                                  | integer |
| `dataset`           | Dataset type identifier                                                                                                                                                                   | string  |
| **measures**        |                                                                                                                                                                                           |         |
| `download_kbps`     | Download speed in Kbps                                                                                                                                                                    | integer |
| `download_count`    | Number of download samples                                                                                                                                                                | integer |
| `download_status`   | Download test result status<br>`0: unknown`<br>`1: success`<br>`2: fail`                                                                                                                  | integer |
| `upload_kbps`       | Upload speed in Kbps                                                                                                                                                                      | integer |
| `upload_count`      | Number of upload samples                                                                                                                                                                  | integer |
| `upload_status`     | Upload test result status<br>`0: unknown`<br>`1: success`<br>`2: fail`                                                                                                                    | integer |
| **dimensions**      |                                                                                                                                                                                           |         |
| `bssid` | Access point MAC address (masked unless identifiable=true) | string |
| `mac_address` | Client MAC address (masked unless identifiable=true) | string |
| `network_name`      | Network name (SSID, if available, masked unless identifiable=true)                                                                                                                        | string  |
| `network_type`      | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`<br>`4: cellular`                                                                                       | integer |
| `network_state`     | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`      | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `state`             | Geocoded state or province name                                                                                                                                                           | string  |
| `city`              | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`          | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`         | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `private_ip` | Local IP address (masked unless identifiable=true) | string |
| `latitude`          | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`         | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source`   | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |
| `measure_endpoint`  | Measurement endpoint URL or IP address (only included when configured for Orb-to-Orb testing)                                                                                           | string  |
| `measure_endpoint_name` | Human-readable name of the measurement endpoint (only included when configured for Orb-to-Orb testing)                                                                              | string  |
| `speed_test_engine` | Testing engine<br>`-1: unknown`<br>`0: orb`<br>`1: iperf`<br>`2: wave`                                                                                                                   | integer |
| `speed_test_server` | Server URL or identifier                                                                                                                                                                  | string  |


## Wi-Fi

The Wi-Fi Dataset includes all measures related to your Wi-Fi connection. Field availability varies by platform and Wi-Fi driver capabilities.

Wi-Fi data is available in 30 minute, 1 minute, and 1 second aggregated buckets.

Note: Wi-Fi Dataset fields are not currently available on iOS.

### `wifi_link_(30m|1m|1s)`

| column | description | type |
| ----- | ----- | :---: |
| **identifiers** |  |  |
| `orb_id` | Orb Sensor identifier | string |
| `orb_name` | Current Orb friendly name (masked unless identifiable=true) | string |
| `device_name` | Hostname or name of the device as identified by the OS (masked unless identifiable=true) | string |
| `orb_version` | Semantic version of collecting Orb | string |
| `timestamp` | Timestamp in epoch milliseconds | integer |
| `interval_ms` | Length of the aggregation window in milliseconds | integer |
| `dataset` | Dataset type identifier | string |
| **measures** |  |  |
| `rssi_avg` | Average received Wi-Fi signal strength in dBm | integer |
| `rssi_count` | Count of received signal strength measurements that succeeded | integer |
| `frequency_mhz` | Frequency of the connected channel in MHz | integer |
| `tx_rate_mbps` | Average transmit link rate in Mbps | integer |
| `tx_rate_count` | Count of transmit link rate measurements that succeeded | integer |
| `rx_rate_mbps` | Average receive link rate in Mbps (not available on macOS) | integer |
| `rx_rate_count` | Count of receive link rate measurements that succeeded | integer |
| `snr_avg` | Average signal-to-noise ratio in dB | integer |
| `snr_count` | Count of signal-to-noise ratio measurements that succeeded | integer |
| `noise_avg` | Average background radio frequency noise level in dBm | integer |
| `noise_count` | Count of noise measurements that succeeded | integer |
| `phy_mode` | Wi-Fi standard (e.g., 802.11n, 802.11ac, 802.11ax) | string |
| `security` | Wi-Fi security protocol (not available on Android)| string |
| `channel_width` | Channel width in MHz (not available on Android) | string |
| `channel_number` | Wi-Fi channel number | integer |
| `channel_band` | Wi-Fi band | string |
| `supported_wlan_channels` | Supported channel list for the device (not available on Windows) | string |
| `mcs` | Modulation and coding scheme index (only available on Linux) | integer |
| `nss` | Number of spatial streams (only available on Linux) | integer |
| **dimensions** |  |  |
| `bssid` | Access point MAC address (masked unless identifiable=true) | string |
| `mac_address` | Client MAC address (masked unless identifiable=true) | string |
| `network_name` | Network name (SSID, if available, masked unless identifiable=true) | string |
| `network_type` | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`<br>`4: cellular` | integer |
| `network_state` | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code` | Geocoded 2-digit ISO country code | string |
| `state` | Geocoded state or province name | string |
| `city` | Geocoded city name | string |
| `isp_name` | ISP name from GeoIP lookup | string |
| `public_ip` | Public IP address (masked unless identifiable=true) | string |
| `private_ip` | Local IP address (masked unless identifiable=true) | string |
| `latitude` | Orb location latitude (max 2-decimals,unless identifiable=true) | float |
| `longitude` | Orb location longitude (max 2-decimals,unless identifiable=true) | float |
| `location_source` | Location Source<br>`0: unknown`<br>`1: geoip` | integer |
| `measure_endpoint` | Measurement endpoint URL or IP address (only included when configured for Orb-to-Orb testing) | string |
| `measure_endpoint_name` | Human-readable name of the measurement endpoint (only included when configured for Orb-to-Orb testing) | string |


## Wi-Fi data availability by platform

| Field                   | Android | Windows | Linux | macOS |
| :---------------------- | :-----: | :-----: | :---: | :---: |
| RSSI dBm                |   🟢    |   🟢    |  🟢   |  🟢   |
| Frequency MHz           |   🟢    |   🟢    |  🟢   |  🟢   |
| TX Rate Mbps            |   🟢    |   🟢    |  🟢   |  🟢   |
| RX Rate Mbps            |   🟢    |   🟢    |  🟢   |  ❌   |
| SNR                     |   🟢    |   🟢    |  🟢   |  🟢   |
| Noise dBm               |   🟢    |   🟢    |  🟢   |  🟢   |
| PHY Mode                |   🟢    |   🟢    |  🟢   |  🟢   |
| Security                |   ❌    |   🟢    |  🟢   |  🟢   |
| Channel Width           |   ❌    |   🟢    |  🟢   |  🟢   |
| BSSID                   |   🟢    |   🟢    |  🟢   |  🟢   |
| Client MAC Address      |   🟢    |   🟢    |  🟢   |  🟢   |
| Channel Number          |   🟢    |   🟢    |  🟢   |  🟢   |
| Channel Band            |   🟢    |   🟢    |  🟢   |  🟢   |
| Supported WLAN Channels |   🟢    |   ❌    |  🟢   |  🟢   |
| MCS                     |   ❌    |   ❌    |  🟢   |  ❌   |
| NSS                     |   ❌    |   ❌    |  🟢   |  ❌   |
