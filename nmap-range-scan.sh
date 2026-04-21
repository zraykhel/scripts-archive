#!/bin/bash

# Beginner-level nmap automation script

echo 'Starting IP address:'
read  FirstIP

echo 'Last octet of the closing IP address:'
read LastOctetIP

echo 'Port'
read Port

nmap -sT $FirstIP-$LastOctetIP -p $Port > /dev/null -oG scan_results
sleep 3
cat scan_results | grep open > scan_results_2
cat scan_results
