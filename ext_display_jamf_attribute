# Simple external display attribute based on SPDisplaysDataType
# Computer and built-in display info is filtered out
# Only models and resolutions of connected external displays are shown

#!/bin/bash

monitorCheck=`system_profiler SPDisplaysDataType | sed -n '12,$p' | awk '/Color LCD:/ { skip=8 } skip > 0 {skip--; next } 1' | awk '/UI Looks like:/ { skip=5 } skip > 0 {skip--; next } 1'`

if [ "${monitorCheck}" == 1 ]; then
  echo "<result>Failed to collect, check device</result>"
else
  echo "<result>$monitorCheck</result>"
fi
