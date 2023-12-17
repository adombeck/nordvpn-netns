# WireGuard-namespace-service
A script and a systemd service that creates isolated network namespace with traffic routed through WireGuard interface.

This allows to create sandboxes the traffic of which will be routed the WireGuard interface.

The script is written in bash and can be used separately from the service.

Script usage example with [firejail](https://firejail.wordpress.com/):

```
(user) $ curl ifconfig.co
X.X.X.X
(root) # MY_IP="10.8.0.2" wg_namespace_cli up wg0
(user) $ firejail --noprofile --netns=wg0 sh
sh-5.1$ curl ifconfig.co
Y.Y.Y.Y
```

Systemd service can be run as

```
(root) # systemctl start wg-netnamespace@wg0
```

Where wg0 is the name of the config file in `/etc/wireguard`


# Installation

On Gentoo you can install it from [nitratesky-overlay](https://github.com/VTimofeenko/nitratesky):

    # eselect repository enable nitratesky
    # emerge -a1 net-vpn/wireguard-namespace-service

Otherwise, place `wg_namespace_cli` in `/usr/local/bin/`, or in a location of your choice inside `$PATH`.

# Setup

* Setup WireGuard configuration file in `/etc/wireguard/wg0.conf` ([debian manpages link](https://manpages.debian.org/unstable/wireguard-tools/wg.8.en.html#CONFIGURATION_FILE_FORMAT))
* If using systemd service – create a service drop-in and specify the IP for the interface. E.g.:

    ```
    (root) # systemctl edit wg-netnamespace@wg0
    [Service]
    Environment=MY_IP=10.8.1.101
    ```

# Configuration

See `man wg_namespace_cli` or the script itself for a list of environment variables.

# Nix version

Nix version with a few extra tweaks is available as a flake [here](https://github.com/VTimofeenko/wg-namespace-flake).

# Reference

* [WireGuard Routing & Network Namespace Integration](https://www.wireguard.com/netns/)
* [Similar project that relies on python to parse config file](https://github.com/dadevel/wg-netns)
