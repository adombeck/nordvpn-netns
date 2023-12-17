#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

install -d -m 755 /usr/local/sbin
install -m 755 wg_namespace_cli /usr/local/sbin

install -d -m 755 /usr/local/lib/systemd/system
install -m 644 systemd/wg-netnamespace@.service /usr/local/lib/systemd/system

systemctl daemon-reload
