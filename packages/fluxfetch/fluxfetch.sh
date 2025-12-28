#!/data/data/com.termux/files/usr/bin/bash

bold="\033[1m"
reset="\033[0m"

os="Android (Termux)"
kernel="$(uname -r)"
arch="$(uname -m)"
uptime="$(uptime -p | sed 's/up //')"
shell="$(basename "$SHELL")"
mem="$(free -h | awk '/Mem:/ {print $3 "/" $2}')"
storage="$(df -h $PREFIX | awk 'NR==2 {print $3 "/" $2}')"
pkgs="$(pkg list-installed | wc -l)"

echo -e "${bold}fluxfetch${reset}"
echo "OS       : $os"
echo "Kernel   : $kernel"
echo "Arch     : $arch"
echo "Uptime   : $uptime"
echo "Shell    : $shell"
echo "Memory   : $mem"
echo "Storage  : $storage"
echo "Packages : $pkgs"
