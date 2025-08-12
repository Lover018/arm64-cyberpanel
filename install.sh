#!/bin/bash

# Load helper functions and variables
OUTPUT=$(cat /etc/*release)

if echo "$OUTPUT" | grep -q "CentOS Linux 7" ; then
    echo "Checking and installing curl and wget"
    yum install curl wget -y 1> /dev/null
    yum update curl wget ca-certificates -y 1> /dev/null
    SERVER_OS="CentOS"
elif echo "$OUTPUT" | grep -q "CentOS Linux 8" ; then
    echo -e "\nDetecting Centos 8...\n"
    SERVER_OS="CentOS8"
    yum install curl wget -y 1> /dev/null
    yum update curl wget ca-certificates -y 1> /dev/null
elif echo "$OUTPUT" | grep -q "AlmaLinux 8" ; then
    echo -e "\nDetecting AlmaLinux 8...\n"
    SERVER_OS="CentOS8"
    yum install curl wget -y 1> /dev/null
    yum update curl wget ca-certificates -y 1> /dev/null
elif echo "$OUTPUT" | grep -q "AlmaLinux 9" ; then
    echo -e "\nDetecting AlmaLinux 9...\n"
    SERVER_OS="CentOS8"
    yum install curl wget -y 1> /dev/null
    yum update curl wget ca-certificates -y 1> /dev/null
elif echo "$OUTPUT" | grep -q "CloudLinux 7" ; then
    echo "Checking and installing curl and wget"
    yum install curl wget -y 1> /dev/null
    yum update curl wget ca-certificates -y 1> /dev/null
    SERVER_OS="CloudLinux"
elif echo "$OUTPUT" | grep -q "Ubuntu 18.04" ; then
    echo "Checking and installing curl and wget"
    apt update -y 1> /dev/null
    apt install curl wget -y 1> /dev/null
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 20.04" ; then
    echo "Checking and installing curl and wget"
    apt update -y 1> /dev/null
    apt install curl wget -y 1> /dev/null
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 22.04" ; then
    echo "Checking and installing curl and wget"
    apt update -y 1> /dev/null
    apt install curl wget -y 1> /dev/null
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 24.04" ; then
    echo "Detecting Ubuntu 24.04 (ARM64) - forcing ARM64 support"
    apt update -y 1> /dev/null
    apt install curl wget -y 1> /dev/null
    SERVER_OS="Ubuntu"
else
    echo -e "\nUnable to detect your OS..."
    echo -e "\nCyberPanel is supported on Ubuntu 18.04, 20.04, 22.04, 24.04, AlmaLinux 8, AlmaLinux 9, CloudLinux 7.x...\n"
    exit 1
fi

ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
    echo "ARM64 architecture detected - continuing installation"
else
    echo "Detected architecture: $ARCH"
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as root"
    exit 1
fi

# Download and run cyberpanel.sh
curl -sL https://raw.githubusercontent.com/Lover018/arm64-cyberpanel/main/cyberpanel.sh -o cyberpanel.sh
chmod +x cyberpanel.sh
./cyberpanel.sh --arm64
