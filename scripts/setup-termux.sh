#!/bin/bash

PACKAGES=""
# Tier 1: requirements for the core build scripts in scripts/build/.
PACKAGES+=" clang"				# Required for termux-elf-cleaner and C/C++ packages.
PACKAGES+=" file"				# Used in termux_step_massage().
PACKAGES+=" gnupg"				# Used in termux_get_repo_files() and build-package.sh.
PACKAGES+=" lzip"				# Used by tar to extract *.tar.lz source archives.
PACKAGES+=" patch"				# Used for applying patches on source code.
PACKAGES+=" python"				# Used buildorder.py core script.
PACKAGES+=" python-pip" # Necessary to install 'itstool' for on-device-building (since Ubuntu gets it from 'apt')
PACKAGES+=" unzip"				# Used to extract *.zip source archives.
PACKAGES+=" jq"					# Used for parsing repo.json.
PACKAGES+=" binutils-is-llvm"			# Used for checking symbols.

# Tier 2: requirements for building many other packages.
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor"
PACKAGES+=" autoconf"
PACKAGES+=" automake"
PACKAGES+=" bc"
PACKAGES+=" bison"
PACKAGES+=" bsdtar"                     # Needed to create pacman packages
PACKAGES+=" cmake"
PACKAGES+=" ed"
PACKAGES+=" flex"
PACKAGES+=" gettext"
PACKAGES+=" git"
PACKAGES+=" glslang"                    # Needed by mesa
PACKAGES+=" golang"
PACKAGES+=" gperf"
PACKAGES+=" help2man"
PACKAGES+=" intltool"                   # Needed by qalc
PACKAGES+=" libtool"
PACKAGES+=" llvm-tools"		# Needed to build rust
PACKAGES+=" m4"
PACKAGES+=" make"			# Used for all Makefile-based projects.
PACKAGES+=" ndk-multilib"		# Needed to build rust
PACKAGES+=" ninja"			# Used by default to build all CMake projects.
PACKAGES+=" perl"
PACKAGES+=" pkg-config"
PACKAGES+=" protobuf"
PACKAGES+=" python2"
PACKAGES+=" re2c"                       # Needed by kphp-timelib
PACKAGES+=" rust"
PACKAGES+=" scdoc"
PACKAGES+=" texinfo"
PACKAGES+=" spirv-tools"                # Needed by mesa
PACKAGES+=" uuid-utils"
PACKAGES+=" valac"
PACKAGES+=" xmlto"                      # Needed by git's manpage generation
PACKAGES+=" zip"

PYTHON_PACKAGES=""
PYTHON_PACKAGES+=" itstool"      # necessary to build orca and some other packages
PYTHON_PACKAGES+=" pygments"     # necessary to build mesa (dependency of mako that _must_ be kept `--upgrade`d)
PYTHON_PACKAGES+=" mako"         # necessary to build mesa
PYTHON_PACKAGES+=" pyyaml"       # necessary to build mesa
PYTHON_PACKAGES+=" setuptools"   # necessary to build mesa (explicitly 'system'-wide unlike the setuptools in termux_setup_python_pip)
# More 'system-wide' python packages should be added here if working towards the goal
# of setup-termux.sh for on-device building having closer behavior
# to setup-ubuntu.sh for cross-compilation. If adding packages here, please add a comment
# for each one naming at least one of its reverse build dependencies, for which least one
# error during on-device building is solved by installing the dependency through pip.
#PYTHON_PACKAGES+=" "

# Definition of a package manager
export TERMUX_SCRIPTDIR=$(dirname "$(realpath "$0")")/../
. $(dirname "$(realpath "$0")")/properties.sh
source "$TERMUX_PREFIX/bin/termux-setup-package-manager" || true

if [ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" ]; then
	apt update
	yes | apt dist-upgrade
	yes | apt install $PACKAGES
elif [ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" ]; then
	pacman -Syu $PACKAGES --needed --noconfirm
else
	echo "Error: no package manager defined"
	exit 1
fi

# Should not be installed inside venv because on Ubuntu cross-builder image, these
# particular python packages are installed system-wide,
# so should be installed Termux-wide for on-device building to be reasonably accurate
# compared with the behavior of the Ubuntu cross-builder image.
pip install --upgrade $PYTHON_PACKAGES
