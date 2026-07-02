---
title: Orb Cloud MCP for OpenCode
shortTitle: OpenCode
metaDescription: Connect OpenCode to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP for OpenCode

Connect OpenCode to the [Orb Cloud MCP](/docs/integrations/mcp) server to query and act on your Orb Cloud data directly from OpenCode.

:::info
See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a full list of features, authentication options, and troubleshooting steps.
:::

1. Run:

   ```bash
   opencode mcp add
   ```

2. Select **Global**.
3. Enter a name for the MCP, e.g. `Orb`.
4. Select **Remote**.
5. For **Enter MCP server URL**, enter `https://panel.orb.net/mcp`.
6. When asked **Does this server require OAuth authentication?**, select **Yes**.
7. When asked **Do you have a pre-registered client ID?**, select **No**.
8. Authenticate:

   ```bash
   opencode mcp auth Orb
   ```

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) on the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting OpenCode to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
