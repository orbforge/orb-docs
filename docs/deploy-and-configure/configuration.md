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

## Remote Configuration

Orb configuration can also be handled remotely via Orb Cloud. Configurations can be managed on a per-Orb basis in the [Status](https://cloud.orb.net/status) section, or by managed Configurations in the the [Orchestration](https://cloud.orb.net/orchestration) section.

### Modifying configuration for an Orb

To modify an individual Orb's configuration, visit [https://cloud.orb.net/status](https://cloud.orb.net/status), click the "..." next to the Orb, and select "Edit". Modify the "Config" text area and click "Save" when finished.

### Managing Configurations

When dealing with many Orbs or groups of Orbs with different configuration needs, it is best to utilize the Configurations feature via the [Orchestration](https://cloud.orb.net/orchestration) section. To create a new Configuration, click "+ Create new configuration". Enter a name for your Configuration and click "Create". Your Configuration will now be available in the table. To modify the configuration, click the "..." next to the Configuration, and select "Edit". Modify the configuration and click "Save" when finished.

The Token associated with your Configuration can be used to link Orbs (see [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens)). You may later save edits to the Configuration and select the Apply option accessed from the "..." icon on the Orchestration page to push the updated configuration to all Orbs linked with that Token.

On the Status page, you can select Orbs, click "Apply Configuration", and select your named configuration to push that config to the selected Orbs.

### Configuring Responsiveness Endpoints

Orb measures network responsiveness by performing latency tests to various endpoints. You can configure which endpoints Orb uses for its responsiveness measurements to better align with your specific use case or network environment.

#### Default Behavior

By default, Orb automatically selects appropriate endpoints for responsiveness testing based on your network location and ISP.

#### Custom Endpoint Configuration

You can specify custom endpoints for responsiveness measurements using the `collectors.response.lag_endpoints` configuration option. This allows you to test responsiveness to endpoints that are most relevant to your use case, such as:

- Your company's servers or data centers
- Specific cloud providers or CDNs you rely on
- Gaming servers or real-time application endpoints
- Regional internet exchange points

##### Configuration Format

Endpoints are specified as a list of endpoint URLs using the format `protocol://host:port`. Supported protocols are:

- **`icmp`**: ICMP ping tests (e.g., `icmp://8.8.8.8`)
- **`https`**: HTTPS connection tests (e.g., `https://example.com:443`)
- **`h3`**: HTTP/3 connection tests (e.g., `h3://fonts.google.com`)

If no port is specified, the default port for the protocol will be used.

##### Advanced Configuration Editor

To configure custom responsiveness endpoints using the advanced configuration editor, add the following property to your configuration JSON:

```json
{
  "collectors.response.lag_endpoints": [
    "icmp://8.8.8.8",
    "icmp://1.1.1.1",
    "https://your-server.example.com:443",
    "h3://fonts.google.com"
  ]
}
```

##### Example Use Cases

**Gaming Network Monitoring**:
```json
{
  "collectors.response.lag_endpoints": [
    "icmp://na-west1.valve.net",
    "https://riot-ping-na-central1.na.leagueoflegends.com"
  ]
}
```

**Enterprise Network Monitoring**:
```json
{
  "collectors.response.lag_endpoints": [
    "icmp://dc1.company.com",
    "https://backup.company.com:443"
  ]
}
```

##### Important Notes

- Endpoint responsiveness data is included in [Responsiveness Datasets](/docs/deploy-and-configure/datasets#responsiveness) 
- ICMP (ping) tests require appropriate network permissions and may be blocked by some firewalls
- TCP tests establish connections to the specified port to measure connection establishment time
- Changes to endpoint configuration take effect within a few minutes of applying the configuration

### Configuring Datasets

Orb applications and sensors are capable of producing [Datasets](/docs/deploy-and-configure/datasets) for Scores, Responsiveness, Web Responsiveness, and Speed data. These datasets may be streamed to Orb Cloud, Orb [Local Analytics](/docs/deploy-and-configure/local-analytics), or a destination of your choice. See [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration) for details.

### Configuring Collection of Identifiable Information
Orb can collect attributes of your device and network which may be considered identifiable information (e.g. public IP address, network name, or device MAC address). By default, Orb minimizes the amount of potentially identifiable information collected, collecting enough to make the experience work (like your network name) without collecting more potentially identifiable information (like your device MAC address or private IP).

Some users may want to see that extra detail in Orb Cloud, Local Analytics, or via Orb APIs to better identify their devices and networks.

#### Identifiable levels
| Level | Description |
|-------|-------------|
| `none` | Orb will obfuscate any fields that are known to potentially identify your device or network. Your experience in Orb apps and Orb Cloud may be impacted as networks and device details will be obfuscated and it may be hard to tell which device you are looking at. |
| `minimal` | (Default) Orb will not obfuscate some basic potentially identifiable information, like network name, to make the normal Orb app and Orb Cloud user experiences work. Identifiable fields not required for basic app usage, like MAC Address, will still be obfuscated.  |
| `full` | Orb will not obfuscate any fields of collected data. |

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

#### Enabling identifiable information in datasets
While `orb.identifiable_level` informs which attributes of your device and network an Orb obfuscates during collection, there is an additonal option to only obfuscate identifiable information in Datasets outputs.

This allows you to control whether identifiable information is included in Datasets sent to Orb Cloud, Local Analytics, or custom endpoints separately from what is collected. See [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration#identifiable-information) for details.
