---
title: Orb Cloud MCP
shortTitle: MCP
metaDescription: Connect AI assistants and agents to your Orb Cloud data using the Model Context Protocol (MCP).
section: Integrations
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Orb Cloud MCP

The Orb Cloud MCP server lets AI assistants and agents query and act on your Orb Cloud data using natural language. Connect a supported client to ask questions like "How many Orbs do I have online?" or "Why was my connection unstable on the Teams call I've been on for the past 45 minutes?" without leaving your assistant of choice.

:::info
While Free plan users have access to Orb Cloud MCP, access to historical data is limited to 1-minute granularity [Scores Datasets](/docs/deploy-and-configure/datasets#scores) for the past 72 hours. 
:::

## What is MCP?

The [Model Context Protocol](https://modelcontextprotocol.io) (MCP) is an open standard that lets AI assistants and agents securely connect to external tools and data sources. Orb's MCP server exposes your Orb Cloud data as a set of tools an MCP-compatible client can call on your behalf, so you can ask questions and take action on your Orbs directly from your assistant.

## Features

- **Spaces & Devices**: List the Orb Cloud Spaces you have access to, and search or filter Orbs within a Space by name, location, network, tags, status, or score
- **Device Summaries**: Get current status, connection, location, ISP, and score details for one or more Orbs
- **Historical Measurements**: Retrieve bucketed historical data for scores, responsiveness, web responsiveness, speed, and Wi-Fi link quality over a timeframe from 1 hour to 1 week
- **Speed Test History**: List individual speed test results
- **Events & Incidents**: Review organization events for a single Orb or across an entire Space
- **Trigger Speed Tests**: Kick off a Content or Peak speed test on an online Orb on demand

## Requirements

Before setting up the integration, ensure you have:

- An Orb Cloud account with access to the Space(s) you want to query
- An MCP-compatible client (see [Connecting a Client](#connecting-a-client) below)

## Server Details

The Orb Cloud MCP server is available at:

**`https://panel.orb.net/mcp`**

It communicates over Streamable HTTP, the standard remote transport for MCP servers.

## Authentication

The Orb Cloud MCP server supports two authentication methods, depending on your client's capabilities.

### OAuth

Clients that support Orb's OAuth flow can authenticate interactively. You will be redirected to sign in to Orb Cloud and approve access without creating or copying credentials.

OAuth is the recommended method for Claude and OpenCode.

:::note
ChatGPT web, ChatGPT desktop, Codex CLI, and the Codex IDE extension currently use an Orb Cloud API key instead of OAuth because Orb does not yet support the OAuth client-registration methods required by these clients.
:::

### API Key

Clients that support Bearer-token authentication can connect using an Orb Cloud API key. This is currently the required authentication method for ChatGPT web, ChatGPT desktop, Codex CLI, and the Codex IDE extension because Orb's OAuth implementation is not currently compatible with the OAuth client-registration methods used by these clients.

Using Orb Cloud API keys for authentication also allows you to restrict which API permissions the MCP server can access.

API keys are currently used for:
 - ChatGPT web
 - ChatGPT desktop
 - Codex CLI
 - Codex IDE extension

To create one, follow [Creating an API Key](/docs/integrations/api#creating-an-api-key) in the Orb Cloud API guide. Grant at least **Organizations: Read**, **Devices: Read**, and **MCP** access; add **Devices: Stream** if you also want the assistant to access real-time data. Pass the key in the `Authorization` header as a Bearer token:

```
Authorization: Bearer orb-ok1-YourAPIToken
```

## Connecting a Client

Orb's MCP server works with any MCP-compatible client. Setup instructions are provided for the following clients:

- [Claude](/docs/integrations/claude-mcp) — Claude Code and Claude desktop
- [ChatGPT Desktop & Codex](/docs/integrations/codex) - ChatGPT desktop app, Codex CLI, and Codex IDE extension
- [ChatGPT web](/docs/integrations/chatgpt-web)
- [Copilot Studio](/docs/integrations/copilot)
- [OpenCode](/docs/integrations/opencode)
- [Other MCP Clients](#other-mcp-clients)

| Client | How Orb is configured | Authentication |
| --- | --- | --- |
| ChatGPT web | Developer-mode MCP connection in ChatGPT | Orb Cloud API key |
| ChatGPT desktop app | Shared Codex MCP configuration (`~/.codex/config.toml`) | Bearer API key |
| Codex CLI | Shared Codex MCP configuration (`~/.codex/config.toml`) | Bearer API key |
| Codex IDE extension | Shared Codex MCP configuration (`~/.codex/config.toml`) | Bearer API key |
| Other compatible clients | Remote Streamable HTTP server | OAuth or Bearer API key, depending on client support |

### Other MCP Clients

Any client that supports remote MCP servers over Streamable HTTP can connect to Orb using the server URL `https://panel.orb.net/mcp`. Use OAuth where the client supports it, or an [API key](#api-key) as a Bearer token where it does not. 

Orb does not currently support DCR or CIMD. Clients must use an OAuth flow compatible with Orb’s current implementation or an API key where Bearer-token authentication is supported.

## Using the Integration

Once connected, ask your assistant to query or act on your Orb Cloud data in natural language, for example:

- "How many Orbs do I have online right now?"
- "What's the current Orb Score for my office sensor?"
- "Show me responsiveness over the last 24 hours for my home Orb."
- "Were there any outliers in my speed tests run in the past week?"
- "Were there any alerts across my Home space in the last 30 days?"
- "Trigger a peak speed test on my office Orb."

Your assistant will call the appropriate Orb MCP tool using the permissions associated with your connected Orb Cloud account or API key.

## Troubleshooting

### Client Can't Authenticate

- Confirm you're signing into Orb Cloud with the same account that has access to the Space you want to query
- Some clients require you to start a new chat session after configuring the MCP server
- If using an API key, confirm it hasn't been deleted or regenerated in the Orb Cloud [Orchestration](https://cloud.orb.net/orchestration) section
- For ChatGPT and Codex, confirm that the Orb Cloud API key is configured as a Bearer token rather than attempting an OAuth login

### No Devices or Data Returned

- Confirm your Orb Cloud account or API key has access to the Space containing the Orb
- If using an API key, confirm it has at least **Organizations: Read** and **Devices: Read** permissions

## Support

For additional help with the Orb Cloud MCP server:

- Join our [Discord community](https://discord.gg/orbforge)
- [Contact the Orb team](https://orb.net/contact)
- Visit the [Orb Cloud API](/docs/integrations/api) guide for details on the underlying API
