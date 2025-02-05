#!/bin/bash

# Function to switch to the external WiFi adapter (wlan1)
switch_to_external_wifi() {
    echo "External WiFi detected, renaming wlan1 to wlan0 and disabling onboard WiFi..."

    # Stop the pwnagotchi service before making changes
    echo "Stopping pwnagotchi service..."
    sudo systemctl stop pwnagotchi

    # Bring down both interfaces to prevent conflicts
    sudo ip link set wlan0 down
    sudo ip link set wlan1 down

    # Rename onboard wlan0 to wlan_temp to avoid name conflict
    sudo ip link set wlan0 name wlan_temp

    # Rename external wlan1 to wlan0
    sudo ip link set wlan1 name wlan0
    sudo ip link set wlan0 up

    # Keep the onboard interface down (optional)
    sudo ip link set wlan_temp down

    # Start pwnagotchi service after switching
    echo "Starting pwnagotchi service..."
    sudo systemctl start pwnagotchi

    echo "Switched to external WiFi successfully."
}

# Function to revert to the onboard WiFi adapter (wlan0)
switch_to_onboard_wifi() {
    echo "External WiFi removed, reverting to onboard WiFi..."

    # Stop pwnagotchi service before switching back
    echo "Stopping pwnagotchi service..."
    sudo systemctl stop pwnagotchi

    # Bring down wlan0 (external adapter) if it's up
    if ip link show wlan0 &> /dev/null; then
        echo "Bringing down wlan0 (external adapter)..."
        sudo ip link set wlan0 down
    fi

    # Rename wlan_temp back to wlan0
    if ip link show wlan_temp &> /dev/null; then
        echo "Renaming wlan_temp back to wlan0..."
        sudo ip link set wlan_temp name wlan0
        sudo ip link set wlan0 up
    fi

    # Start pwnagotchi service after reverting to onboard WiFi
    echo "Starting pwnagotchi service..."
    sudo systemctl start pwnagotchi

    echo "Reverted to onboard WiFi successfully."
}

# Main monitoring loop
echo "Monitoring WiFi adapters..."

while true; do
    # Check if wlan1 exists (external adapter plugged in)
    if ip link show wlan1 &> /dev/null; then
        echo "External WiFi (wlan1) is detected."

        # If wlan1 is present and wlan0 is not set up, switch to external WiFi
        switch_to_external_wifi
    else
        echo "External WiFi (wlan1) is NOT detected."

        # External WiFi removed, revert to onboard WiFi only if wlan_temp exists
        if ip link show wlan_temp &> /dev/null && ! ip link show wlan0 &> /dev/null; then
            switch_to_onboard_wifi
        fi
    fi

    # Debugging: Check if wlan0 exists and is active
    if ip link show wlan0 &> /dev/null; then
        echo "wlan0 exists and is active."
    else
        echo "wlan0 does NOT exist."
    fi

    sleep 5  # Check every 5 seconds
done
