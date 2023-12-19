# NordVPN isolated network namespace
A systemd service that creates an isolated network namespace with traffic
routed through NordVPN using WireGuard.

This allows to configure systemd services to run in a VPN-only namespace.

## Installation

```bash
sudo ./install.sh
```

## Configuration

Put your WireGuard private key in `/etc/nordvpn-netns/nordvpn.key`. For
instructions on how to get the key, see 
https://gist.github.com/bluewalk/7b3db071c488c82c604baf76a42eaad3.

By default, a NordVPN server in Switzerland is used. To change the country,
set the `WG_COUNTRY_CODE` environment variable to the country code of your
choice (for example in a drop-in file for the service).

## Usage

Start the service:

```bash
sudo systemctl start nordvpn-netns.service
```

Check that WireGuard is running:

```bash
sudo ip netns exec nordvpn wg show
```

Check that the VPN is working:

```bash
sudo ip netns exec nordvpn curl ifconfig.me/ip
```

Configure other services to run in the namespace:

```systemd
[Unit]
BindsTo=nordvpn-netns.service
After=nordvpn-netns.service

[Service]
NetworkNamespacePath=/run/netns/nordvpn
BindReadOnlyPaths=/etc/netns/nordvpn/resolv.conf:/etc/resolv.conf:norbind
```

## Credits
This is based on https://github.com/VTimofeenko/wireguard-namespace-service.
