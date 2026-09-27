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

The nordvpn-netns.service script recognizes the following environment variables:

| Variable | Syntax |
| :--- | :--- |
| `CREDENTIALS_DIRECTORY` | Directory containing WireGuard private keys. Defaults to `/etc/nordvpn-netns`. |
| `WG_COUNTRY_CODE` | The country code to use for the NordVPN server. Defaults to `CH` (Switzerland). |
| `WG_IP` | IP address (in CIDR notation) to assign to the WireGuard interface. Defaults to `10.5.0.2/32`. |
| `WG_NAME` | The name to be used for the namespace, link name and config file name. Defaults to `nordvpn`. |
| `WG_PRIVATE_KEY` | A file containing the WireGuard private key. Defaults to `${CREDENTIALS_DIRECTORY}/${WG_NAME}.key` |
| `WG_VETH_SUBNET` | If defined, an additional veth interface is created to connect the host with the network namespace. The supplied value should be in CIDR notation. The first host address in the subnet is assigned to the host half of the veth connection; the last host address is assigned to the network namespace. For example, setting the variable to `192.168.200.192/30` would create a veth device and assign `192.168.200.193/30` & `192.168.200.194/30` to the host and namespace interfaces, respectively. The script assumes you are using a /30 subnet.<br/><br/>**IMPORTANT NOTE** - Setting this environment variable allows processes running in the network namespace to connect to host processes that have bound to "all local network interfaces" (a fairly common thing to do). Only specify this environment variable if you trust the processes that will be running in the network namespace! |

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
# Using the network namespace doesn't work without PrivateMounts=no  
PrivateMounts=no
```

## Credits
This is based on https://github.com/VTimofeenko/wireguard-namespace-service.
