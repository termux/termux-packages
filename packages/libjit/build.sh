TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libjit/
TERMUX_PKG_DESCRIPTION="Just-In-Time compiler library."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.1.4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone \
                        --branch v$TERMUX_PKG_VERSION \
			https://git.savannah.gnu.org/git/libjit.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init # --depth 1
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
}

termux_step_host_build() {
	cd $TERMUX_PKG_SRCDIR
	./bootstrap
}
