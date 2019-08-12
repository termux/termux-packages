TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=2.3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=1
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/tsu-checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch master \
			https://github.com/cswl/tsu.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git fetch --all --tags --prune
		git checkout "tags/v$TERMUX_PKG_VERSION" -b "$TERMUX_PKG_VERSION"
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
}

termux_step_make() {
	:
}

termux_step_make_install() {
	cp tsu $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu

	cp tsudo $TERMUX_PREFIX/bin/tsudo
	chmod +x $TERMUX_PREFIX/bin/tsudo
}
