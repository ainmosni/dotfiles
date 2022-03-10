#!/bin/bash

procs=$(pgrep -c -f wallpaper.sh)

if (("$procs" > 1)); then
    echo "Already running"
    exit 0
fi

while true; do
    setrandom /home/daniel/Drive/Wallpapers
    sleep $(expr 3600 \* 4)
done
