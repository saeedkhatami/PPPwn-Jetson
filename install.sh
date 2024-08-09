#!/bin/bash

SERVICE_NAME="pppwn_jetson"
EXECUTABLE_PATH="pppwn"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

ACCEPTABLE_VERSIONS=("700" "701" "702" "750" "751" "755" "800" "801" "803" "850" "852" "900" "903" "904" "950" "951" "960" "1000" "1001" "1050" "1070" "1071" "1100")

read -p "Enter the network interface which is connected to PS4 (e.g., en0): " INTERFACE

function contains() {
    local value="$1"
    shift
    for v in "$@"; do
        if [ "$v" == "$value" ]; then
            return 0
        fi
    done
    return 1
}

while true; do
    read -p "Enter the firmware version: " FIRMWARE_VER
    if contains "$FIRMWARE_VER" "${ACCEPTABLE_VERSIONS[@]}"; then
        break
    else
        echo "Invalid firmware version. Please enter one of the following: ${ACCEPTABLE_VERSIONS[*]}"
    fi
done

ARGUMENTS="pppwn --interface ${INTERFACE} --fw ${FIRMWARE_VER} --auto-retry"

if [ ! -f "$EXECUTABLE_PATH" ]; then
    echo "Error: $EXECUTABLE_PATH not found!"
    exit 1
fi

echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=pppwn service
After=network.target

[Service]
ExecStart=$EXECUTABLE_PATH $ARGUMENTS
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOL

echo "Setting permissions for the service file..."
sudo chmod 644 $SERVICE_FILE

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Enabling $SERVICE_NAME service to start on boot..."
sudo systemctl enable $SERVICE_NAME

echo "Starting $SERVICE_NAME service..."
sudo systemctl start $SERVICE_NAME

echo "Checking the status of the service..."
sudo systemctl status $SERVICE_NAME

echo "Installation completed successfully."
