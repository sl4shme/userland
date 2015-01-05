#!/bin/bash
execPath=${0%/*}

if [ `id -u` -ne 0 ]; then                                     
    echo "This is intended to be run as root" 
        exit 1                                                 
fi                                                             

echo "Now blocking throttling attempts. CTRL + C to stop."

$execPath/e6400_temp &
pid=$!
trap 'kill "$pid" 2>&1 > /dev/null ; exit' INT

modprobe msr
for (( ; ; ))
do
    wrmsr 0x199 0xC2C
    wrmsr 0x19A 0x0

    sleep 0.1s
done
