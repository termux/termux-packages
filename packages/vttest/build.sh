TERMUX_PKG_HOMEPAGE=https://invisible-island.net/vttest/
TERMUX_PKG_DESCRIPTION="Program for testing the VT100 compatibility of terminal emulators"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=20190105
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=5703ef4783c8eb90b30205740c585652fa779ea28bdd876a2af81af6b9574f71
# vttest does not use a version in the tar URL, but we will detect
# an update with a checksum mismatch.
TERMUX_PKG_SRCURL=http://invisible-island.net/datafiles/release/vttest.tar.gz
