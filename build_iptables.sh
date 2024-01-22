#!/bin/bash

IPTABLES_VERSION="1.8.9"
# Install dependency
apt-get install build-essential autoconf libmnl-dev -y

# Remove preinstalled iptables
apt purge iptables -y

# Get source code
[ -d /tmp/src ] || mkdir /tmp/src && cd /tmp/src
wget https://www.netfilter.org/pub/iptables/iptables-${IPTABLES_VERSION}.tar.xz

# Extract archive
tar -xf iptables-${IPTABLES_VERSION}.tar.xz

# Run configure
cd iptables-${IPTABLES_VERSION}/ && [ -d $HOME/iptables ] || mkdir $HOME/iptables
./configure --prefix=$HOME/iptables --sbindir=/sbin --enable-suppl-groups --disable-nftables

# Compile
make

# Installation
make install

# Create users
useradd -m -s /bin/bash usea_a
useradd -m -s /bin/bash user_d
useradd -m -s /bin/bash user_l

# Create groups
groupadd users_access
groupadd users_denied
groupadd users_limit

# Set users and groups
usermod -aG users_access,users_denied,users_limit user_a
usermod -aG users_denied user_d
usermod -aG user_l user_l
