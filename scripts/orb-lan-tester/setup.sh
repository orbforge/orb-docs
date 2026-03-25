#!/bin/bash
set -eu

SUCCESS=0

cleanup() {
  if [ "$SUCCESS" -eq 1 ]; then
    echo
    echo "Setup completed successfully."
    echo "Rebooting in 10 seconds..."
    sleep 10
    reboot
  else
    echo
    echo "Setup failed — not rebooting."
    echo "Fix the issue and re-run the script."
  fi
}
trap cleanup EXIT

HOST_ORB_NAME="${HOST_ORB_NAME:-orb-lan-tester-wifi}"
ETH_ORB_NAME="${ETH_ORB_NAME:-orb-lan-tester-ethernet}"
ETH_HOSTS_ALIAS="${ETH_HOSTS_ALIAS:-orb-lan-tester-ethernet.local}"
STACK_DIR="/opt/orb-ethernet"
ENV_FILE="$STACK_DIR/.env"
ORB_DEFAULTS="/etc/default/orb"

log() {
  printf '\n==> %s\n' "$*"
}

require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: curl ... | sudo -E sh"
    exit 1
  fi
}

require_env() {
  var_name="$1"
  eval "var_value=\${$var_name:-}"
  if [ -z "$var_value" ]; then
    echo "$var_name is required"
    exit 1
  fi
}

set_kv_file() {
  file="$1"
  key="$2"
  value="$3"
  tmp="$(mktemp)"
  if [ -f "$file" ]; then
    grep -v "^${key}=" "$file" > "$tmp" || true
  fi
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  install -m 0644 "$tmp" "$file"
  rm -f "$tmp"
}

detect_wifi_conn() {
  nmcli -t -f GENERAL.CONNECTION device show wlan0 2>/dev/null | sed -n 's/^GENERAL.CONNECTION://p' | head -n1
}

detect_eth_conn() {
  nmcli -t -f GENERAL.CONNECTION device show eth0 2>/dev/null | sed -n 's/^GENERAL.CONNECTION://p' | head -n1
}

ensure_apt_keyring_dir() {
  install -m 0755 -d /etc/apt/keyrings
}

ensure_docker_repo() {
  ensure_apt_keyring_dir

  if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
  fi

  CODENAME="$(. /etc/os-release && printf '%s' "$VERSION_CODENAME")"
  ARCH="$(dpkg --print-architecture)"

  cat > /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable
EOF
}

ensure_orb_repo() {
  install -m 0755 -d /usr/share/keyrings

  curl -fsSL https://pkgs.orb.net/stable/debian/orbforge.noarmor.gpg \
    -o /usr/share/keyrings/orbforge-keyring.gpg

  curl -fsSL https://pkgs.orb.net/stable/debian/debian.orbforge-keyring.list \
    -o /etc/apt/sources.list.d/orb.list
}

ensure_eth_connection() {
  ETH_CONN="$(detect_eth_conn || true)"
  if [ -n "$ETH_CONN" ] && [ "$ETH_CONN" != "--" ]; then
    printf '%s' "$ETH_CONN"
    return 0
  fi

  if nmcli connection show eth0 >/dev/null 2>&1; then
    printf 'eth0'
    return 0
  fi

  nmcli connection add type ethernet ifname eth0 con-name eth0 ipv4.method auto ipv6.method auto connection.autoconnect yes >/dev/null
  printf 'eth0'
}

write_udhcpc_script() {
  cat > "$STACK_DIR/udhcpc-script.sh" <<'EOF'
#!/bin/sh
case "$1" in
  bound|renew)
    ip addr flush dev "$interface" 2>/dev/null || true
    ip addr add "$ip"/"$mask" dev "$interface"
    ip route del default 2>/dev/null || true
    ip route add default via "$router" dev "$interface"
    : > /etc/resolv.conf
    for ns in $dns; do
      echo "nameserver $ns" >> /etc/resolv.conf
    done
    ;;
esac
EOF
  chmod 0755 "$STACK_DIR/udhcpc-script.sh"
}

write_orb_entrypoint() {
  cat > "$STACK_DIR/orb-entrypoint.sh" <<'EOF'
#!/bin/sh
set -e
udhcpc -i eth0 -s /udhcpc-script.sh -R
exec /app/orb sensor
EOF
  chmod 0755 "$STACK_DIR/orb-entrypoint.sh"
}

write_compose_env() {
  cat > "$ENV_FILE" <<EOF
ORB_DEPLOYMENT_TOKEN_ETHERNET=${ORB_DEPLOYMENT_TOKEN_ETHERNET}
ETH_ORB_NAME=${ETH_ORB_NAME}
EOF
  chmod 0600 "$ENV_FILE"
}

write_compose_file() {
  cat > "$STACK_DIR/docker-compose.yml" <<'EOF'
services:
  orb-ethernet:
    image: orbforge/orb:latest
    container_name: orb-ethernet
    entrypoint: ["/orb-entrypoint.sh"]
    volumes:
      - orb-ethernet-data:/root/.config/orb
      - ./orb-entrypoint.sh:/orb-entrypoint.sh:ro
      - ./udhcpc-script.sh:/udhcpc-script.sh:ro
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    networks:
      - ethnet
    environment:
      ORB_DEVICE_NAME_OVERRIDE: ${ETH_ORB_NAME}
      ORB_DEPLOYMENT_TOKEN: ${ORB_DEPLOYMENT_TOKEN_ETHERNET}
      ORB_MEASURE_SERVER_ENABLED: 1
      ORB_EPHEMERAL_MODE: 1
    labels:
      - "wud.watch=true"
      - "wud.trigger.include=docker.orbeth"

  wud:
    image: ghcr.io/getwud/wud
    container_name: wud
    restart: unless-stopped
    ports:
      - "127.0.0.1:3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      WUD_WATCHER_LOCAL_WATCHBYDEFAULT: "false"
      WUD_TRIGGER_DOCKER_ORBETH_AUTO: "true"
      WUD_TRIGGER_DOCKER_ORBETH_PRUNE: "true"

networks:
  ethnet:
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        - subnet: 192.0.2.0/24
          gateway: 192.0.2.1

volumes:
  orb-ethernet-data:
EOF
}

enable_arp_filter() {
  log "Enabling ARP filtering"
  sysctl -w net.ipv4.conf.all.arp_filter=1
  cat > /etc/sysctl.d/99-orb-network.conf <<'EOF'
net.ipv4.conf.all.arp_filter=1
EOF
}

write_hosts_updater_script() {
  cat > /usr/local/bin/update-orb-ethernet-hosts <<EOF
#!/bin/bash
set -eu

ALIAS_NAME="${ETH_HOSTS_ALIAS}"
HOSTS_FILE="/etc/hosts"
TMP_FILE="\$(mktemp)"

CONTAINER_IP="\$(docker exec orb-ethernet sh -c "ip -4 -o addr show eth0 | awk '{print \\\$4}' | cut -d/ -f1 | head -n1" 2>/dev/null || true)"

awk '
{
  keep=1
  for (i=2; i<=NF; i++) {
    if (\$i == "'"${ETH_HOSTS_ALIAS}"'") {
      keep=0
    }
  }
  if (keep) print
}
' "\$HOSTS_FILE" > "\$TMP_FILE"

if [ -n "\$CONTAINER_IP" ]; then
  printf '%s %s\n' "\$CONTAINER_IP" "\$ALIAS_NAME" >> "\$TMP_FILE"
fi

install -m 0644 "\$TMP_FILE" "\$HOSTS_FILE"
rm -f "\$TMP_FILE"
EOF

  chmod 0755 /usr/local/bin/update-orb-ethernet-hosts
}

write_hosts_timer_service() {
  cat > /etc/systemd/system/orb-ethernet-hosts.service <<'EOF'
[Unit]
Description=Update /etc/hosts with orb-ethernet container DHCP IP
After=docker.service
Wants=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-orb-ethernet-hosts
EOF

  cat > /etc/systemd/system/orb-ethernet-hosts.timer <<'EOF'
[Unit]
Description=Refresh orb-ethernet hosts entry every 30 seconds

[Timer]
OnBootSec=20s
OnUnitActiveSec=30s
AccuracySec=5s
Unit=orb-ethernet-hosts.service

[Install]
WantedBy=timers.target
EOF
}

require_root
require_env ORB_DEPLOYMENT_TOKEN_WIFI
require_env ORB_DEPLOYMENT_TOKEN_ETHERNET

log "Installing prerequisites"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release network-manager iproute2

log "Installing Docker"
ensure_docker_repo
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

log "Configuring NetworkManager"
systemctl enable NetworkManager || true
systemctl start NetworkManager || true
systemctl enable NetworkManager-dispatcher.service || true
systemctl start NetworkManager-dispatcher.service || true

WIFI_CONN="$(detect_wifi_conn || true)"
if [ -z "$WIFI_CONN" ] || [ "$WIFI_CONN" = "--" ]; then
  echo "No active WiFi connection found on wlan0"
  exit 1
fi

ETH_CONN="$(ensure_eth_connection)"

log "Setting WiFi preferred without bouncing live connections"
nmcli connection modify "$WIFI_CONN" connection.autoconnect yes ipv4.route-metric 100 ipv6.route-metric 100
nmcli connection modify "$ETH_CONN" connection.autoconnect yes ipv4.route-metric 200 ipv6.route-metric 200

enable_arp_filter

log "Installing Orb on host"
ensure_orb_repo
apt-get update
apt-get install -y orb
systemctl enable orb-update.timer
systemctl start orb-update.timer

touch "$ORB_DEFAULTS"
set_kv_file "$ORB_DEFAULTS" ORB_DEVICE_NAME_OVERRIDE "$HOST_ORB_NAME"
set_kv_file "$ORB_DEFAULTS" ORB_DEPLOYMENT_TOKEN "$ORB_DEPLOYMENT_TOKEN_WIFI"
set_kv_file "$ORB_DEFAULTS" ORB_EPHEMERAL_MODE "1"

systemctl enable orb
systemctl restart orb

log "Setting up Docker Orb and WUD"
install -d -m 0755 "$STACK_DIR"
write_udhcpc_script
write_orb_entrypoint
write_compose_env
write_compose_file

cd "$STACK_DIR"
docker compose up -d

log "Installing periodic /etc/hosts updater"
write_hosts_updater_script
write_hosts_timer_service
systemctl daemon-reload
systemctl enable orb-ethernet-hosts.timer
systemctl start orb-ethernet-hosts.timer
systemctl start orb-ethernet-hosts.service || true

log "Bootstrap complete"
echo
echo "Host Orb name:      $HOST_ORB_NAME"
echo "Ethernet Orb name:  $ETH_ORB_NAME"
echo "WiFi profile:       $WIFI_CONN"
echo "Ethernet profile:   $ETH_CONN"
echo "Compose stack:      $STACK_DIR"
echo "Ethernet alias:     $ETH_HOSTS_ALIAS"

SUCCESS=1
exit 0