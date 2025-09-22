---
title: Orb Configuration
shortTitle: Orb Configuration
metaDescription: Configuring the behavior of Orb.
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

## Remote Configuration

Orb configuration can also be handled remotely via Orb Cloud. Configurations can be managed on a per-Orb basis in the [Status](https://cloud.orb.net/status) section, or by managed Configurations in the the [Orchestration](https://cloud.orb.net/orchestration) section.

### Modifying configuration for an Orb

To modify an individual Orb's configuration, visit [https://cloud.orb.net/status](https://cloud.orb.net/status), click the "..." next to the Orb, and select "Edit". Modify the "Config" text area and click "Save" when finished.

### Managing Configurations

When dealing with many Orbs or groups of Orbs with different configuration needs, it is best to utilize the Configurations feature via the [Orchestration](https://cloud.orb.net/orchestration) section. To create a new Configuration, click "+ Create new configuration". Enter a name for your Configuration and click "Create". Your Configuration will now be available in the table. To modify the configuration, click the "..." next to the Configuration, and select "Edit". Modify the "Config" text area and click "Save" when finished.

The Token associated with your Configuration can be used to link Orbs (see [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens)). You may later save edits to the Configuration and select the Apply option accessed from the "..." icon on the Orchestration page to push the updated configuration to all Orbs linked with that Token.

On the Status page, you can select Orbs, click "Apply Configuration", and select your named configuration to push that config to the selected Orbs.

### Configuring Datasets

Orb applications and sensors are capable of producing [Datasets](/docs/deploy-and-configure/datasets) for Scores, Responsiveness, Web Responsiveness, and Speed data. These datasets may be streamed to Orb [Local Analytics](/docs/deploy-and-configure/local-analytics) or a destination of your choice. See [Datasets Configuration](/docs/deploy-and-configure/datasets-configuration) for details.