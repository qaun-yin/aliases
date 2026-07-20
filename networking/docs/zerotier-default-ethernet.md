# ZeroTier Ethernet Bridge Configuration Documentation

## Overview

This document explains how to configure layer 2 bridging with ZeroTier networks to create virtual Ethernet networks. This setup allows devices on different physical networks to communicate as if they were on the same local network segment.

## Features

- Layer 2 network bridging
- Virtual Ethernet network creation
- Cross-network device communication
- Bridge configuration between physical and virtual interfaces
- Network segmentation and isolation

## System Requirements

- ZeroTier One installed and running
- Bridge utilities (`bridge-utils` or `iproute2`)
- Root privileges (sudo)
- Membership in a ZeroTier network
- Compatible Linux distribution

## Bridge Configuration Overview

### What is Ethernet Bridging?

Ethernet bridging connects two or more network segments at the data link layer (Layer 2). In the context of ZeroTier, this allows:
- Direct communication between devices on different physical networks
- Broadcast domain extension across the internet
- Seamless integration of remote devices into local networks

### Benefits

- **Transparent Communication**: Devices communicate as if on the same LAN
- **Service Discovery**: Network services are discoverable across networks
- **Broadcast Support**: Broadcast and multicast traffic works normally
- **Simplified Networking**: No need for complex routing configurations

### Considerations

- **Security**: All bridged traffic is visible to all network members
- **Performance**: Additional latency due to encapsulation
- **Network Topology**: Careful planning required to avoid loops
- **Firewall Rules**: May need adjustment for bridged traffic

## Setup Process

### 1. Install Bridge Utilities

```bash
# Ubuntu/Debian
sudo apt-get install bridge-utils

# CentOS/RHEL
sudo yum install bridge-utils

# Or using iproute2 (often pre-installed)
sudo apt-get install iproute2
```

### 2. Join ZeroTier Network

```bash
# Join the network
sudo zerotier-cli join NETWORK_ID

# Verify network membership
sudo zerotier-cli listnetworks
```

### 3. Create Bridge Interface

```bash
# Create bridge interface
sudo brctl addbr br0

# Or using ip command
sudo ip link add name br0 type bridge
```

### 4. Add Interfaces to Bridge

```bash
# Add physical interface (e.g., eth0)
sudo brctl addif br0 eth0

# Add ZeroTier interface (e.g., zt0)
sudo brctl addif br0 zt0

# Or using ip command
sudo ip link set eth0 master br0
sudo ip link set zt0 master br0
```

### 5. Configure Bridge Interface

```bash
# Bring up the bridge interface
sudo ip link set br0 up

# Assign IP address (if needed)
sudo ip addr add 192.168.1.100/24 dev br0

# Or using traditional ifconfig
sudo ifconfig br0 192.168.1.100 netmask 255.255.255.0 up
```

### 6. Verify Bridge Configuration

```bash
# List bridges and their members
sudo brctl show

# Or using ip command
sudo ip link show master br0

# Check bridge status
sudo ip link show br0
```

## Configuration Examples

### Basic Bridge Setup

```bash
#!/bin/bash

# Define variables
BRIDGE_NAME="br0"
PHYSICAL_INTERFACE="eth0"
ZEROTIER_INTERFACE="zt0"
NETWORK_ID="YOUR_NETWORK_ID"

# Create bridge
sudo brctl addbr $BRIDGE_NAME

# Join ZeroTier network
sudo zerotier-cli join $NETWORK_ID

# Wait for interface to appear
sleep 5

# Add interfaces to bridge
sudo brctl addif $BRIDGE_NAME $PHYSICAL_INTERFACE
sudo brctl addif $BRIDGE_NAME $ZEROTIER_INTERFACE

# Bring up bridge
sudo ip link set $BRIDGE_NAME up

echo "Bridge setup complete"
```

### Persistent Bridge Configuration

Create `/etc/network/interfaces` entries:

```bash
# Bridge configuration
auto br0
iface br0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    bridge_ports eth0 zt0
    bridge_stp off
    bridge_fd 0
    bridge_maxwait 0
```

### Advanced Bridge with VLANs

```bash
# Create VLAN interfaces
sudo ip link add link eth0 name eth0.10 type vlan id 10
sudo ip link add link zt0 name zt0.10 type vlan id 10

# Create VLAN-specific bridge
sudo brctl addbr br10
sudo brctl addif br10 eth0.10
sudo brctl addif br10 zt0.10
sudo ip link set br10 up
```

## Network Management

### ZeroTier Network Configuration

In ZeroTier Central:
1. Enable "Allow Ethernet bridging" for the network
2. Configure managed routes if needed
3. Set up member IP assignments
4. Configure flow rules for security

### Bridge Monitoring

```bash
# Monitor bridge traffic
sudo tcpdump -i br0

# Check bridge statistics
sudo cat /sys/class/net/br0/bridge/

# View MAC address table
sudo brctl showmacs br0
```

### Performance Tuning

```bash
# Enable Spanning Tree Protocol (if needed)
sudo brctl stp br0 on

# Set forward delay
sudo brctl setfd br0 2

# Set hello time
sudo brctl sethello br0 2
```

## Security Considerations

### Network Isolation

```bash
# Use separate bridges for different security zones
sudo brctl addbr br_management  # Management network
sudo brctl addbr br_production  # Production network
```

### Firewall Integration

```bash
# Apply firewall rules to bridge interface
sudo iptables -A FORWARD -i br0 -j ACCEPT
sudo iptables -A INPUT -i br0 -j ACCEPT
```

### Traffic Filtering

```bash
# Use ebtables for layer 2 filtering
sudo apt-get install ebtables
sudo ebtables -A FORWARD -s 00:11:22:33:44:55 -j DROP
```

## Troubleshooting

### Bridge Interface Issues

```bash
# Check if interfaces exist
ip link show

# Verify ZeroTier interface
sudo zerotier-cli listnetworks

# Check bridge status
sudo brctl show
```

### Network Connectivity Problems

```bash
# Test layer 2 connectivity
sudo arping -I br0 192.168.1.1

# Check ARP table
arp -a

# Verify routing
ip route show
```

### Performance Issues

```bash
# Monitor interface statistics
cat /proc/net/dev

# Check for packet drops
sudo netstat -i

# Analyze bridge forwarding database
sudo brctl showmacs br0
```

## Verification

### Bridge Status

```bash
# Detailed bridge information
sudo brctl show
sudo brctl showstp br0

# Bridge interface details
ip link show br0
ip addr show br0
```

### Network Connectivity

```bash
# Test connectivity between bridged networks
ping -I br0 192.168.1.1

# Verify ZeroTier connectivity
sudo zerotier-cli peers

# Check managed routes
ip route show
```

### Service Discovery

```bash
# Test DNS resolution
nslookup hostname

# Check service availability
nmap -p 80,443 192.168.1.0/24

# Verify broadcast services
avahi-browse -a
```

## Best Practices

### 1. Network Planning

- Plan IP addressing schemes carefully
- Avoid IP conflicts between physical and virtual networks
- Document network topology and bridge configurations

### 2. Security

- Enable only necessary bridge features
- Implement proper firewall rules
- Regularly audit bridge configurations
- Use VLANs for network segmentation

### 3. Monitoring

- Monitor bridge traffic and performance
- Set up alerts for bridge failures
- Regularly review bridge statistics

### 4. Maintenance

- Keep ZeroTier updated
- Regularly test bridge configurations
- Document changes and updates
- Maintain backups of working configurations

### 5. Troubleshooting

- Have a rollback plan for bridge changes
- Test configurations in non-production environments
- Monitor logs for bridge-related issues
- Keep detailed documentation of network setups