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

- An Orb Cloud account with access to the Space(s) you want to query
- An Orb Cloud API key
- A ChatGPT account with access to Developer mode
- Permission to create developer-mode MCP connections in ChatGPT

Full MCP support, including actions that modify data or trigger operations, depends on your ChatGPT plan and workspace policy. In a managed ChatGPT workspace, an administrator may need to enable Developer mode or authorize you to create custom apps.

:::note
Orb's interactive OAuth flow is not currently compatible with ChatGPT web because Orb does not support Dynamic Client Registration (DCR), Client ID Metadata Documents (CIMD), or a predefined ChatGPT OAuth client. Use an Orb Cloud API key for this integration.
:::

## Step 1: Create an Orb Cloud API key

1. Sign in to Orb Cloud.
2. Open **Orchestration**.
3. Create a new API key for ChatGPT.
4. Grant at least:
   - **Organizations: Read**
   - **Devices: Read**
   - **MCP**
5. Add **Devices: Stream** if you want ChatGPT to access real-time data.
6. Grant the applicable device-action permission if you want ChatGPT to trigger speed tests.
7. Copy the API key.

:::warning
Your API key provides access to Orb Cloud according to the permissions you grant. Store it securely, do not paste it into a ChatGPT conversation, and revoke it immediately if it is exposed.
:::

## Step 2: Enable Developer mode

1. Open ChatGPT Settings.
2. Select Security and login.
3. Turn on Developer mode.

In a managed Business, Enterprise, or Edu workspace, your administrator may need to enable access to Developer mode first.

### ChatGPT Business

Workspace administrators and owners can enable Developer mode while creating the app:

1. Open **Workspace settings**.
2. Select **Apps**.
3. Click **Create**.
4. Enable **Developer mode** when prompted.

### ChatGPT Enterprise or Education

1. Open **Settings**.
2. Select **Apps**.
3. Open **Advanced Settings**.
4. Turn on **Developer mode**.

Your workspace administrator may need to grant Developer mode access before the toggle appears.

## Step 3: Add the Orb Cloud MCP server

1. Open **Plugins** in ChatGPT.
2. Click the **+** button.
3. Enter:
   - **Name**: Orb Cloud
   - **Description:** `Access Orb Cloud scores, measurements, events, devices, and supported tests.`
   - **MCP server URL:** `https://panel.orb.net/mcp`
4. Select **API key** as the authentication method.
5. Enter your Orb Cloud API key.
6. Create the connection.
7. Review the tools discovered from Orb Cloud.

   If ChatGPT asks for separate header settings, use:

   ```text
   Header name: Authorization
   Header value: Bearer orb-ok1-YourAPIToken
   ```

After configuration, the app appears under **Settings → Apps → Enabled Apps** with a **Dev** label. In a managed workspace, it also appears as a draft under **Workspace settings → Apps → Drafts**.

## Step 4: Test Orb Cloud in ChatGPT

1. Start a new ChatGPT conversation.
2. Open the **+** menu in the composer.
3. Select **Developer mode**.
4. Select **Orb Cloud**.
5. Ask ChatGPT a question about your Orb Cloud data.

For example:

> Use Orb Cloud to show me which of my Orbs had the lowest score today.

Explicitly naming Orb Cloud helps ensure that ChatGPT uses the integration rather than general knowledge or web search.

:::note
ChatGPT may ask you to confirm actions that change data or start an operation, such as triggering a speed test. Available actions depend on your ChatGPT plan, workspace permissions, the tools enabled for the Orb Cloud app, and the permissions granted to the API key.
:::

## Using the Integration

See [Using the Integration](/docs/integrations/mcp#using-the-integration) in the Orb Cloud MCP guide for additional example prompts and supported workflows.

## Publishing in a Managed Workspace

A workspace administrator or owner can publish the Orb Cloud app for other members:

1. Open **Workspace settings → Apps → Drafts**.
2. Select **Orb Cloud**.
3. Review its tools, API-key permissions, and safety warnings.
4. Click **Publish**.

Once published, Orb Cloud appears in the workspace's approved apps.

:::warning
Do not publish an Orb Cloud connection backed by a personal API key unless the key is intentionally intended to be shared by everyone with access to the connection. All users may act with the permissions and Orb Cloud access granted to that API key.
:::

:::warning
If the published Orb Cloud app uses a shared API key, users of the app may access Orb Cloud with the permissions and Space access granted to that key. Before publishing, make sure the API key follows least-privilege access and is appropriate for all intended users.
:::

## Refreshing the Integration

ChatGPT stores a snapshot of the tools provided by the Orb Cloud MCP server. If Orb adds or changes MCP tools:

1. Open **Plugins**.
2. Open the Orb Cloud MCP connection.
3. Click **Refresh**.
4. Confirm that the updated tools and metadata appear.
5. Start a new conversation before testing the changes.

For a published workspace app, an administrator may need to review and publish the updated version. On ChatGPT Business, a published app may need to be recreated and republished when its tools or metadata change.

## Rotating or Revoking the API Key

Update the API key for the Orb Cloud MCP connection in ChatGPT.

1. Create a replacement key in Orb Cloud with the required permissions.
2. Update the authentication settings for the Orb Cloud app in ChatGPT.
3. Confirm the app can still scan and call its tools.
4. Revoke the old key in Orb Cloud.

If ChatGPT does not allow the authentication settings of a published app to be changed, recreate and republish the app using the replacement key.

## Troubleshooting

### Developer mode is not available

Developer mode availability depends on your ChatGPT plan, workspace role, and workspace policy. Ask a workspace administrator to confirm that Developer mode and custom MCP apps are enabled for your account.

### ChatGPT cannot scan the Orb Cloud tools

Confirm that:

- The MCP server URL is exactly `https://panel.orb.net/mcp`
- **API key** is selected as the authentication method
- The Orb Cloud API key is valid and has not been revoked
- The authorization header uses the `Bearer` scheme if ChatGPT asks for a complete header value

### Orb Cloud does not appear in a conversation

- Confirm that the Orb Cloud MCP connection was created successfully
- Open the Orb Cloud connection in Plugins and click Refresh.
- Select Orb Cloud from the available apps or tools
- Refer to Orb Cloud explicitly in your prompt

### No Orbs or Spaces are returned

Confirm that the API key:

- Has **Organizations: Read** and **Devices: Read** permissions
- Has access to the correct Orb Cloud Space
- Has not been regenerated or revoked

### ChatGPT cannot trigger a speed test

Confirm that:

- Your ChatGPT plan and workspace allow write actions
- The Orb Cloud app includes the speed-test tool
- The API key has the required device-action permission
- The selected Orb is online

### A new Orb Cloud tool is missing

Open the Orb Cloud app settings and click **Refresh**. For a published workspace app, an administrator may need to review and republish the app. On ChatGPT Business, the app may need to be recreated and republished.

## Support

For additional help connecting ChatGPT web to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
