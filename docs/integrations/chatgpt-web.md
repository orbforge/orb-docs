---
title: Orb Cloud MCP for ChatGPT web
shortTitle: ChatGPT web
metaDescription: Connect ChatGPT web to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP for ChatGPT web

Connect ChatGPT on the web to Orb Cloud using the Model Context Protocol (MCP). Once connected, you can ask ChatGPT to retrieve Orb Scores and measurements, investigate connectivity problems, check Orb status, and run supported tests using your Orb Cloud data.

:::info
These instructions are for **ChatGPT web**. To connect Orb Cloud to the ChatGPT desktop app, Codex CLI, or Codex IDE extension, see [Orb Cloud MCP for ChatGPT desktop and Codex](/docs/integrations/codex).

See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a complete list of available features, authentication options, and troubleshooting steps.
:::

## Requirements

Before connecting Orb Cloud, you need:

- An Orb Cloud account
- A ChatGPT account with access to Developer mode
- Permission to create custom MCP apps or plugins in your ChatGPT account or workspace

Developer mode availability and write-action support depend on your ChatGPT plan and workspace policy. In a managed ChatGPT workspace, an administrator may need to enable Developer mode or authorize you to create custom apps.

## Step 1: Enable Developer mode

1. Open ChatGPT in your web browser.
2. Open **Settings**.
3. Select **Security and login**.
4. Turn on **Developer mode**.

Developer mode allows ChatGPT to connect to remote MCP servers such as Orb Cloud.

:::note
In a managed Business, Enterprise, or Education workspace, an administrator may need to enable Developer mode from workspace settings first. Depending on your workspace configuration, authorized users may also find the setting under **Settings → Apps → Advanced Settings**.
:::

## Step 2: Add the Orb Cloud MCP server

1. Open **Settings → Plugins** in ChatGPT.
2. Click the **+** button to create a developer-mode app or plugin.
3. Enter the following details:
   - **Name:** `Orb Cloud`
   - **Description:** `Access Orb Cloud scores, measurements, events, devices, and supported tests.`
   - **MCP server URL:** `https://panel.orb.net/mcp`
4. Select OAuth authentication if ChatGPT asks you to choose an authentication method.
5. Click **Scan Tools** and wait for ChatGPT to discover the tools exposed by Orb Cloud.
6. Sign in to Orb Cloud and authorize access when prompted.
7. Review the discovered tools, then click **Create**.

The Orb Cloud connection will appear in your ChatGPT app or plugin settings as a developer-mode draft.

## Step 3: Use Orb Cloud in ChatGPT

1. Start a new ChatGPT conversation.
2. Open the **+** menu in the composer.
3. Select **Developer mode**.
4. Select **Orb Cloud** from the available apps or plugins.
5. Ask ChatGPT a question about your Orb Cloud data.

For example:

> Use Orb Cloud to show me which of my Orbs had the lowest score today.

Explicitly naming Orb Cloud helps ensure that ChatGPT uses the integration rather than general knowledge or web search.

:::note
ChatGPT may ask you to confirm actions that change data or start an operation, such as triggering a speed test. Available actions depend on your ChatGPT plan, workspace permissions, and the tools enabled for the Orb Cloud app.
:::

## Using the Integration

See [Using the Integration](/docs/integrations/mcp#using-the-integration) in the Orb Cloud MCP guide for additional example prompts and supported workflows.

## Refreshing the Integration

ChatGPT stores information about the tools provided by the Orb Cloud MCP server. If Orb adds or updates MCP tools:

1. Open **Settings → Plugins**.
2. Select **Orb Cloud**.
3. Click **Refresh**.
4. Review any new or updated tools.
5. Start a new conversation before testing the changes.

For a published workspace app, an administrator may need to review and publish the updated version. On ChatGPT Business, a published app may need to be recreated and republished when its tools or metadata change.

## Publishing in a Managed Workspace

A workspace administrator or owner can publish the Orb Cloud app for other members:

1. Open **Workspace Settings → Apps → Drafts**.
2. Select **Orb Cloud**.
3. Review the tools, permissions, and safety warnings.
4. Click **Publish**.

Once published, Orb Cloud appears in the workspace's approved apps or plugins.

## Troubleshooting

### Developer mode is not available

Developer mode availability depends on your ChatGPT plan and workspace policy. If you use a managed workspace, ask an administrator to confirm that Developer mode and custom MCP apps are enabled for your account.

### ChatGPT cannot connect to Orb Cloud

Confirm that the MCP server URL is entered exactly as follows:

```text
https://panel.orb.net/mcp
```

Also confirm that you can sign in to Orb Cloud with the account you want ChatGPT to access.

### Orb Cloud does not appear in a conversation

- Confirm that the Orb Cloud developer-mode app was created successfully
- Start a new conversation after creating or refreshing the app
- Open the **+** menu and select **Developer mode**
- Select Orb Cloud from the available apps or plugins
- Refer to Orb Cloud explicitly in your prompt

### Authentication has expired

Open the Orb Cloud app settings and reconnect or reauthenticate your Orb Cloud account.

### A new Orb Cloud tool is missing

Open the Orb Cloud app settings and click **Refresh**. For a published workspace app, an administrator may need to review and republish the app. On ChatGPT Business, the app may need to be recreated and republished.

## Support

For additional help connecting ChatGPT web to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
