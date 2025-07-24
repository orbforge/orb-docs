---
title: Install Orb on macOS
shortTitle: macOS
metaDescription: Install the Orb sensor on macOS via Homebrew
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Install the Orb Sensor on macOS

## Installation

Setting up a macOS device as an Orb sensor can be done thanks to Homebrew with a single command:

```bash
brew install orbforge/orb/orb
```

If you don't have Homebrew installed, visit the [Homebrew site](https://brew.sh/) for up-to-date installation instructions. If you would prefer to run the Orb macOS app instead, view our [macOS installation guide](/docs/install-orb/macos.md).

## Usage

To start orbforge/orb/orb immediately and restart at login:

```bash
brew services start orbforge/orb/orb
```

If you don't want or need a background service or would like to use other CLI functions, you can run:

```bash
/opt/homebrew/opt/orb/bin/orb help
```

for a list of available commands.

## Orb CLI Commands 
The Orb CLI provides a set of commands to manage your Orb sensors and interact with your Orb account. Below are some common commands you can use:
```bash
  orb [command]
 ``` 

Available Commands:
```bash

  sensor      Run the Orb sensor
  listen      Connect to a running Orb service
  link        Link this Orb to an account
  version     Current version of Orb
  summary     Show the latest summary for this Orb
  help        This screen
Flags:
  -h, --help     help for example
  -r  --remote   connect to remote host
```

## Uninstalling Orb CLI

To uninstall the Orb CLI, you can use the following command in your terminal:
```bash
orb uninstall
```
This will remove the Orb CLI from your system.

For instructions on linking your Orb sensor to your account, refer to the [Linking an Orb to Your Account](/docs/orb-app/linking-orb-to-account.md) guide.
