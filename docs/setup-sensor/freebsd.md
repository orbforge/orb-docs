---
title: Install Orb on FreeBSD
shortTitle: FreeBSD
metaDescription: Install the Orb sensor on FreeBSD
section: setup-sensor
layout: guides
subtitle: 'Difficulty: Beginner 🧑‍💻'
---

# Install the Orb Sensor on FreeBSD

## Installation

Setting up a FreeBSD system as an Orb sensor allows you to run continuous network monitoring.

### Download

Download the Orb CLI for FreeBSD from our Early Access page:

**AMD64:**
[Download Orb CLI for FreeBSD (AMD64)](https://pkgs.orb.net/earlyaccess/orb-freebsd-amd64.zip)

**ARM64:**
[Download Orb CLI for FreeBSD (ARM64)](https://pkgs.orb.net/earlyaccess/orb-freebsd-arm64.zip)

:::note
The Orb CLI for FreeBSD is currently Early Access software. This is an experimental release that is not yet packaged, does not auto-update, and does not yet run as a service automatically.
:::

After downloading, extract the archive and move the `orb` binary to a location in your PATH (e.g., `/usr/local/bin/orb`):

```bash
unzip orb-freebsd-amd64.zip
sudo mv orb /usr/local/bin/orb
sudo chmod +x /usr/local/bin/orb
```

## Usage

### Running Manually

To start the Orb sensor, run:

```bash
orb sensor
```

If you would like to use other CLI functions, you can run:

```bash
orb help
```

for a list of available commands.

### Running as a Service

To run Orb continuously in the background (so it persists after your shell session ends), you can set it up as an rc.d service.

Create an rc.d script at `/usr/local/etc/rc.d/orb`:

```bash
sudo ee /usr/local/etc/rc.d/orb
```

Add the following content:

```bash
#!/bin/sh
#
# PROVIDE: orb
# REQUIRE: NETWORKING
# KEYWORD: shutdown

. /etc/rc.subr

name="orb"
rcvar=orb_enable

command="/usr/local/bin/orb"
command_args="sensor"
pidfile="/var/run/${name}.pid"

orb_user="root"

start_cmd="${name}_start"
stop_cmd="${name}_stop"

orb_start()
{
    echo "Starting ${name}."
    /usr/sbin/daemon -p ${pidfile} -u ${orb_user} ${command} ${command_args}
}

orb_stop()
{
    if [ -f ${pidfile} ]; then
        echo "Stopping ${name}."
        kill -TERM `cat ${pidfile}`
        rm -f ${pidfile}
    else
        echo "${name} is not running."
    fi
}

load_rc_config $name
run_rc_command "$1"
```

Make the script executable:

```bash
sudo chmod +x /usr/local/etc/rc.d/orb
```

Enable the service to start at boot:

```bash
sudo sysrc orb_enable="YES"
```

Start the service:

```bash
sudo service orb start
```

To check the status:

```bash
sudo service orb status
```

To stop the service:

```bash
sudo service orb stop
```

:::tip
You can modify `orb_user="root"` in the rc.d script to run Orb as a different user if desired. Make sure that user has appropriate permissions.
:::

## Orb CLI Commands

The Orb CLI provides a set of commands to manage your Orb sensors and interact with your Orb account. Below are some common commands you can use:

```bash
orb [command]
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

## Using Deployment Tokens

You can automatically link your Orb sensor to your Orb Cloud Space using a deployment token. This is especially useful for deploying multiple sensors or automating setup.

To use a deployment token, create a file named `deployment_token.txt` in the Orb configuration directory (typically `~/.config/orb`) containing your token:

```bash
mkdir -p ~/.config/orb
echo "orb-dt1-yourdeploymenttoken678" > ~/.config/orb/deployment_token.txt
```

Replace `orb-dt1-yourdeploymenttoken678` with your actual deployment token from the [Orchestration](https://cloud.orb.net/orchestration) section of Orb Cloud.

Alternatively, you can use the `ORB_DEPLOYMENT_TOKEN` environment variable:

```bash
ORB_DEPLOYMENT_TOKEN=orb-dt1-yourdeploymenttoken678 orb sensor
```

For more details on deployment tokens and other linking methods, see the [Deployment Tokens](/docs/deploy-and-configure/deployment-tokens) guide.

For instructions on linking your Orb sensor to your account, refer to the [Linking an Orb to Your Account](/docs/orb-app/linking-orb-to-account.md) guide.
