#!/usr/bin/env bash

# Install docker and docker-compose here. Can't currently install in the APK :/
sudo pkg install -y docker docker-compose

# Generate keys for SSH
ssh-keygen -A
