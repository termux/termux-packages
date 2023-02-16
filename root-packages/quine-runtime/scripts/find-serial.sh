#!/bin/bash

# Look for all devices in /dev/tty* and filter only those with "USB" or "ACM" in the name
for dev in /dev/tty*; do
  if [[ "$dev" == *USB* || "$dev" == *ACM* ]]; then
    # Extract the bus and device number from the device name
    bus=$(echo "$dev" | awk -F/ '{print $NF}' | sed 's/.*-//' | sed 's/:.*$//')
    device=$(echo "$dev" | awk -F/ '{print $NF}' | sed 's/.*://' | sed 's/tty//')

    # Check if the device is a CDC device by looking at its sysfs attributes
    if [[ -e "/sys/bus/usb/devices/${bus}-${device}/bInterfaceClass" ]]; then
      class=$(cat "/sys/bus/usb/devices/${bus}-${device}/bInterfaceClass")
      subclass=$(cat "/sys/bus/usb/devices/${bus}-${device}/bInterfaceSubClass")
      protocol=$(cat "/sys/bus/usb/devices/${bus}-${device}/bInterfaceProtocol")
      
      if [[ "$class" == "02" && "$subclass" == "02" && "$protocol" == "01" ]]; then
        echo "Found CDC device: $dev"
      fi
    fi
  fi
done
