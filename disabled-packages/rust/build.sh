TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org
TERMUX_PKG_DESCRIPTION="Systems programming language that runs fast, prevents segfaults, and guarantees thread safety"
TERMUX_PKG_VERSION=1.29.0
#TERMUX_PKG_SHA256=7689c95c0bab42e32eb82c1892785fe53faa8ae89a5c48bdfafb13a43ac8ec7e
#TERMUX_PKG_SRCURL=https://github.com/rust-lang/rust/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="clang"

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone \
			--depth 1 \
			--branch $TERMUX_PKG_VERSION \
			https://github.com/rust-lang/rust.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init --recursive --progress
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
}

termux_step_configure() {
	termux_setup_rust

	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/config.toml \
		| sed "s%\@CARGO_TARGET_NAME\@%${CARGO_TARGET_NAME}%g" - \
		| sed "s%\@CC\@%${CC}%g" - \
		| sed "s%\@CXX\@%${CXX}%g" - \
		| sed "s%\@AR\@%${AR}%g" - \
		> ./config.toml
}

termux_step_make() {
	$TERMUX_PKG_SRCDIR/x.py build
}

termux_step_make_install() {
	$TERMUX_PKG_SRCDIR/x.py install
}
