---
title: Orb Cloud MCP for Copilot Studio
shortTitle: Copilot Studio
metaDescription: Connect Microsoft Copilot Studio to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Intermediate 🧑‍💻'
---

# Orb Cloud MCP for Copilot Studio

Connect Microsoft Copilot Studio to the [Orb Cloud MCP](/docs/integrations/mcp) server to query and act on your Orb Cloud data from a Copilot Studio agent.

:::info
See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a full list of features, authentication options, and troubleshooting steps.
:::

Copilot Studio connects using an [Orb Cloud API key](/docs/integrations/mcp#api-key) rather than OAuth. Create one before you begin.

1. Navigate to [Copilot Studio](https://copilotstudio.microsoft.com/).
2. In the side pane, select **Agents** and click your agent under **My Agents** (or create a new agent).
3. Click **Tools**, then **Add a tool**.
4. Select **Add new MCP**.
5. In the **Add a Model Context Protocol server** window, enter:
   - **Server name**: a name of your choosing
   - **Server description**: a description of your choosing
   - **Server URL**: `https://panel.orb.net/mcp`
   - **Authentication**: API key
   - **Type**: Header
   - **Header name**: `Authorization`
6. Click **Create**.
7. Next to **Connection**, click **Not connected** and select **Create new connection**.
8. Enter `Bearer orb-ok1-YourAPIToken` (using your own API key) and click **Create**.
9. Click **Add**.
10. Test the connection with a prompt in **Test your agent**, such as "How many Orbs do I have online?"

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) on the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting Copilot Studio to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
