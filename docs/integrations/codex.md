---
title: Orb Cloud MCP for Codex
shortTitle: Codex
metaDescription: Connect Codex to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP for Codex

Connect Codex to the [Orb Cloud MCP](/docs/integrations/mcp) server to query and act on your Orb Cloud data directly from Codex.

:::info
See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a full list of features, authentication options, and troubleshooting steps.
:::

Codex supports adding MCP servers from the desktop app or the command-line TUI.

## App

1. Open **Settings**, then **MCP Servers**.
2. Click **+ Add server**.
3. Enter the following details:
   - **Name**: `Orb Cloud MCP`
   - Toggle the transport to **Streamable HTTP**
   - **URL**: `https://panel.orb.net/mcp`
4. Click **Save**.
5. Click **Authenticate** next to the server name and follow the prompts to sign in.

## TUI

```bash
codex mcp add orb --url https://panel.orb.net/mcp
```

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) on the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting Codex to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
