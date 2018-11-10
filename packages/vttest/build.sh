TERMUX_PKG_HOMEPAGE=http://invisible-island.net/vttest/
TERMUX_PKG_DESCRIPTION="Program for testing the VT100 compatibility of terminal emulators"
TERMUX_PKG_VERSION=20180911
TERMUX_PKG_SHA256=91571f0a9df6220c6fc3da74bd017abbf472f2ccd2e102143cfbe960badb2c6b
# vttest does not use a version in the tar URL, but we will detect
# an update with a checksum mismatch.
TERMUX_PKG_SRCURL=http://invisible-island.net/datafiles/release/vttest.tar.gz
