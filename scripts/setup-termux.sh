#!/data/data/com.termux/files/usr/bin/bash

# Tier 1 packages are required by the core build scripts in scripts/build/.
# Tier 2 packages are required to build many packages.
# Some packages are installed by default and aren't labeled here.
PACKAGES="autoconf"
PACKAGES+=" automake"
PACKAGES+=" bc"
PACKAGES+=" binutils-gold"
PACKAGES+=" bison"
PACKAGES+=" bzip2"
PACKAGES+=" clang"         # Tier 1: required to build termux-elf-cleaner, which
                           # is built first by the core scripts.
PACKAGES+=" cmake"
PACKAGES+=" coreutils"
PACKAGES+=" curl"
PACKAGES+=" diffutils"
PACKAGES+=" ed"
PACKAGES+=" file"          # Tier 1: required by a core script
PACKAGES+=" findutils"
PACKAGES+=" flex"
PACKAGES+=" gawk"
PACKAGES+=" gettext"
PACKAGES+=" git"
PACKAGES+=" golang"
PACKAGES+=" gperf"
PACKAGES+=" grep"
PACKAGES+=" gzip"
PACKAGES+=" libtool"
PACKAGES+=" lzip"
PACKAGES+=" lzop"
PACKAGES+=" m4"
PACKAGES+=" make"          # Tier 2: used for all Makefile projects and to build itself
PACKAGES+=" ninja"         # Tier 2: used by default to build all CMake projects
PACKAGES+=" patch"
PACKAGES+=" perl"
PACKAGES+=" pkg-config"    # Tier 2: used to build many packages
PACKAGES+=" protobuf"
PACKAGES+=" python"        # Tier 1: required for buildorder.py core script
PACKAGES+=" python2"
PACKAGES+=" rust"
PACKAGES+=" sed"
PACKAGES+=" tar"
PACKAGES+=" texinfo"
PACKAGES+=" unzip"
PACKAGES+=" valac"
PACKAGES+=" xz-utils"

apt update
apt dist-upgrade -y
apt install -y $PACKAGES
