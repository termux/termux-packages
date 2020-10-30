#!/bin/bash

# Tier 1: requirements for the core build scripts in scripts/build/.
PACKAGES="binutils-gold"	# Part of binutils which is dependency of clang.
PACKAGES+=" clang"			# Required to build termux-elf-cleaner as well as other
							# C/C++ packages.
PACKAGES+=" file"			# Used in termux_step_massage().
PACKAGES+=" lzip"			# Used by tar to extract *.tar.lz source archives.
PACKAGES+=" patch"			# Used for applying patches on source code.
PACKAGES+=" python"			# Used buildorder.py core script.
PACKAGES+=" unzip"			# Used to extract *.zip source archives.

# Tier 2: requirements for building many other packages.
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor"
PACKAGES+=" autoconf"
PACKAGES+=" automake"
PACKAGES+=" bc"
PACKAGES+=" bison"
PACKAGES+=" cmake"
PACKAGES+=" ed"
PACKAGES+=" flex"
PACKAGES+=" gettext"
PACKAGES+=" git"
PACKAGES+=" golang"
PACKAGES+=" gperf"
PACKAGES+=" help2man"
PACKAGES+=" libtool"
PACKAGES+=" m4"
PACKAGES+=" make"			# Used for all Makefile-based projects.
PACKAGES+=" ninja"			# Used by default to build all CMake projects.
PACKAGES+=" perl"
PACKAGES+=" pkg-config"
PACKAGES+=" protobuf"
PACKAGES+=" python2"
PACKAGES+=" rust"
PACKAGES+=" texinfo"
PACKAGES+=" valac"

apt update
apt dist-upgrade -y
apt install -y $PACKAGES
