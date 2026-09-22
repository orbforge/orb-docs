---
title: Microsoft Configuration Manager (SCCM)
shortTitle: Configuration Manager
metaDescription: Deploy the Orb sensor and the Orb app across your Windows fleet using Microsoft Configuration Manager (SCCM).
section: Deploy & Configure
---

# Deploy Orb on Windows using Microsoft Configuration Manager

This guide walks you through deploying Orb across a Windows fleet using Microsoft Configuration Manager (ConfigMgr, formerly SCCM). The guide covers:

1. Choosing between the Orb sensor and the Orb app
2. Building the deployment package and keeping your Deployment Token out of logs
3. Creating the Application and Script Installer deployment type
4. Configuring detection rules that work reliably
5. Deploying, verifying, and uninstalling

Requirements:

1. An Orb Cloud subscription
2. A Configuration Manager current branch site with a distribution point and management point
3. Windows devices with the ConfigMgr client installed, in a device collection
4. A [Deployment Token](/docs/deploy-and-configure/deployment-tokens) for your Space

## Which should I deploy?

Orb offers two Windows deliverables. They behave very differently under managed deployment, so choose deliberately.

| | Orb sensor | Orb app |
|---|---|---|
| Runs as | Windows service (`LocalSystem`) | User-session desktop app with a tray icon |
| Starts | Automatically at boot, before any user logs in | At user logon, once a startup entry exists |
| Needs a logged-in user | No | Yes |
| Best for | Unattended fleet monitoring, kiosks, point of sale, servers | Devices where a person wants the Orb UI |

:::info
For most managed deployments the **sensor** is the better fit: it runs as a service, starts before login, and reports continuously without anyone signing in. Deploy the app when users need the Orb interface on their own machine.
:::

:::warning
The sensor and the app both install to `C:\Program Files\Orb\Orb.exe`. **Do not deploy both to the same device** — each overwrites the other's executable, and a detection rule based on that file path cannot tell them apart. They also register separately with Orb Cloud, so a device running both appears twice in your Space.
:::

## Before you start

### Create a Deployment Token

Create a token in the [Orchestration](https://cloud.orb.net/orchestration) section of Orb Cloud. A Deployment Token links each Orb to your Space automatically, with no user interaction.

Use a **dedicated, revocable token per deployment** so you can attribute devices and revoke access without disrupting other rollouts.

### Allow PowerShell scripts to run

Both deployments below use PowerShell for installation and detection. Configuration Manager writes detection scripts to `C:\Windows\CCM\SystemTemp` and runs them, so the client must be allowed to execute them.

In the Configuration Manager console, go to **Administration → Client Settings**, edit your client settings, select **Computer Agent**, and set **PowerShell execution policy** to **Bypass**.

:::warning
If this is not set, installation succeeds but detection fails and the deployment reports an error. The symptom in `AppDiscovery.log` is:

```
PSSecurityException / UnauthorizedAccess
CScriptHandler::DiscoverApp failed (0x87d00327)
```

If detection still fails after changing the client setting, confirm the machine's own execution policy is not `Restricted` (`Get-ExecutionPolicy -List`).
:::

## Deploy the Orb sensor

### Prepare the package

Create a folder on your content source share, for example `\\server\Source$\Orb\OrbSensor`, containing:

```
OrbSensor\
  Install-OrbSensor.ps1
  Uninstall-OrbSensor.ps1
  Detect-OrbSensor.ps1
  deployment_token.txt
```

`deployment_token.txt` contains only your token, with no trailing newline:

```
orb-dt1-yourdeploymenttoken678
```

:::info
Shipping the token as a file in the package content keeps it out of your logs. A token passed on the deployment type's command line is written in clear text to `AppEnforce.log` on every client and is visible in the deployment type's properties in the console.
:::

**`Install-OrbSensor.ps1`** — writes the token, then runs the official installer:

```powershell
[CmdletBinding()]
param([string] $DeploymentToken)

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path "$env:ProgramData\Orb" -Force | Out-Null

if (-not $DeploymentToken) {
    $sidecar = Join-Path $PSScriptRoot 'deployment_token.txt'
    if (Test-Path $sidecar) { $DeploymentToken = (Get-Content $sidecar -Raw).Trim() }
}
if (-not $DeploymentToken) { exit 2 }

# Written before install so the service links on its first start.
Set-Content -Path "$env:ProgramData\Orb\deployment_token.txt" `
            -Value $DeploymentToken -NoNewline -Encoding ascii

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://pkgs.orb.net/install.ps1'))

$svc = Get-Service -Name 'Orb' -ErrorAction SilentlyContinue
if (-not $svc) { exit 1 }
if ($svc.Status -ne 'Running') { Start-Service Orb }

# Orb.exe carries no file version resource, so record the version for detection.
$ver = 'unknown'
try {
    $raw = (& 'C:\Program Files\Orb\Orb.exe' version 2>&1 | Out-String).Trim()
    if ($raw -match 'v?(\d+\.\d+\.\d+)') { $ver = $Matches[1] }
} catch { }
Set-Content -Path "$env:ProgramData\Orb\installed-version.txt" -Value $ver -NoNewline -Encoding ascii
exit 0
```

**`Detect-OrbSensor.ps1`** — detection must write to standard output only when the application is present:

```powershell
$MinVersion = '1.5.0'
$exe   = 'C:\Program Files\Orb\Orb.exe'
$stamp = "$env:ProgramData\Orb\installed-version.txt"

if (-not (Get-Service -Name 'Orb' -ErrorAction SilentlyContinue)) { exit 0 }
if (-not (Test-Path $exe)) { exit 0 }

$ver = $null
if (Test-Path $stamp) { $ver = (Get-Content $stamp -Raw).Trim().TrimStart('v') }
if (-not $ver) {
    try {
        $raw = (& $exe version 2>&1 | Out-String).Trim()
        if ($raw -match 'v?(\d+\.\d+\.\d+)') { $ver = $Matches[1] }
    } catch { }
}
if (-not $ver) { exit 0 }

try {
    if ([version]$ver -ge [version]$MinVersion) { Write-Output "Installed $ver" }
} catch { }
exit 0
```

:::note
`Orb.exe` does not carry a Windows file version resource, so a detection rule of the form *file exists and version is at least X* never matches. The install script records the version reported by `orb.exe version` to a file, and detection reads that — which keeps detection version-aware so supersedence and upgrades re-evaluate correctly.
:::

**`Uninstall-OrbSensor.ps1`** — removes the service and files directly:

```powershell
[CmdletBinding()]
param([switch] $PurgeData)

$ErrorActionPreference = 'Continue'
$svc = Get-Service -Name 'Orb' -ErrorAction SilentlyContinue
if ($svc) {
    Stop-Service -Name 'Orb' -Force -ErrorAction SilentlyContinue
    for ($i = 0; $i -lt 30 -and (Get-Service 'Orb' -EA SilentlyContinue).Status -ne 'Stopped'; $i++) {
        Start-Sleep -Seconds 1
    }
    & sc.exe delete 'Orb' | Out-Null
    Start-Sleep -Seconds 2
}
Get-Process -Name 'Orb' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Remove-Item 'C:\Program Files\Orb' -Recurse -Force -ErrorAction SilentlyContinue
Get-NetFirewallRule -DisplayName 'Orb*' -ErrorAction SilentlyContinue |
    ForEach-Object { Remove-NetFirewallRule -Name $_.Name -ErrorAction SilentlyContinue }

if ($PurgeData) { Remove-Item "$env:ProgramData\Orb" -Recurse -Force -ErrorAction SilentlyContinue }

if (Get-Service 'Orb' -ErrorAction SilentlyContinue) { exit 1 }
exit 0
```

:::warning
Do not use `install.ps1 -Uninstall` for unattended removal. That script prompts for confirmation and offers no switch to suppress it, so under Configuration Manager it waits for input that never arrives and the deployment fails with error `0x87d00213` after the deployment type's timeout expires, leaving Orb installed.
:::

### Create the Application

1. In the console, go to **Software Library → Application Management → Applications** and select **Create Application**.
2. Choose **Manually specify the application information**.
3. Name the application, for example `Orb Sensor`, and set the publisher and version.
4. On **Deployment Types**, select **Add** and choose **Script Installer**.
5. Set the **Content location** to your package folder, for example `\\server\Source$\Orb\OrbSensor`.
6. Set the installation and uninstall programs:

   **Installation program**

   ```
   powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Install-OrbSensor.ps1
   ```

   **Uninstall program**

   ```
   powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Uninstall-OrbSensor.ps1
   ```

7. On **Detection Method**, choose **Use a custom script to detect the presence of this deployment type**, set the script type to **PowerShell**, and paste the contents of `Detect-OrbSensor.ps1`.
8. On **User Experience**, set:
   - **Installation behavior**: *Install for system*
   - **Logon requirement**: *Whether or not a user is logged on*
   - **Installation program visibility**: *Hidden*

### Distribute and deploy

1. Right-click the application and select **Distribute Content**, then choose your distribution point.
2. Right-click the application and select **Deploy**, choose your device collection, set the **Purpose** to **Required**, and set the deadline.

The service installs and links to your Space with no user interaction and without anyone logging in.

## Deploy the Orb app

The app follows the same pattern, with two important differences: how it is detected, and making it start.

### Prepare the package

```
OrbApp\
  Orb-installer.exe
  Install-OrbApp.ps1
  Uninstall-OrbApp.ps1
  Detect-OrbApp.ps1
  deployment_token.txt
```

Download the installer from [https://pkgs.orb.net/earlyaccess/windows/Orb-installer.exe](https://pkgs.orb.net/earlyaccess/windows/Orb-installer.exe).

**`Install-OrbApp.ps1`**:

```powershell
[CmdletBinding()]
param([string] $DeploymentToken)

$ErrorActionPreference = 'Stop'

if (-not $DeploymentToken) {
    $sidecar = Join-Path $PSScriptRoot 'deployment_token.txt'
    if (Test-Path $sidecar) { $DeploymentToken = (Get-Content $sidecar -Raw).Trim() }
}
if (-not $DeploymentToken) { exit 2 }

$installer = Join-Path $PSScriptRoot 'Orb-installer.exe'
$args = @('/S', '/LAUNCH_AT_STARTUP=1', '/START_IN_BACKGROUND=1', "/ORB_DEPLOYMENT_TOKEN=$DeploymentToken")
$p = Start-Process -FilePath $installer -ArgumentList $args -Wait -PassThru
if ($p.ExitCode -ne 0) { exit 1 }

# Create the all-users startup entry so the app runs at each user's next logon.
$startupDir = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\StartUp'
New-Item -ItemType Directory -Path $startupDir -Force | Out-Null
$shell = New-Object -ComObject WScript.Shell
$lnk   = $shell.CreateShortcut((Join-Path $startupDir 'Orb.lnk'))
$lnk.TargetPath       = 'C:\Program Files\Orb\Orb.exe'
$lnk.WorkingDirectory = 'C:\Program Files\Orb'
$lnk.Save()
exit 0
```

:::warning
The startup shortcut step is required. A silent installation performed by Configuration Manager runs as `SYSTEM`, and `/LAUNCH_AT_STARTUP=1` on its own does not create a startup entry — it only records the preference under `HKLM\SOFTWARE\Orb\MDM`. Without the shortcut the app is installed but never runs, so it never links to Orb Cloud and does not appear in your Space until a user launches it manually.

Do not try to launch `Orb.exe` from the installation script instead. The script runs as `SYSTEM` in session 0, where the app has no visible interface.
:::

**`Detect-OrbApp.ps1`** — detect the app through its Add/Remove Programs entry:

```powershell
$MinVersion = '1.5.0'

$arp = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue |
       Where-Object { $_.DisplayName -eq 'Orb' -and $_.Publisher -like 'Orb Forge*' } |
       Select-Object -First 1

if (-not $arp) { exit 0 }
if (-not (Test-Path 'C:\Program Files\Orb\Orb.exe')) { exit 0 }

try {
    if ([version]$arp.DisplayVersion -ge [version]$MinVersion) { Write-Output "Installed $($arp.DisplayVersion)" }
} catch { }
exit 0
```

:::note
Detect the app through its Add/Remove Programs entry rather than the presence of `C:\Program Files\Orb\Orb.exe`. The sensor installs to that same path, so a file-based rule cannot distinguish the two, and `Orb.exe` has no version resource to compare. The Add/Remove Programs entry carries a version, and the sensor does not create one.
:::

**`Uninstall-OrbApp.ps1`**:

```powershell
$ErrorActionPreference = 'Continue'

$lnk = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\StartUp\Orb.lnk'
if (Test-Path $lnk) { Remove-Item $lnk -Force -ErrorAction SilentlyContinue }

Get-Process Orb -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

$un = 'C:\Program Files\Orb\uninstall.exe'
if (Test-Path $un) { Start-Process -FilePath $un -ArgumentList '/S' -Wait }
exit 0
```

:::warning
Use the full path `"C:\Program Files\Orb\uninstall.exe" /S`. A relative `uninstall.exe /S` fails under Configuration Manager because the working directory is the content cache folder, not the installation directory.
:::

### Create and deploy

Follow the same steps as the sensor, using:

**Installation program**

```
powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Install-OrbApp.ps1
```

**Uninstall program**

```
powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Uninstall-OrbApp.ps1
```

Use the same **Install for system**, **Whether or not a user is logged on**, and **Hidden** settings.

The app installs silently and starts at each user's next logon, then links to your Space using the token.

## Verify the deployment

In the console, select the application and review **Deployments** for installation status.

On a target device:

```powershell
# Sensor
Get-Service Orb

# App
Get-Process Orb
```

In [Orb Cloud](https://cloud.orb.net), confirm the device appears in your Space and is reporting.

Useful client logs, in `C:\Windows\CCM\Logs`:

| Log | Shows |
|---|---|
| `AppEnforce.log` | Installation and uninstallation, including exit codes |
| `AppDiscovery.log` | Detection script results |
| `AppIntentEval.log` | What the client has been told to install or remove |
| `DataTransferService.log` | Content download |

## Update Orb

A device updates when the installer runs on it again. Configuration Manager will not run the installer on a device that already detects as installed, so raising the version in the detection script is what triggers an update.

The two packages pin versions differently:

| | Where the version comes from |
|---|---|
| **Sensor** | The installer downloads the current published version at install time, so the package does not pin a version |
| **App** | The `Orb-installer.exe` you placed in the package source — to move to a newer version, download it again and replace that file |

To roll out an update:

1. For the app, replace `Orb-installer.exe` in your package source with the new download.
2. Set `$MinVersion` in `Detect-OrbSensor.ps1` (or `Detect-OrbApp.ps1`) to the version you expect devices to reach.
3. **Update Distribution Points** on the deployment type, so clients download the changed content.
4. At the next evaluation, devices below that version detect as **not installed**, the installer runs again, and Orb is upgraded in place.

Installing over an existing Orb upgrades it and keeps the device's identity: it returns to your Space as the **same Orb**, not a duplicate.

For a stricter change-controlled rollout, create a separate application for the new version and configure **supersedence** on it, which lets you pilot the new version on one collection before it replaces the old one everywhere.

:::warning
Clients cache package content. After changing scripts in the package source, a client may continue to run its cached copy, and the deployment will still report success. Raising `$MinVersion` as described above also changes the detection script, which is what makes clients pick up the new content; otherwise clear the client cache.
:::

### Automatic updates

[Install Orb on Windows](/docs/setup-sensor/windows) describes an optional **Orb Auto-Update** scheduled task that re-runs the sensor installer daily.

Do not deploy that task to devices you manage with Configuration Manager. Devices would move to new versions on their own schedule, outside your change control, and the version Configuration Manager reports would no longer reflect what is deployed. Manage versions through the deployment instead, using the steps above.

### Verify an update

On a device that has been updated:

```powershell
# Sensor — the version the service is running
& 'C:\Program Files\Orb\Orb.exe' version

# App — the version in Add/Remove Programs
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object DisplayName -eq 'Orb' | Select-Object DisplayName, DisplayVersion
```

In [Orb Cloud](https://cloud.orb.net), confirm the device is still reporting and that no duplicate appeared in your Space.

## Uninstall Orb

Change the deployment's **Action** from **Install** to **Uninstall**, or create a new deployment with the **Uninstall** action against the target collection.

Uninstalling the sensor removes the service, the executable and the firewall rule, but leaves `C:\ProgramData\Orb` in place. That folder holds the sensor's identity and Deployment Token, which is what allows a reinstall to return as the same Orb rather than creating a duplicate in your Space.

:::warning
When you decommission or repurpose a device, remove `C:\ProgramData\Orb` as well. It contains the Deployment Token and the sensor's private key. Pass `-PurgeData` to the uninstall script to remove it — note that a later installation then enrolls as a new Orb.
:::

## Troubleshooting

### The application installs but reports as failed

Detection is failing. Check `AppDiscovery.log`. If you see `0x87d00327` with `PSSecurityException`, set the **PowerShell execution policy** client setting to **Bypass** as described above.

### The app is installed but does not appear in Orb Cloud

The app only reports while it is running, and it runs only in a user session. Confirm that `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Orb.lnk` exists and that a user has logged on since installation.

The sensor does not have this constraint: it runs as a service and reports without anyone logging in.

### Orb does not link to my Space

1. Confirm `C:\ProgramData\Orb\deployment_token.txt` exists (sensor), or that `HKLM\SOFTWARE\Orb\MDM\OrbDeploymentToken` is set (app).
2. Confirm the token is still valid in [Orchestration](https://cloud.orb.net/orchestration).
3. Confirm the device can reach the internet.

### Changes to my package scripts have no effect

The client is running cached content. See [Update Orb](#update-orb).

## Additional configuration

Both deliverables support the configuration options described in [Orb Configuration](/docs/deploy-and-configure/configuration). For the sensor, set options as service environment variables as described in [Install Orb on Windows](/docs/setup-sensor/windows). For the app, MDM settings are read from `HKLM\SOFTWARE\Orb\MDM`.
