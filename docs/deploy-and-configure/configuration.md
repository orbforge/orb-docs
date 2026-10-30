---
title: Orb Configuration
shortTitle: Orb Configuration
metaDescription: Control Orb behavior using environment variables and remote configuration options.
section: Deploy & Configure
---

# Configuration

Orb comes with local and remote configuration capabilities to control behavior.

## Environment variables

The following environment variables can be set:

| Name | Description | Example | Minimum Version |
| ---- | ----------- | ------- | ----------------|
| `ORB_DATA_DIR` | Sets the data directory for Orb configuration and database | `ORB_DATA_DIR=~/orbdata` | 1.0 |
| `ORB_DB_DIR` | Sets the database directory for Orb | `ORB_DB_DIR=/tmp/orb/database` | 1.3 |
| `ORB_CONFIG_DIR` | Sets the persistent configuration directory for Orb | `ORB_CONFIG_DIR=~/orbconfig` | 1.3 |
| `ORB_FIRSTHOP_DISABLED` | Disables measuring and storing first-hop latency. Should generally be utilized on devices that are acting as a router | `ORB_FIRSTHOP_DISABLED=1` | 1.2 |
| `ORB_BANDWIDTH_DISABLED` | Disables perfoming periodic content speed tests | `ORB_BANDWIDTH_DISABLED=1` | 1.2 |
| `ORB_DEPLOYMENT_TOKEN` | Sets the [Deployment Token](/docs/deploy-and-configure/deployment-tokens#using-environment-variable) | `ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678` | 1.2 |
| `ORB_EPHEMERAL_MODE` | Sets Orb measurement data storage to in-memory only. Protects flash memory from frequent writes. All measurement data stored on the Orb is lost when Orb is stopped or restarted.  | `ORB_EPHEMERAL_MODE=1` | 1.4.0 |
| `ORB_DEVICE_NAME_OVERRIDE` | Sets this Orb's name which appears in Orb apps and Orb Cloud | `ORB_DEVICE_NAME_OVERRIDE=MyDeviceName` | 1.4.1 |
| `ORB_MEASURE_SERVER_ENABLED` | Enables the Orb to act as a server for speed and responsiveness testing | `ORB_MEASURE_SERVER_ENABLED=1` | 1.4.10 |
| `ORB_MEASURE_SERVER_PORT` | Set the port for the Orb measurement server | `ORB_MEASURE_SERVER_PORT=8080` | 1.4.10 |
| `ORB_SERVER_POP` | Sets a point of presence description for the Orb measurement server, reported to Orbs running Orb-to-Orb measurements against it. By convention, the nearest 3-character airport code, but any short string works | `ORB_SERVER_POP=sea` | 1.6.0 |
| `ORB_ZEROCONF_PUBLISH` | Advertises this Orb on the local network over mDNS. Set to `0` or `false` to stop advertising | `ORB_ZEROCONF_PUBLISH=0` | — |
| `ORB_ZEROCONF_BROWSE` | Discovers other Orbs on the local network over mDNS. Set to `0` or `false` to stop discovery | `ORB_ZEROCONF_BROWSE=0` | — |

## Remote Configuration

Orb configuration can also be handled remotely via Orb Cloud. Configurations can be managed on a per-Orb basis in the [Status](https://cloud.orb.net/status) section, or by managed Configurations in the the [Orchestration](https://cloud.orb.net/orchestration) section.

### Modifying configuration for an Orb

To modify an individual Orb's configuration, visit [https://cloud.orb.net/status](https://cloud.orb.net/status), click the "..." next to the Orb, and select "Edit". Modify the "Config" text area and click "Save" when finished.

### Managing Configurations

When dealing with many Orbs or groups of Orbs with different configuration needs, it is best to utilize the Configurations feature via the [Orchestration](https://cloud.orb.net/orchestration) section. To create a new Configuration, click "+ Create new configuration". Enter a name for your Configuration and click "Create". Your Configuration will now be available in the table. To modify the configuration, click the "..." next to the Configuration, and select "Edit". Modify the configuration and click "Save" when finished.

The Token associated with your Configuration can be used to link Orbs (see [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens)). You may later save edits to the Configuration and select the Apply option accessed from the "..." icon on the Orchestration page to push the updated configuration to all Orbs linked with that Token.

On the Status page, you can select Orbs, click "Apply Configuration", and select your named configuration to push that config to the selected Orbs.

### Endpoint Configuration

Orb offers extensive options for testing Responsiveness, Web Responsiveness, and Speed to different endpoints. Including your own! See the [Endpoints & Engines](/docs/deploy-and-configure/endpoints) documentation for more details.

#### Custom Web Responsiveness Endpoints

This section was moved to the [Endpoints & Engines](/docs/deploy-and-configure/endpoints#custom-web-responsiveness-endpoints) page.

### Configuring Datasets

Orb applications and sensors are capable of producing [Datasets](/docs/deploy-and-configure/datasets) for Scores, Responsiveness, Web Responsiveness, and Speed data. These datasets may be streamed to Orb Cloud, Orb [Local Analytics](/docs/deploy-and-configure/local-analytics), or a destination of your choice. See [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration) for details.

### Configuring Collection of Identifiable Information
Orb can collect attributes of your device and network that may be considered identifiable information, such as public IP address, network name, or MAC address. By default, Orb masks any fields that aren't needed for key features to work.

Some users may want to see that extra detail in Orb Cloud, Local Analytics, or via Orb APIs to better identify their devices and networks.

#### Identifiable levels
| Level | Description |
|-------|-------------|
| `none` | Orb will mask any fields that are known to potentially identify your device or network. Your experience in Orb apps and Orb Cloud may be impacted as networks and device details will be masked and it may be hard to tell which device you are looking at. |
| `minimal` | (Default) Orb will mask identifiable fields that aren't needed for key features to work, like MAC Address. Fields like network name will not be masked. |
| `full` | Orb will not mask any fields of collected data. |

#### Configuration

Identifiable level is controlled via the `orb.identifiable_level` field in Orb Cloud config.

##### Advanced Configuration Editor
To set the identifiable level using the advanced configuration editor, add the following property to the root of your configuration JSON.

```json
{
  "orb.identifiable_level": ["full"],
  ...
}
```

#### Masking in Datasets
You can also mask identifiable information in Datasets for individual destinations, such as Orb Cloud, Local Analytics, or a custom endpoint. See [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration#identifiable-information) for details.
