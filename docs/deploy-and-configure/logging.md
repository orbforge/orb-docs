---
title: Orb logging
shortTitle: Logging
metaDescription: Find Orb sensor logs, set the log level for each output, and filter debug messages by subsystem.
section: Deploy & Configure
---

# Orb logging

Orb logs record sensor activity, including startup, measurements, and errors. You can read recent messages on the sensor, save them to disk, and choose how much detail each output receives.

## Read sensor logs

On the sensor host, run `orb logs` as the user running Orb. On a standard Debian installation, use `sudo -u orb -H orb logs`. The command prints up to 50 recent messages from the Sensor API, then prints new messages as they arrive. Press Ctrl+C to stop. Restarting Orb clears this in-memory history.

Each JSON log entry has a timestamp (`time`), severity (`level`), and message (`msg`). Other fields give details about that event.

You can also read the service journal, container output, or local files for your installation.

| Installation | Where to read logs |
| --- | --- |
| Linux with systemd | Run `sudo journalctl -u orb -f` to follow the service. To inspect an earlier problem, use a time range such as `sudo journalctl -u orb --since "1 hour ago"`. |
| Docker Compose | Run `docker compose logs -f orb-docker` in the directory with Orb's Compose file. Substitute your service name if you changed it. |
| Podman | Run `podman logs -f orb-sensor` with the name of your Orb container. |
| OpenWrt | Run `logread -e orb` to see Orb's syslog messages. |
| macOS Sensor app | Open the newest `orb_*.log` file in `~/.config/orb/logs/` for the user running the sensor. |
| Windows Sensor service | Open the newest `orb_*.log` file in `C:\ProgramData\Orb\logs`. |

## Set console and file log levels

Each output has its own minimum level. From least to most severe, the levels are `debug`, `info`, `warn`, and `error`. For example, `warn` includes warnings and errors. Use `info` for routine activity and `debug` for details about a specific problem.

| Output | Minimum level setting | Default for the command-line sensor |
| --- | --- | --- |
| Console | `ORB_LOG_CONSOLE_LEVEL` | On at `info`, in text format |
| Local files | `ORB_LOG_FILE_LEVEL` | Off except on Windows. When enabled, files default to `info` in JSON format. |

The macOS Sensor app enables file logging and disables console logging by default. Use `ORB_LOG_CONSOLE_ENABLED` and `ORB_LOG_FILE_ENABLED` to turn either output on or off. For example, `ORB_LOG_CONSOLE_ENABLED=true` turns on console logging. Setting `DEBUG=1` sets the minimum level to `debug` for every enabled output.

Set these variables in the sensor's environment and restart it to apply changes. For Docker Compose, edit the service's `environment` section and run `docker compose up -d` to recreate the container. Environment settings apply when the sensor's remote configuration allows local overrides.

## Save logs to a file

To save warnings and errors locally, set these variables in the sensor's environment.

```ini
ORB_LOG_FILE_ENABLED=true
ORB_LOG_FILE_LEVEL=warn
```

Orb writes one JSON object per line in the `logs` folder under its configuration directory. On a standard Debian package installation, that folder is `/home/orb/.config/orb/logs/`. Orb skips file logging in ephemeral mode (`ORB_EPHEMERAL_MODE=1`).

Files use the name `orb_YYYY-MM-DD.log` and rotate daily or at about 1 MiB. Additional files for the same date have a numbered suffix, such as `-1.log`. Orb keeps the two most recently modified log files.

Set `ORB_LOG_FILE_FORMAT=text` for plain text. Set `ORB_LOG_CONSOLE_FORMAT` to `text` or `json` to write to standard error. On Unix, use `syslog` to write to the system log.

## Filter debug logs by subsystem

To show Wi-Fi and speed test details in the console on a Debian sensor, add these settings to `/etc/default/orb`.

```ini
ORB_LOG_CONSOLE_LEVEL=debug
ORB_LOG_CONSOLE_DEBUG=wifi,bandwidth
```

Run `sudo systemctl restart orb`, then `sudo journalctl -u orb -f`. Look for `subsystem=wifi` or `subsystem=bandwidth` as Orb reports Wi-Fi details or runs a speed test. Info, warning, and error messages from any subsystem still appear. To return to your usual logging, remove the example settings and restart Orb.

Filters apply to messages at DEBUG level and below. The output must be enabled and its minimum level must allow debug messages. Each output inherits `ORB_LOG_DEBUG` unless it has its own filter. The default is `all`.

| Output | Environment variable | Shared configuration key |
| --- | --- | --- |
| Default for all outputs | `ORB_LOG_DEBUG` | `logging.debug` |
| Console (including syslog) | `ORB_LOG_CONSOLE_DEBUG` | `logging.console.debug` |
| Rotating log files | `ORB_LOG_FILE_DEBUG` | `logging.file.debug` |

For a named instance, include its name after `ORB_`. For example, `ORB_WIRED_LOG_CONSOLE_DEBUG=network` sets the console filter for the `wired` instance.

### Filter values

| Value | Debug messages included |
| --- | --- |
| `all` | Every debug message, including those without a subsystem. |
| `none` | No debug messages. |
| One or more subsystem names, such as `wifi,bandwidth` | Only messages tagged with a listed subsystem. |

Use `all` and `none` on their own. Subsystem names are case-sensitive, and spaces around names are optional. Orb warns about unknown names or empty entries and uses the valid names in the list. A list with no valid names suppresses all debug messages for that output.

### Subsystem names

The `subsystem` field identifies the source of a tagged debug message, even when the filter is `all`.

| Name | What it covers |
| --- | --- |
| `api` | Sensor API requests and logs submitted through the API |
| `bandwidth` | Speed tests, time to first byte, measurement servers, and cached speed results |
| `cloud` | Orb Cloud connections, authentication, certificates, and report uploads |
| `core` | Orb startup, configuration, shutdown, and retries |
| `hardware` | Device information, battery status, and system telemetry |
| `network` | Network interfaces, public IP addresses, geolocation, service discovery, and Orbit devices |
| `responsiveness` | Pings, first-hop discovery, latency, packet loss, and reliability |
| `storage` | Dataset storage, archiving, and retention |
| `teleport` | Teleport sessions and WebRTC connections |
| `wifi` | Wi-Fi connections, nearby access points, signal measurements, and Wi-Fi permissions |
