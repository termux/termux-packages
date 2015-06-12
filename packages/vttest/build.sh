TERMUX_PKG_HOMEPAGE=http://invisible-island.net/vttest/
TERMUX_PKG_DESCRIPTION="Program for testing the VT100 compatibility of terminal emulators"
TERMUX_PKG_VERSION=20140305
# vttest does not use a version in the tar URL, but we will detect an update when TERMUX_PKG_FOLDERNAME no longer matches
TERMUX_PKG_SRCURL=http://invisible-island.net/datafiles/release/vttest.tar.gz
TERMUX_PKG_FOLDERNAME=vttest-${TERMUX_PKG_VERSION}
