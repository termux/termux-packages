TERMUX_PKG_HOMEPAGE=https://sleuthkit.org/
TERMUX_PKG_DESCRIPTION="The Sleuth Kit® (TSK) is a library and collection of command line digital forensics tools that allow you to investigate volume and file system data. "
TERMUX_PKG_LICENSE="MIT and BSD 3-clause" #have other
TERMUX_PKG_VERSION=4.9.0
TERMUX_PKG_SRCURL=https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00faf25c8ffd9271b1c144586a4197fa3ed4cefa70adab1d73ad39376ae009fe
TERMUX_PKG_DEPENDS="libsqlite, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true



termux_step_install_license() {
        for filename in $TERMUX_PKG_SRCDIR/licenses/*; do 
	        install -Dm600 "$filename" \
	        	"$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/licenses"
        done
}
