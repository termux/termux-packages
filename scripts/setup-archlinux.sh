#!/usr/bin/env bash
set -e -u

PACKAGES=""
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor" # Used by weechat for man pages.
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" clang" # Used by golang, useful to have same compiler building.
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" ed" # Used by bc.
PACKAGES+=" expat" # Needed by ghostscript.
PACKAGES+=" flex"
PACKAGES+=" gawk" # Needed by apr-util.
PACKAGES+=" gcc" # Host C/C++ compiler.
PACKAGES+=" gettext" # Provides 'msgfmt'.
PACKAGES+=" git" # Used by the neovim build.
PACKAGES+=" glib2" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" gnupg" # Needed to verify downloaded debs.
PACKAGES+=" gperf" # Used by the fontconfig build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" jre8-openjdk-headless"
PACKAGES+=" jq" # Required for parsing repo.json
PACKAGES+=" re2c" # Needed by kphp-timelib
PACKAGES+=" libjpeg-turbo" # Needed by ghostscript.
PACKAGES+=" libtool"
PACKAGES+=" lua" # Needed to build luarocks package.
PACKAGES+=" lzip"
PACKAGES+=" m4"
PACKAGES+=" openssl"  # Needed to build rust.
PACKAGES+=" patch"
PACKAGES+=" pkgconf"
PACKAGES+=" python"
PACKAGES+=" python-docutils" # For rst2man, used by mpv.
PACKAGES+=" python-recommonmark" # Needed for LLVM-8 documentation.
PACKAGES+=" python-setuptools" # Needed by at least asciinema.
PACKAGES+=" python-sphinx" # Needed by notmuch man page generation.
PACKAGES+=" ruby" # Needed to build ruby.
PACKAGES+=" scdoc" # Needed by aerc.
PACKAGES+=" scons"
PACKAGES+=" tar"
PACKAGES+=" texinfo"
PACKAGES+=" unzip"
PACKAGES+=" xmlto"

# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi
$SUDO pacman -Syq --needed --noconfirm $PACKAGES

. $(dirname "$(realpath "$0")")/properties.sh
$SUDO mkdir -p $TERMUX_PREFIX
$SUDO chown -R $(whoami) /data

echo "Please also install the following packages from the AUR before continuing"
echo
echo "- ncurses5-compat-libs"
echo "- makedepend"
echo "- python2"
