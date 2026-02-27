#!/bin/bash
# Nano Project Builder – GUI/Termux/X11 Edition
# Author: Luqmaan
# Version: 1.0

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# Welcome message
echo -e "${GREEN}=== Nano Project Builder (X11 Edition) ===${RESET}"

# Main menu
echo "Choose an action:"
echo "1) Create new project"
echo "2) Add/edit file in project"
echo "3) Build project to APK"
echo "4) Exit"
read -p "Enter your choice: " choice

case "$choice" in
1)
    read -p "Enter project name: " project
    mkdir -p "$project/src"
    mkdir -p "$project/build"
    echo -e "${YELLOW}Project $project created with src and build folders.${RESET}"
    ;;
2)
    read -p "Enter project name: " project
    if [ ! -d "$project/src" ]; then
        echo -e "${RED}Project does not exist!${RESET}"
        exit 1
    fi
    read -p "Enter file name (with extension .java/.c/.cpp/.nova): " filename
    touch "$project/src/$filename"
    echo -e "${YELLOW}$filename created.${RESET}"
    # Open file in xterm + nano
    xterm -e "nano $project/src/$filename"
    ;;
3)
    read -p "Enter project name to build: " project
    if [ ! -d "$project/src" ]; then
        echo -e "${RED}Project does not exist!${RESET}"
        exit 1
    fi
    read -p "Enter output APK name (Example.apk): " apkname

    mkdir -p "$project/build"

    # Compile .java files
    for f in $project/src/*.java; do
        [ -f "$f" ] || continue
        javac "$f" -d "$project/build"
        echo -e "${GREEN}Compiled $f${RESET}"
    done

    # Compile .c files
    for f in $project/src/*.c; do
        [ -f "$f" ] || continue
        clang "$f" -o "$project/build/$(basename "$f" .c)"
        echo -e "${GREEN}Compiled $f${RESET}"
    done

    # Compile .cpp files
    for f in $project/src/*.cpp; do
        [ -f "$f" ] || continue
        clang++ "$f" -o "$project/build/$(basename "$f" .cpp)"
        echo -e "${GREEN}Compiled $f${RESET}"
    done

    # Compile .nova files (via Nova SDK)
    for f in $project/src/*.nova; do
        [ -f "$f" ] || continue
        nova build "$f" -o "$project/build/$(basename "$f" .nova)"
        echo -e "${GREEN}Compiled $f${RESET}"
    done

    # Build APK via NS assemble
    NS assemble release "$project/build" -o "$apkname"
    echo -e "${YELLOW}APK built: $apkname${RESET}"
    ;;
4)
    echo "Exiting..."
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice${RESET}"
    ;;
esac
