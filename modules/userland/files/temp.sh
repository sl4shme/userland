#!/bin/bash

while true ; do
    cpu=`sensors -u | grep temp2_input | cut -d " " -f4 | cut -d "." -f1`
    gc=`sensors -u | grep temp1_input | cut -d " " -f4 | cut -d "." -f1`
    echo "CPU : $cpu °C / GC : $gc °C"
    sleep 5
done
