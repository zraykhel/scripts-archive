#! /bin/bash

echo 'Starting IP address:'
read  FirstIP
echo 'Last octet of the closing IP address:'
read LastOctetIP
echo 'Port'
read Port
nmap -sT $FirstIP-$LastOctetIP -p $Port > /dev/null -oG scan_results
cat scan_results | grep open > scan_results_2
cat scan_results