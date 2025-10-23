# Simple external display attribute based on SPDisplaysDataType
# Computer and built-in display info is filtered out
# Only models and resolutions of connected external displays are shown
# Does not filter well Intel devices older than 2019

#!/bin/bash

# Identify CPU arch
CPUCheck=`system_profiler SPHardwareDataType | grep "efficiency"`

# Define commands for CPU arches
Arm=`system_profiler SPDisplaysDataType | sed -n '12,$p' | awk '/Color LCD:/ { skip=8 } skip > 0 {skip--; next } 1' | awk '/UI Looks like:/ { skip=5 } skip > 0 {skip--; next } 1'`
Intel=`system_profiler SPDisplaysDataType | sed -n '33,$p' | awk '/Color LCD:/ { skip=9 } skip > 0 {skip--; next } 1' | awk '/UI Looks like:/ { skip=7 } skip > 0 {skip--; next } 1'`

if [CPUCheck == 1]; then 
	echo "<result>[x] Data collection error, check device</result>"
elif [[ $CPUCheck =~ "efficiency" ]]; then
	echo -e "[*] CPU Architecture: ARM\n[*] Collecting connected monitors data..."
	sleep 1
	echo -e "<result>[+] Connected:\n$Arm</result>"
elif [[ ! $CPUCheck =~ "efficiency" ]]; then
	echo -e "[*] CPU Architecture: Intel\n[*] Collecting connected monitors data..."
	sleep 1
	echo -e "<result>[+] Connected:\n$Intel</result>"
else
	echo "<result>[x] Failed to identify CPU</result>"
fi 
