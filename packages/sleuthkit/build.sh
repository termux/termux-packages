TERMUX_PKG_HOMEPAGE=https://sleuthkit.org/
TERMUX_PKG_DESCRIPTION="The Sleuth Kit® (TSK) is a library for digital forensics tools. "
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/*"
TERMUX_PKG_VERSION=4.9.0
TERMUX_PKG_SRCURL=https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00faf25c8ffd9271b1c144586a4197fa3ed4cefa70adab1d73ad39376ae009fe
TERMUX_PKG_DEPENDS="libsqlite, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-java"

termux_step_pre_configure() {
	./bootstrap
}
