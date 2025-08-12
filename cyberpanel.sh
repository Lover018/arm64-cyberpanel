#!/bin/bash
# CyberPanel installer script - fixed for Ubuntu 24.04 and ARM64

set -e

LOG_DIR="/var/log/cyberpanel"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/cyberpanel_install_$(date +%Y%m%d_%H%M%S).log"
DEBUG_LOG="$LOG_DIR/cyberpanel_install_debug_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "$LOG_FILE") 2> >(tee -a "$DEBUG_LOG" >&2)

echo "[INFO] CyberPanel installation started"
echo "[INFO] Log file: $LOG_FILE"
echo "[INFO] Debug log file: $DEBUG_LOG"

OUTPUT=$(cat /etc/*release)
ARCH=$(uname -m)

# Detect OS and version including Ubuntu 24.04 support
if echo "$OUTPUT" | grep -q "Ubuntu 18.04" ; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 20.04" ; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 22.04" ; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 24.04" ; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "CentOS Linux 7" ; then
    SERVER_OS="CentOS"
elif echo "$OUTPUT" | grep -q "CentOS Linux 8" ; then
    SERVER_OS="CentOS8"
elif echo "$OUTPUT" | grep -q "AlmaLinux 8" ; then
    SERVER_OS="CentOS8"
elif echo "$OUTPUT" | grep -q "AlmaLinux 9" ; then
    SERVER_OS="CentOS8"
elif echo "$OUTPUT" | grep -q "CloudLinux 7" ; then
    SERVER_OS="CloudLinux"
elif echo "$OUTPUT" | grep -q "openEuler 20.03" ; then
    SERVER_OS="openEuler"
elif echo "$OUTPUT" | grep -q "openEuler 22.03" ; then
    SERVER_OS="openEuler"
else
    echo -e "\nCyberPanel supports Ubuntu 18.04, 20.04, 22.04, 24.04 and supported CentOS/AlmaLinux/CloudLinux/OpenEuler versions only."
    exit 1
fi

# Check architecture
if [ "$ARCH" = "aarch64" ]; then
    echo "[INFO] ARM64 architecture detected — proceeding with ARM64 compatible install"
else
    echo "[INFO] Architecture detected: $ARCH"
fi

# Check for root
if [ "$(id -u)" -ne 0 ]; then
    if [ -n "$SUDO_USER" ]; then
        echo -e "\nYou are using SUDO, please run as root user directly."
        echo -e "If you don't have root access, use 'sudo su -' and rerun."
        exit 1
    else
        echo -e "\nYou must run this script as root."
        exit 1
    fi
else
    echo "[INFO] Running as root user."
fi

# Install required packages based on OS
if [[ "$SERVER_OS" == "Ubuntu" ]]; then
    apt update -y
    apt install -y curl wget python3 python3-venv python3-pip unzip sudo software-properties-common
elif [[ "$SERVER_OS" == "CentOS" || "$SERVER_OS" == "CentOS8" || "$SERVER_OS" == "CloudLinux" || "$SERVER_OS" == "openEuler" ]]; then
    yum install -y curl wget python3 python3-venv python3-pip unzip sudo
else
    echo "[ERROR] Unsupported OS for package installation."
    exit 1
fi

# Set CyberPanel install directory
INSTALL_DIR="/usr/local/CyberPanel"

# Download CyberPanel installer script
echo "[INFO] Downloading CyberPanel install.py script..."
mkdir -p "$INSTALL_DIR"
curl -fsSL https://raw.githubusercontent.com/usmannasir/cyberpanel/main/install.py -o "$INSTALL_DIR/install.py"

# Run CyberPanel Python installer script
echo "[INFO] Running CyberPanel Python installer..."
if [ "$ARCH" = "aarch64" ]; then
    python3 "$INSTALL_DIR/install.py" --arm64
else
    python3 "$INSTALL_DIR/install.py"
fi

echo "[INFO] CyberPanel installation completed."
echo "[INFO] Access CyberPanel at https://<your-server-ip>:8090"

exit 0
