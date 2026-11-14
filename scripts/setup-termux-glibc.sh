#!/bin/bash

PACKAGES=""
PACKAGES+=" gcc-glibc"
PACKAGES+=" clang-glibc"
PACKAGES+=" python-glibc"
PACKAGES+=" python-pip-glibc"
PACKAGES+=" cmake-glibc"
PACKAGES+=" make-glibc"
PACKAGES+=" perl-glibc"
PACKAGES+=" pkgconf-glibc"
PACKAGES+=" glslang-glibc"
PACKAGES+=" spirv-tools-glibc"

. $(dirname "$(realpath "$0")")/properties.sh
source "$TERMUX_PREFIX/bin/termux-setup-package-manager" || true

if [ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" ]; then
	apt update
	yes | apt dist-upgrade
	yes | apt install glibc-repo
	yes | apt install $PACKAGES
elif [ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" ]; then
	pacman -Syu $PACKAGES --needed --noconfirm
else
	echo "Error: no package manager defined"
	exit 1
fi
