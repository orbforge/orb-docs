---
title: Orb Cloud MCP for Claude
shortTitle: Claude
metaDescription: Connect Claude Code and Claude Desktop to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP for Claude

Connect Claude Code or Claude Desktop to the [Orb Cloud MCP](/docs/integrations/mcp) server to query and act on your Orb Cloud data directly from Claude.

:::info
See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a full list of features, authentication options, and troubleshooting steps.
:::

## Claude Code

1. Add the server:

   ```bash
   claude mcp add --transport http orb https://panel.orb.net/mcp
   ```

2. Start Claude Code:

   ```bash
   claude
   ```

3. Run `/mcp`.
4. Select **Orb**, then select **Authenticate**.
5. Follow the on-screen instructions to sign in with your Orb Cloud account.

:::info
If you are using Claude Code to develop a dashboard or application, use the [Orb Cloud API](/docs/integrations/api) rather than the Orb Cloud MCP.
:::

## Claude Desktop

1. Navigate to **Customize**, then **Connectors** in the left pane.
2. Click the **+** next to **Connectors**, then select **Add custom connector**.
3. Enter `Orb Cloud` in the **Name** field.
4. In the **Remote MCP server URL** field, enter `https://panel.orb.net/mcp`.
5. Click **Add**.
6. Click **Connect**, and log into Claude and Orb Cloud as prompted.

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) on the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting Claude to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
