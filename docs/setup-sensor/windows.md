---
title: Install Orb on Windows
shortTitle: Windows
metaDescription: Run the Orb sensor as a background Windows service for continuous network monitoring.
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Install the Orb Sensor on Windows

## Installation

Setting up a Windows device as an Orb sensor allows you to run continuous network monitoring as a background service.

### Download

Download the Orb CLI for Windows from our Early Access page:

[Download Orb CLI for Windows](https://orb.net/the-forge/early-access/orb-cli-for-windows)

:::note
The Orb CLI for Windows is currently Early Access software.
:::

After downloading, extract `orb.exe` to a permanent location on your system (e.g., `C:\Program Files\Orb\orb.exe`).

## Setting Up as a Windows Service

You can install Orb as a Windows service using either PowerShell or the `sc.exe` command.

### Option 1: Using PowerShell (Recommended)

Open PowerShell as Administrator and run:

```powershell
New-Service -Name "Orb" -BinaryPathName "C:\Program Files\Orb\orb.exe windowsservice" -DisplayName "Orb Sensor Service" -StartupType Automatic
```

Replace `C:\Program Files\Orb\orb.exe` with the actual path where you placed the Orb executable.

### Option 2: Using sc.exe

Open Command Prompt as Administrator and run:

```cmd
sc.exe create Orb binPath= "C:\Program Files\Orb\orb.exe windowsservice" DisplayName= "Orb Sensor Service" start= auto
```

:::warning
Note the space after `binPath=`, `DisplayName=`, and `start=` in the `sc.exe` command. This is required syntax.
:::

## Starting the Service

After creating the service, start it using:

**PowerShell:**
```powershell
Start-Service -Name "Orb"
```

**Command Prompt:**
```cmd
sc.exe start Orb
```

The service will now start automatically on system boot.

## Data Storage

When running as LocalSystem (the default), Orb saves data in:

```
C:\ProgramData\Orb
```

## Configuring the Orb Sensor
You can configure the Orb sensor with any options from [Orb Configuration](/docs/deploy-and-configure/configuration) docs.

### Environment Variables
To set environment variables for the Orb sensor Windows Service, you can use the `New-ItemProperty` cmdlet in PowerShell.


Example with `ORB_FIRSTHOP_DISABLED` and `ORB_DEPLOYMENT_TOKEN` environment variables:
```powershell
New-ItemProperty `
  -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Orb" `
  -Name "Environment" `
  -PropertyType MultiString `
  -Value @("ORB_FIRSTHOP_DISABLED=1", "ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678")
```

### Using Deployment Tokens

You can automatically link your Orb sensor to your Orb Cloud Space using a deployment token. This is especially useful for deploying multiple sensors or automating setup.

To use a deployment token, you can use the [Environment Variables](#environment-variables) approach above to set `ORB_DEPLOYMENT_TOKEN`, or create a file named `deployment_token.txt` in the Orb configuration directory containing your token:

```cmd
echo orb-dt1-yourdeploymenttoken678 > C:\ProgramData\Orb\deployment_token.txt
```

Replace `orb-dt1-yourdeploymenttoken678` with your actual deployment token from the [Orchestration](https://cloud.orb.net/orchestration) section of Orb Cloud.

When the Orb service starts, it will automatically read this file and link to your Space.

For more details on deployment tokens and other linking methods, see the [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens) guide.

## Orb CLI Commands

The Orb CLI provides a set of commands to manage your Orb sensors and interact with your Orb account. To use these commands, run `orb.exe` directly (not as a service):

```cmd
orb.exe [command]
```

Available Commands:
```
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

## Managing the Service

### Stop the Service

**PowerShell:**
```powershell
Stop-Service -Name "Orb"
```

**Command Prompt:**
```cmd
sc.exe stop Orb
```

### Check Service Status

**PowerShell:**
```powershell
Get-Service -Name "Orb"
```

**Command Prompt:**
```cmd
sc.exe query Orb
```

### Uninstall the Service

First, stop the service, then remove it:

**PowerShell:**
```powershell
Stop-Service -Name "Orb"
Remove-Service -Name "Orb"
```

**Command Prompt:**
```cmd
sc.exe stop Orb
sc.exe delete Orb
```

## Troubleshooting

If the service fails to start:

1. Verify the path to `orb.exe` is correct in the service configuration
2. Check that `orb.exe` has the necessary permissions
3. Review Windows Event Viewer for error messages (Windows Logs → Application)
4. Ensure no other application is using the required network ports

For instructions on linking your Orb sensor to your account, refer to the [Linking an Orb to Your Account](/docs/orb-app/linking-orb-to-account.md) guide.
