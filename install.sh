#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

install -d -m 755 /usr/local/sbin
install -m 755 "${DIR}/nordvpn-netns" /usr/local/sbin

install -d -m 755 /usr/local/lib/systemd/system
install -m 644 "${DIR}/systemd/nordvpn-netns.service" /usr/local/lib/systemd/system

install -d -m 700 /etc/netns/nordvpn
install -m 600 "${DIR}/resolv.conf" /etc/netns/nordvpn

systemctl daemon-reload
