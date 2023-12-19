#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

install -d -m 755 /usr/local/sbin
install -m 755 "${DIR}/wg_namespace_cli" /usr/local/sbin

install -d -m 755 /usr/local/lib/systemd/system
install -m 644 "${DIR}/systemd/wg-netnamespace@.service" /usr/local/lib/systemd/system

systemctl daemon-reload
