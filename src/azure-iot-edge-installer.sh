#!/usr/bin/env bash

# import utils
source utils.sh
log_init

VERSION_TAG="v0.0.0-rc0"

# script 
log_info "Running azure-iot-edge-installer.sh"

# if helper scripts dont exist, fetch via wget 
if [ -d "iot-edge-installer" ]
then
    log_info "Directory iot-edge-installer exists." 
else
    log_info "Preparing install directory."
    mkdir iot-edge-installer
    cd iot-edge-installer

    log_info "Downloding helper files to temporary directory ./iot-edge-installer"
    wget https://github.com/Azure/iot-edge-config/releases/download/${VERSION_TAG}/validate-tier1-os.sh
    wget https://github.com/Azure/iot-edge-config/releases/download/${VERSION_TAG}/install-container-management.sh
    wget https://github.com/Azure/iot-edge-config/releases/download/${VERSION_TAG}/install-edge-runtime.sh
    wget https://github.com/Azure/iot-edge-config/releases/download/${VERSION_TAG}/validate-post-install.sh
    wget https://github.com/Azure/iot-edge-config/releases/download/${VERSION_TAG}/utils.sh
    log_info "Downloaded helper files to temporary directory ./iot-edge-installer"
fi

# add permission to run
chmod +x validate-tier1-os.sh
chmod +x install-container-management.sh
chmod +x install-edge-runtime.sh
chmod +x validate-post-install.sh

# parse command line inputs and fetch output from parser
declare -A parsed_cmds="$(cmd_parser $@)"

# sample usage
echo ""
echo "Verbose Logging: ${parsed_cmds[VERBOSE_LOGGING]}"
echo "Device provisioning: ${parsed_cmds[DEVICE_PROVISIONING]}"
echo "Azure Cloud Identity Provider: ${parsed_cmds[AZURE_CLOUD_IDENTITY_PROVIDER]}"
echo ""

# run scripts in order, can take parsed input from above
./validate-tier1-os.sh
./install-container-management.sh
./install-edge-runtime.sh
./validate-post-install.sh
cd ..

# cleanup
if [ -d "iot-edge-installer" ] 
then
    log_info "Removing temporary directory files for iot-edge-installer."
    rm -rf iot-edge-installer
    log_info "Removed temporary directory files for iot-edge-installer."
fi
