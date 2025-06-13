TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/shepherd/
TERMUX_PKG_DESCRIPTION='The Shepherd—extensible service manager'
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SRCURL=https://codeberg.org/shepherd/shepherd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f09f0dab1fd0cd11988e5069be96eb3601182e94db7fed8cf328f99de506306c
TERMUX_PKG_DEPENDS="guile, guile-fibers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gzip=$TERMUX_PREFIX/bin/gzip --with-zstd=$TERMUX_PREFIX/bin/zstd"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/reboot
bin/halt
bin/shutdown
share/man/man8/halt.8
share/man/man8/reboot.8
"

termux_step_pre_configure() {
	autoreconf -vif
	export GUILE_AUTO_COMPILE=0
	export GUILE_LOAD_COMPILED_PATH="$(realpath $TERMUX_PREFIX/lib/guile/*/site-ccache)"
	export GUILE_LOAD_PATH="$(realpath $TERMUX_PREFIX/share/guile/site/*)"
	export GUILE_EXTENSIONS_PATH="$(realpath $TERMUX_PREFIX/lib/guile/*/extensions)"
}
