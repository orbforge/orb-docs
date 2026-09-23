---
title: Microsoft Configuration Manager (SCCM)
shortTitle: Configuration Manager
metaDescription: Deploy the Orb sensor and the Orb app across your Windows fleet using Microsoft Configuration Manager (SCCM).
section: Deploy & Configure
---

# Deploy Orb on Windows using Microsoft Configuration Manager

This guide walks you through deploying Orb across a Windows fleet using Microsoft Configuration Manager (ConfigMgr, formerly SCCM). The guide covers:

1. Choosing between the Orb sensor and the Orb app
2. Building the content source and keeping your Deployment Token out of logs
3. Creating the Application and its deployment type
4. Deploying, verifying, updating and uninstalling
5. The files and processes to allow-list in endpoint security tools

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
| Installer | Windows Installer package (`.msi`) | `Orb-installer.exe` |
| Best for | Unattended fleet monitoring, kiosks, point of sale, servers | Devices where a person wants the Orb UI |

:::info
For most managed deployments the **sensor** is the better fit. It ships as an MSI, so Configuration Manager detects it by product code, generates its own uninstall command, and needs no scripts at all. It also runs as a service, so it starts before login and reports continuously without anyone signing in.
:::

:::warning
The sensor and the app register with Orb Cloud separately, so a device running both appears **twice** in your Space, under the same hostname. Deploy one or the other unless you specifically want both.
:::

## Before you start

Create a Deployment Token in the [Orchestration](https://cloud.orb.net/orchestration) section of Orb Cloud. A Deployment Token links each Orb to your Space automatically, with no user interaction.

Use a **dedicated, revocable token per deployment** so you can attribute devices and revoke access without disrupting other rollouts.

## Deploy the Orb sensor

### Prepare the content source

Create a folder on your content source share, for example `\\server\Source$\Orb\OrbSensor`, containing the sensor MSI and your token:

```
OrbSensor\
  orb-sensor.msi
  deployment_token.txt
```

`deployment_token.txt` contains only your token, with no trailing newline:

```
orb-dt1-yourdeploymenttoken678
```

:::info
Ship the token as a file in the content source rather than on the command line. Configuration Manager writes the full command line to `AppEnforce.log` on every client and shows it in the deployment type's properties in the console. A token supplied by file appears in neither, and the MSI keeps it out of its own log as well.
:::

### Create the Application

1. In the console, go to **Software Library → Application Management → Applications** and select **Create Application**.
2. Leave **Automatically detect information about this application from installation files** selected, set **Type** to **Windows Installer (\*.msi file)**, and set the location to the MSI on your share, for example `\\server\Source$\Orb\OrbSensor\orb-sensor.msi`.
3. Select **Next**. Configuration Manager reads the package, fills in the name, publisher and version, and creates the detection rule from the MSI **product code**.
4. On **General Information**, set the installation program so it reads the token from the content:

   ```
   msiexec /i "orb-sensor.msi" /q DEPLOYMENTTOKENFILE=deployment_token.txt
   ```

   Set **Install behavior** to **Install for system**.
5. Complete the wizard.

Open the deployment type's properties and confirm two settings on the **User Experience** tab:

- **Logon requirement**: *Whether or not a user is logged on*
- **Installation program visibility**: *Hidden*

On the **Programs** tab, the uninstall program is already filled in from the package:

```
msiexec /x {ProductCode} /q
```

:::note
Because the sensor ships as an MSI, this deployment needs **no scripts**: no installation wrapper, no detection script, and no client setting to allow PowerShell to run. Configuration Manager derives both detection and removal from the package itself, which is also what makes upgrades and supersedence behave predictably.
:::

### Distribute and deploy

1. Right-click the application and select **Distribute Content**, then choose your distribution point.
2. Right-click the application and select **Deploy**, choose your device collection, set the **Purpose** to **Required**, and set the deadline.

The service installs and starts, then links to your Space with no user interaction and without anyone logging in. The MSI installs the `Orb` service as `LocalSystem` with start type **Automatic** and configures it to restart on failure, so it also returns after every reboot with nothing further to configure.

### Configuration properties

Set any of these as `PROPERTY=value` pairs on the installation program. They are persisted, so they survive upgrades.

| Property | Effect |
|---|---|
| `DEPLOYMENTTOKENFILE` | Path to a token file in the content source. Relative paths resolve against the package. |
| `DEPLOYMENTTOKEN` | The token itself. Kept out of the MSI log, but recorded in `AppEnforce.log` — prefer the file. |
| `ORB_DEVICE_NAME_OVERRIDE` | Name the device reports in your Space. Quote values containing spaces. |
| `AUTOUPDATE` | `1` lets the sensor update itself on a schedule. Defaults to `0` when installed from the MSI, which is what you want when Configuration Manager manages versions. |
| `PURGEDATA` | Uninstall only. `1` also removes `C:\ProgramData\Orb` — see [Uninstall Orb](#uninstall-orb). |

Other sensor options from [Orb Configuration](/docs/deploy-and-configure/configuration) are available as properties of the same name, including `ORB_FIRSTHOP_DISABLED`, `ORB_BANDWIDTH_DISABLED`, `ORB_EPHEMERAL_MODE`, `ORB_MEASURE_SERVER_ENABLED` and `ORB_MEASURE_SERVER_PORT`.

:::note
Changing a property and redeploying applies the new value. Removing a property from the command line does **not** clear it — the previous value is kept, by design, so that settings survive upgrades. To clear a setting, uninstall and reinstall.
:::

### Migrating from a scripted sensor installation

If your devices already run a sensor installed by script, the MSI takes over the existing service in place, keeps the device's identity, and removes the old executable, its folder and its firewall rule. Each device stays the same Orb in your Space.

To migrate, configure the MSI application to **supersede** the older application and leave **Uninstall** unchecked, because the MSI replaces the old installation in place.

:::warning
Delete any existing **Uninstall** deployment of the script-based application first. Its detection rule looks for the `Orb` service and `C:\Program Files\Orb\Orb.exe`. On a device that has the MSI sensor, that rule can match and remove the service the MSI just installed.
:::

[Install Orb on Windows](/docs/setup-sensor/windows) describes an optional **Orb Auto-Update** scheduled task for scripted installations. The MSI removes that task if it finds it. Do not recreate it on devices you manage with Configuration Manager: it would replace files owned by the installer, after which the version Configuration Manager reports would no longer match what is running.

## Deploy the Orb app

The app has no MSI, so it is deployed as a script installer. It also needs a startup entry that its silent installation does not create.

### Allow PowerShell scripts to run

The app's deployment type uses PowerShell for installation and detection. Configuration Manager writes detection scripts to `C:\Windows\CCM\SystemTemp` and runs them, so the client must be allowed to execute them.

In the console, go to **Administration → Client Settings**, edit your client settings, select **Computer Agent**, and set **PowerShell execution policy** to **Bypass**.

:::warning
If this is not set, installation succeeds but detection fails and the deployment reports an error. The symptom in `AppDiscovery.log` is:

```
PSSecurityException / UnauthorizedAccess
CScriptHandler::DiscoverApp failed (0x87d00327)
```

If detection still fails after changing the client setting, confirm the machine's own execution policy is not `Restricted` (`Get-ExecutionPolicy -List`).
:::

### Prepare the content source

```
OrbApp\
  Orb-installer.exe
  Install-OrbApp.ps1
  Uninstall-OrbApp.ps1
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
$flags = @('/S', '/LAUNCH_AT_STARTUP=1', '/START_IN_BACKGROUND=1', "/ORB_DEPLOYMENT_TOKEN=$DeploymentToken")
$p = Start-Process -FilePath $installer -ArgumentList $flags -Wait -PassThru
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
The startup shortcut step is required. Configuration Manager installs as `SYSTEM`, and `/LAUNCH_AT_STARTUP=1` on its own creates no startup entry — it only records the preference under `HKLM\SOFTWARE\Orb\MDM`. Without the shortcut the app is installed but never runs, so it never links to Orb Cloud and does not appear in your Space until each user launches it by hand.

Do not launch `Orb.exe` from the installation script instead. The script runs as `SYSTEM` in session 0, where the app has no visible interface.
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

### Create the Application

1. Select **Create Application** and choose **Manually specify the application information**.
2. Name the application, for example `Orb App`, and set the publisher and version.
3. On **Deployment Types**, select **Add** and choose **Script Installer**.
4. Set the **Content location** to your package folder, for example `\\server\Source$\Orb\OrbApp`.
5. Set the programs:

   **Installation program**

   ```
   powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Install-OrbApp.ps1
   ```

   **Uninstall program**

   ```
   powershell.exe -ExecutionPolicy Bypass -NoProfile -File .\Uninstall-OrbApp.ps1
   ```

6. On **Detection Method**, choose **Use a custom script to detect the presence of this deployment type**, set the script type to **PowerShell**, and paste:

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

7. On **User Experience**, set **Installation behavior** to *Install for system*, **Logon requirement** to *Whether or not a user is logged on*, and **Installation program visibility** to *Hidden*.

:::note
Detect the app through its Add/Remove Programs entry rather than the presence of `C:\Program Files\Orb\Orb.exe`. The app's `Orb.exe` carries no version resource, so no version rule is possible on the file. The Add/Remove Programs entry carries a version and is unambiguous.
:::

:::warning
If you deploy the installer directly rather than through the wrapper, use the full path in the uninstall command: `"C:\Program Files\Orb\uninstall.exe" /S`. A relative `uninstall.exe /S` fails, because the working directory is the client's content cache rather than the installation directory.
:::

Distribute the content and deploy it the same way as the sensor.

## Verify the deployment

In the console, select the application and review **Deployments** for installation status.

On a target device:

```powershell
# Sensor
Get-Service Orb
& 'C:\Program Files\Orb Sensor\Orb.exe' version

# App
Get-Process Orb
```

In [Orb Cloud](https://cloud.orb.net), confirm the device appears in your Space and is reporting.

Useful client logs, in `C:\Windows\CCM\Logs`:

| Log | Shows |
|---|---|
| `AppEnforce.log` | Installation and uninstallation, including exit codes |
| `AppDiscovery.log` | Detection results |
| `AppIntentEval.log` | What the client has been told to install or remove |
| `DataTransferService.log` | Content download |

For the sensor, add `/l*v C:\Windows\Temp\orb-sensor.log` to the installation program while troubleshooting, to capture a verbose Windows Installer log.

## Update Orb

**Sensor.** Import the newer MSI as a new application, configure it to **supersede** the current one with **Uninstall** unchecked, and deploy it. Windows Installer performs a major upgrade in place, and product-code detection reports the new version automatically.

Upgrading keeps the device's identity: it stays the **same Orb** in your Space rather than appearing as a duplicate, and its Deployment Token and configuration properties are preserved.

**App.** Replace `Orb-installer.exe` in the content source, update the distribution points, and raise `$MinVersion` in the detection script so clients re-evaluate.

:::warning
Clients cache package content. After changing files in the content source, a client may keep running its cached copy while the deployment still reports success. Updating distribution points alone is not always enough — changing the detection script, or clearing the client cache, is what makes clients pick up new content.
:::

## Uninstall Orb

Change the deployment's **Action** from **Install** to **Uninstall**, or create a new deployment with the **Uninstall** action against the target collection.

Uninstalling the sensor removes the service, the program folder, the firewall rule and the Add/Remove Programs entry, and leaves `C:\ProgramData\Orb` in place. That folder holds the sensor's identity and Deployment Token, which is what allows a reinstall to return as the same Orb rather than creating a duplicate in your Space.

:::warning
When you decommission or repurpose a device, remove `C:\ProgramData\Orb` as well. It contains the Deployment Token and the sensor's private key. Add `PURGEDATA=1` to the uninstall program to remove it — note that a later installation then enrolls as a **new** Orb:

```
msiexec /x {ProductCode} /q PURGEDATA=1
```
:::

## Files and processes for endpoint security

Use this section to allow-list the Orb sensor in antivirus, EDR, application control (AppLocker, WDAC) and data loss prevention tools. It describes what the sensor MSI installs and what the sensor writes while it runs. It covers the sensor only, not the Orb app.

### Code signing

The MSI, `Orb.exe` and `update.ps1` are all Authenticode-signed with Orb Forge's EV code-signing certificate:

| Field | Value |
|---|---|
| Subject | `CN=Orb Forge Inc, O=Orb Forge Inc, SERIALNUMBER=7541876, L=Wilmington, S=Delaware, C=US` |
| Issuer | `CN=SSL.com EV Code Signing Intermediate CA RSA R3, O=SSL Corp` |

Allow by **publisher** (`O=Orb Forge Inc`) rather than by file hash or certificate thumbprint. The hash changes with every release and the thumbprint changes each time the certificate is renewed. The subject stays the same.

### Processes

| Process | Runs as | When |
|---|---|---|
| `C:\Program Files\Orb Sensor\Orb.exe windowsservice` | `LocalSystem` (service `Orb`) | Continuously, from boot. Restarts itself 60 seconds after a failure. Starts no child processes. |
| `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "C:\Program Files\Orb Sensor\update.ps1"` | `SYSTEM`, from the scheduled task **Orb Sensor Update** | Every 4 hours, only when installed with `AUTOUPDATE=1`. |
| `msiexec.exe /i <downloaded MSI> /qn /norestart` | `SYSTEM` | Only when `update.ps1` finds a newer release. It starts `msiexec` through WMI (`Win32_Process.Create`) so the upgrade survives removal of the task it runs under. EDR tools that flag WMI process creation will report this. |

During installation and uninstallation, Windows Installer also runs the package's custom-action DLLs from `C:\Windows\Installer\MSI*.tmp`, and calls `schtasks.exe` and `netsh.exe` to manage the update task and remove legacy firewall rules.

### Files

**Program files**, installed and removed by the MSI:

| Path | Purpose |
|---|---|
| `C:\Program Files\Orb Sensor\Orb.exe` | The sensor service and the `orb` command-line tool. |
| `C:\Program Files\Orb Sensor\update.ps1` | Self-updater. Installed every time, but only scheduled when `AUTOUPDATE=1`. It checks `HKLM\SOFTWARE\Orb\Sensor\AutoUpdate` on each run and exits if updates are off. |

**Data**, in `C:\ProgramData\Orb`. The service writes these files as `SYSTEM`. The folder is kept on uninstall unless you pass `PURGEDATA=1`.

| Path | Purpose | Sensitive |
|---|---|---|
| `deployment_token.txt` | Your Deployment Token. Written by the MSI during installation from `DEPLOYMENTTOKEN` or `DEPLOYMENTTOKENFILE`, and read by the service to link to your Space. | **Yes** |
| `private.key` | The Orb's private key (ECC, PEM). This is the device's identity in Orb Cloud. | **Yes** |
| `certificate.crt` | Client certificate for that key, issued by *Orb Intermediate CA*. Valid for 7 days and renewed automatically, so expect this file to be rewritten about once a week. | No |
| `remoteconfig.json` | Local copy of the configuration pushed from Orb Cloud. | No |
| `orbstore\filestore\` | Local measurement database. It holds `catalog.json`, a `filestore.lock`, and one folder per dataset (for example `scores_1m`, `responsiveness_1s`, `speed_results`), partitioned by day into `.jsonl` files that are compressed to `.jsonl.gz`. Written continuously. | No |
| `spool\` | Queue for results that are waiting to be sent to Orb Cloud. | No |
| `logs\orb_YYYY-MM-DD.log` | Daily sensor log, one JSON object per line. | No |

On a test device, the folder grew to about 70 MB in its first day.

**Updater working files**, only present when `AUTOUPDATE=1`:

| Path | Purpose |
|---|---|
| `C:\Windows\Temp\OrbSensorUpdate-<random>\` | Created for each update check, accessible only to `SYSTEM` and Administrators. Holds the downloaded MSI, `update.log` and `msiexec.log`. Folders older than 7 days are removed on the next run. |

The updater downloads only from `https://pkgs.orb.net/stable/windows/latest/` (`version.txt` and `orb-sensor-amd64.msi`). It refuses to install any file whose Authenticode signature does not match the subject above.

### Registry, firewall and scheduled task

| Item | Purpose |
|---|---|
| `HKLM\SYSTEM\CurrentControlSet\Services\Orb` | The service definition. |
| `HKLM\SOFTWARE\Orb\Sensor` | `Version` and `AutoUpdate`, read by `update.ps1`. `LegacyCleanup` marks that a scripted installation was migrated. |
| `HKLM\SOFTWARE\Orb\Sensor\Environment` | The [configuration properties](#configuration-properties) you set on the MSI, kept here so they survive upgrades. |
| Firewall rule **Orb Sensor** | Inbound, all profiles, for `Orb.exe` only. The sensor listens on TCP `7080` (the [local Data API](/docs/deploy-and-configure/datasets-configuration)) and TCP/UDP `7443` (the [measurement endpoint](/docs/deploy-and-configure/endpoints)). |
| Scheduled task **Orb Sensor Update** | Present only with `AUTOUPDATE=1`. Runs `update.ps1` as `SYSTEM` every 4 hours. |

### Recommendations

- **Treat `deployment_token.txt` and `private.key` as secrets.** Anyone who has them can link a device to your Space, or impersonate this Orb. Keep them out of backups and support bundles that leave the device, and rotate the token in [Orchestration](https://cloud.orb.net/orchestration) if it leaks.
- **Exclude `C:\ProgramData\Orb\orbstore` from real-time scanning** if scanning causes high CPU. The sensor writes many small files there continuously. Leave the rest of `C:\ProgramData\Orb` monitored.
- **Do not quarantine or block `update.ps1`** on devices where you install with `AUTOUPDATE=1`. If Configuration Manager manages versions, leave `AUTOUPDATE` at `0` and the script never runs.

## Troubleshooting

### The application installs but reports as failed

Detection is failing. For the sensor, confirm the deployment type's detection rule is the **product code** of the package you deployed; a new version has a new product code. For the app, check `AppDiscovery.log`, and if you see `0x87d00327` with `PSSecurityException`, set the **PowerShell execution policy** client setting to **Bypass** as described above.

### The app is installed but does not appear in Orb Cloud

The app only reports while it is running, and it runs only in a user session. Confirm that `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Orb.lnk` exists and that a user has logged on since installation.

The sensor does not have this constraint: it runs as a service and reports without anyone logging in.

### Orb does not link to my Space

1. Confirm `C:\ProgramData\Orb\deployment_token.txt` exists (sensor), or that `HKLM\SOFTWARE\Orb\MDM\OrbDeploymentToken` is set (app).
2. Confirm the token is still valid in [Orchestration](https://cloud.orb.net/orchestration).
3. Confirm the device can reach the internet.

If the token was rejected, the sensor MSI fails the installation immediately with `1603` and gives the reason in its verbose log, rather than installing a sensor that never links. If Orb Cloud is merely unreachable, installation succeeds and the device links when it next has connectivity.

## Additional configuration

Both deliverables support the configuration options described in [Orb Configuration](/docs/deploy-and-configure/configuration). For the sensor, set them as MSI properties as described above. For the app, MDM settings are read from `HKLM\SOFTWARE\Orb\MDM`, where `OrbDeviceNameOverride` sets the name the device reports in your Space.

To deploy Orb with Microsoft Intune instead, see [Microsoft Intune](/docs/deploy-and-configure/mdm/intune).
