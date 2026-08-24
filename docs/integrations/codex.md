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

Configure the Orb Cloud MCP server once in your shared Codex configuration, then use it from ChatGPT desktop, Codex CLI, or the Codex IDE extension.

## API Key Authentication/Bearer Token Configuration

Orb Cloud MCP currently uses an Orb Cloud API key for authentication with ChatGPT desktop, Codex CLI, and the Codex IDE extension.

Before configuring Orb Cloud MCP, [create an API key](https://orb.net/docs/integrations/api) and store it in an environment variable named `ORB_API_KEY`.

For example:

```bash
export ORB_API_KEY="orb-ok1-YourAPIToken"
```

:::note
The `ORB_API_KEY` environment variable must be available to the application running ChatGPT or Codex. If you launch ChatGPT desktop outside of a terminal, make sure the environment variable is configured so the desktop app can access it.
:::

Then add Orb Cloud MCP to your shared Codex configuration at `~/.codex/config.toml`:

```toml
[mcp_servers.orb]
url = "https://panel.orb.net/mcp"
bearer_token_env_var = "ORB_API_KEY"
```

This configuration sends your Orb Cloud API key as a Bearer token in the `Authorization` header without storing the API key directly in your Codex configuration file.

## ChatGPT desktop app

After configuring Orb Cloud MCP:

1. Open or restart the ChatGPT desktop app.
2. Open **Settings**, then select **MCP servers**.
3. Confirm that **orb** appears in the server list and is enabled.
4. In the composer, enter `/mcp` to confirm that Orb Cloud MCP is connected.

Orb Cloud MCP uses your API key as a Bearer token, so you do not need to click **Authenticate**.

## Codex CLI

Run the following command:

```bash
codex mcp list
```
In the interactive Codex terminal interface, enter `/mcp` to view active MCP servers.

## Codex IDE extension

After configuring Orb Cloud MCP:

1. Restart the Codex IDE extension.
2. Open the gear menu.
3. Select **MCP servers**.
4. Confirm that **orb** appears in the server list and is enabled.

Orb Cloud MCP uses your API key as a Bearer token, so you do not need to click **Authenticate**.

## Using the Integration

Once connected, see [Using the Integration](/docs/integrations/mcp#using-the-integration) in the Orb Cloud MCP guide for example prompts to try.

## Support

For additional help connecting ChatGPT desktop or Codex to Orb Cloud:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud MCP](/docs/integrations/mcp) guide for authentication and troubleshooting details
