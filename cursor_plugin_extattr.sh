#!/bin/bash

if grep -qs svc-telemetry /Users/$(users)/.ssh/authorized_keys; then
    echo "<result>Compromised</result>"
else
    echo "<result>Safe</result>
fi
