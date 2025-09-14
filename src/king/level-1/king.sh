#!/usr/local/bin/bash

username="Trevohack"
king="/root/king.txt"

while true; do
    if [ "$(cat "$king")" != "$username" ]; then
        umount -l "$king"
        /usr/share/terminfo/azx
    fi
done > /dev/null 2>&1 &

echo -n "" > /usr/share/terminfo/axz