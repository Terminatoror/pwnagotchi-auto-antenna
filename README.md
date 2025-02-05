# 📶 Pwnagotchi Smart WiFi Switch  

This script **automatically switches between internal and external WiFi adapters** on your **Pwnagotchi**, depending on whether a USB WiFi adapter is plugged in. No more reboots required!  

It runs in the background and detects WiFi adapter changes in real time, restarting the Pwnagotchi service with the correct WiFi interface.  

## 🔧 Features  
✅ **Hot-swappable** – Detects WiFi adapter changes on the go  
✅ **Automatic switching** – Enables/disables external WiFi as needed  
✅ **Service-based** – Runs at boot for seamless operation  
✅ **No reboots needed** – Keeps your Pwnagotchi running smoothly  

## 🛠️ Installation  

1. **Copy the script** (`switch_wifi_smart.sh`) to `/` and make it executable:  
   ```bash
   sudo cp switch_wifi_smart.sh /
   sudo chmod +x /switch_wifi_smart.sh
   ```

2. **Create the service file** at `/etc/systemd/system/switch_wifi_smart.service`:  

   ```ini
   [Unit]
   Description=Wifi Switch Script
   After=network.target

   [Service]
   Type=simple
   ExecStart=/bin/bash /switch_wifi_smart.sh
   Restart=always
   RestartSec=5
   User=root
   Group=root

   [Install]
   WantedBy=multi-user.target
   ```

3. **Enable and start the service**:  
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable switch_wifi_smart.service
   sudo systemctl start switch_wifi_smart.service
   ```

4. **Check if the service is running properly**:  
   ```bash
   sudo systemctl status switch_wifi_smart.service
   ```

## 📝 Notes  
- Ensure your script (`/switch_wifi_smart.sh`) properly detects the presence of a USB WiFi adapter and restarts Pwnagotchi accordingly.  
- You can modify `RestartSec=5` to change the polling interval for adapter detection.  

Now your Pwnagotchi will **automatically switch WiFi adapters without requiring a reboot!** 🚀
