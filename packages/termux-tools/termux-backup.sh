#!/data/data/com.termux/files/usr/bin/bash

BACKUP_DIR="/sdcard/backups/termux"
BACKUP_NAME="backup-$(date +%F_%R)"

show_usage() {
    echo "usage: termux-backup [-d output dir | -f backup name]"
    echo "Backup $HOME folder. Useful if you"
    echo "need to clear Termux's data"
}

set_directory() {
    echo -n "Setting backup directory to $1..."
    BACKUP_DIR=$1
    echo "done"
}

set_file_name() {
    echo -n "Setting backup file name to $1..."
    BACKUP_NAME=$1
    echo "done"
}
   
do_backup() {
    if [ ! -d $BACKUP_DIR ]; then
        echo -n "Backup directory not found. Creating..."
        mkdir $BACKUP_DIR
        echo "done"
    fi
    
    echo -n "Backing up. Please wait..."
    tar czf $BACKUP_DIR/$BACKUP_NAME.tar.gz $HOME/*
    echo "done"
}

while true; do
    case "$1" in
        -h|--help) show_usage; exit 0;;
        -f|--file) set_file_name $2; exit 0;;
        -d|--directory) set_directory $2; exit 0;;
        *) do_backup; exit 1;;
    esac
done
