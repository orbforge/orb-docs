---
title: Orb Datasets
shortTitle: Datasets
metaDescription: Datasets produced by Orb.
section: Deploy & Configure
---

# Orb Datasets

Orb applications and sensors are capable of producing **Datasets** for Scores, Responsiveness, Web Responsiveness, and Speed data. These datasets may be streamed to Orb [Local Analytics](/docs/deploy-and-configure/local-analytics), or a destination of your choice via Local API. This document describes the available datasets and their schemas. For details on configuring Orb to send Datasets to your desired backend, see [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration).

## Current Version

The current version of Orb Datasets is 1.0

:::info
Orb Datasets requires Orb app and sensor versions 1.3 and above.
:::

## Scores

The Scores Dataset focuses on Orb Score, its component scores (Responsiveness, Reliability, and Speed), and underlying measures used in these scores. For more details see [Orb Scores & Metrics](/docs/orb-app/orb-scores-metrics).

As Orb Score is calculated at a minimum 1-minute sliding window, the minimum Scores dataset granularity is 1 minute.

### `scores_1m`

| column                 | description                                                                                                                                                                               |  type   |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
| **identifiers**        |                                                                                                                                                                                           |         |
| `orb_id`               | Orb Sensor identifier                                                                                                                                                                     | string  |
| `orb_name`             | Current Orb friendly name (masked unless identifiable=true)                                                                                                                               | string  |
| `device_name`          | Hostname or name of the device as identified by the OS (masked unless identifiable=true)                                                                                                  | string  |
| `timestamp`            | Interval start timestamp in epoch milliseconds                                                                                                                                            | integer |
| `score_version`        | Semantic version of scoring methodology                                                                                                                                                   | string  |
| `orb_version`          | Semantic version of collecting Orb                                                                                                                                                        | string  |
| **measures**           |                                                                                                                                                                                           |         |
| `orb_score`            | Orb Score over interval (0-100)                                                                                                                                                           |  float  |
| `responsiveness_score` | Responsiveness Score over interval (0-100)                                                                                                                                                |  float  |
| `reliability_score`    | Reliability Score over interval (0-100)                                                                                                                                                   |  float  |
| `speed_score`          | Speed (Bandwidth) Score over interval (0-100)                                                                                                                                             |  float  |
| `speed_age_ms`         | Age of speed used in milliseconds, if not in timeframe. If in timeframe, 0.                                                                                                               | integer |
| `lag_avg_us`           | Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive", avg if interval)                                                                                       |  float  |
| `download_avg_kbps`    | Content download speed in Kbps                                                                                                                                                            | integer |
| `upload_avg_kbps`      | Content upload speed in Kbps                                                                                                                                                              | integer |
| `unresponsive_ms`      | Time spent in unresponsive state in Milliseconds                                                                                                                                          |  float  |
| `measured_ms`          | Time spent actively measuring in Milliseconds                                                                                                                                             |  float  |
| `lag_count`            | Count of Lag samples included                                                                                                                                                             | integer |
| `speed_count`          | Count of speed samples included                                                                                                                                                           | integer |
| **dimensions**         |                                                                                                                                                                                           |         |
| `network_type`         | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`                                                                                                        | integer |
| `network_state`        | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`         | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `city_name`            | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`             | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`            | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `latitude`             | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`            | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source`      | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |

## Responsiveness

The Responsiveness Dataset includes all measures related to network responsiveness, including lag, latency, jitter, and packet loss.

Responsiveness data is available in 1 second, 15 second, and 1 minute aggregated buckets.

### `responsiveness_(1m|15s|1s)`

| column | description | type |
| ----- | ----- | :---: |
| **identifiers** |  |  |
| `orb_id` | Orb Sensor identifier | string |
| `orb_name` | Current Orb friendly name (masked unless identifiable=true) | string |
| `device_name` | Hostname or name of the device as identified by the OS (masked unless identifiable=true) | string |
| `orb_version` | Semantic version of collecting Orb | string |
| `timestamp` | Timestamp in epoch milliseconds | integer |
| **measures** |  |  |
| `lag_avg_us` | Avg Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive") | integer |
| `latency_avg_us` | Avg round trip latency in microseconds for successful round trip | integer |
| `jitter_avg_us` | Avg Interpacket interarrival difference (jitter) in microseconds | integer |
| `latency_count` | Count of round trip latency measurements that succeeded | float |
| `latency_lost_count` | Count of round trip latency measurements that were lost | integer |
| `packet_loss_pct` | latency_lost_count / (latency_count+latency_loss_count) | float |
| `lag_count` | Lag sample count | integer |
| `router_lag_avg_us` | Avg Lag in microseconds (MAX 5000000 at which point the lag considered "unresponsive") | integer |
| `router_latency_avg_us` | Avg round trip latency in microseconds for successful round trip | integer |
| `router_jitter_avg_us` | Avg Interpacket interarrival difference (jitter) in microseconds | integer |
| `router_latency_count` | Count of round trip latency measurements that succeeded | float |
| `router_latency_lost_count` | Count of round trip latency measurements that were lost | integer |
| `router_packet_loss_pct` | latency_lost_count / (latency_count+latency_loss_count) | float |
| `router_lag_count` | Lag sample count | integer |
| **dimensions** |  |  |
| `network_name` | Network name (SSID, if available, masked unless identifiable=true) | string |
| `network_type` | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other` | integer |
| `network_state` | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code` | Geocoded 2-digit ISO country code | string |
| `city_name` | Geocoded city name | string |
| `isp_name` | ISP name from GeoIP lookup | string |
| `public_ip` | Public IP address (masked unless identifiable=true) | string |
| `latitude` | Orb location latitude (max 2-decimals,unless identifiable=true) | float |
| `longitude` | Orb location longitude (max 2-decimals,unless identifiable=true) | float |
| `location_source` | Location Source<br>`0: unknown`<br>`1: geoip` | integer |
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
| **measures**      |                                                                                                                                                                                           |         |
| `ttfb_us`         | Time to First Byte loading a web page in microseconds (MAX 5000000 at which point considered “unresponsive”)                                                                              | integer |
| `dns_us`          | DNS resolver response time in microseconds (MAX 5000000 at which point the lag considered “unresponsive”)                                                                                 | integer |
| **dimensions**    |                                                                                                                                                                                           |         |
| `network_name`    | Network name (SSID, if available, masked unless identifiable=true)                                                                                                                        | string  |
| `network_type`    | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`                                                                                                        | integer |
| `network_state`   | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`    | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `city_name`       | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`        | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`       | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `latitude`        | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`       | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source` | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |
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
| **measures**        |                                                                                                                                                                                           |         |
| `download_kbps`     | Download speed in Kbps                                                                                                                                                                    | integer |
| `upload_kbps`       | Upload speed in Kbps                                                                                                                                                                      | integer |
| **dimensions**      |                                                                                                                                                                                           |         |
| `network_name`      | Network name (SSID, if available, masked unless identifiable=true)                                                                                                                        | string  |
| `network_type`      | Network interface type<br>`0: unknown`<br>`1: wifi`<br>`2: ethernet`<br>`3: other`                                                                                                        | integer |
| `network_state`     | Speed test load state during interval<br>`0: unknown`<br>`1: idle`<br>`2: content upload`<br>`3: peak upload`<br>`4: content download`<br>`5: peak download`<br>`6: content`<br>`7: peak` | integer |
| `country_code`      | Geocoded 2-digit ISO country code                                                                                                                                                         | string  |
| `city_name`         | Geocoded city name                                                                                                                                                                        | string  |
| `isp_name`          | ISP name from GeoIP lookup                                                                                                                                                                | string  |
| `public_ip`         | Public IP address (masked unless identifiable=true)                                                                                                                                       | string  |
| `latitude`          | Orb location latitude (max 2-decimals,unless identifiable=true)                                                                                                                           |  float  |
| `longitude`         | Orb location longitude (max 2-decimals,unless identifiable=true)                                                                                                                          |  float  |
| `location_source`   | Location Source<br>`0: unknown`<br>`1: geoip`                                                                                                                                             | integer |
| `speed_test_engine` | Testing engine<br>`0: orb`<br>`1: iperf`                                                                                                                                                  | integer |
| `speed_test_server` | Server URL or identifier                                                                                                                                                                  | string  |
