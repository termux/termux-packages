TERMUX_PKG_HOMEPAGE=http://invisible-island.net/vttest/
TERMUX_PKG_DESCRIPTION="Program for testing the VT100 compatibility of terminal emulators"
TERMUX_PKG_VERSION=20180811
TERMUX_PKG_SHA256=2ee8ecad0185fbd9fad4d192f04f93ac3c5b705aef85d4a4b92d26c5a71f8ed6
# vttest does not use a version in the tar URL, but we will detect
# an update with a checksum mismatch.
TERMUX_PKG_SRCURL=http://invisible-island.net/datafiles/release/vttest.tar.gz
