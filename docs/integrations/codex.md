---
title: Orb Cloud MCP for Codex in ChatGPT
shortTitle: ChatGPT & Codex
metaDescription: Connect Codex to your Orb Cloud data using MCP.
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP for ChatGPT desktop and Codex

Connect Orb Cloud MCP to the ChatGPT desktop app, Codex CLI, or Codex IDE extension. These clients share MCP configuration on the same Codex host, so you can configure Orb once and use it across supported Codex surfaces.

:::info
ChatGPT web uses a separate MCP app or plugin configuration and does not read the local MCP configuration used by ChatGPT desktop, Codex CLI, or the Codex IDE extension. See [Orb Cloud MCP for ChatGPT web](/docs/integrations/chatgpt-web).

See the [Orb Cloud MCP](/docs/integrations/mcp) guide for a complete list of features, authentication options, and troubleshooting steps.
:::

You can add the Orb Cloud MCP server from ChatGPT desktop, Codex CLI, or the Codex IDE extension.

## ChatGPT desktop app

1. Open the ChatGPT desktop app.
2. Open **Settings**, then select **MCP servers**.
3. Click **Add server**.
4. Enter the following details:
   - **Name:** `Orb Cloud MCP`
   - **Transport:** `Streamable HTTP`
   - **URL:** `https://panel.orb.net/mcp`
5. Click **Save**, then click **Restart**.
6. Click **Authenticate** next to Orb Cloud MCP and sign in to Orb Cloud.
7. In the composer, enter `/mcp` to confirm that the server is connected.

## Codex CLI

Run the following commands:

```bash
codex mcp add orb --url https://panel.orb.net/mcp
codex mcp login orb
codex mcp list
```

The first command adds the Orb Cloud server, the second starts OAuth authentication, and the third confirms that the server is configured.

In the interactive Codex terminal interface, enter `/mcp` to view active MCP servers.

## Codex IDE extension

1. Open the gear menu in the Codex IDE extension.
2. Select **MCP servers**.
3. Click **Add server**.
4. Enter the following details:
   - **Name:** `Orb Cloud MCP`
   - **Transport:** `Streamable HTTP`
   - **URL:** `https://panel.orb.net/mcp`
5. Click **Save**, then click **Restart extension**.
6. Click **Authenticate** next to Orb Cloud MCP and sign in to Orb Cloud.

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) in the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting ChatGPT desktop or Codex to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
