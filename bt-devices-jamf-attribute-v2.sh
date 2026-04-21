#!/bin/bash

# Simple Bluetooth device extension attribute based on SPBluetoothDataType
# Shows all info on connected and once paired devices while filtering out computer info

# Identify CPU arch
CPUCheck=`system_profiler SPHardwareDataType | grep "efficiency"`

# Define commands for CPU arches
Arm=`system_profiler SPBluetoothDataType | sed -n '13,$p'`
Intel=`system_profiler SPBluetoothDataType | sed -n '12,$p'`

if [CPUCheck == 1]; then 
	echo "<result>[x] Data collection error, check device</result>"
elif [[ $CPUCheck =~ "efficiency" ]]; then
	echo -e "[*] CPU Architecture: ARM\n[*] Collecting Bluetooth devices data..."
	sleep 1
	echo -e "<result>[+] Connected:\n$Arm</result>"
elif [[ ! $CPUCheck =~ "efficiency" ]]; then
	echo -e "[*] CPU Architecture: Intel\n[*] Collecting Bluetooth devices data..."
	sleep 1
	echo -e "<result>[+] Connected:\n$Intel</result>"
else
	echo "<result>[x] Failed to identify CPU</result>"
fi
