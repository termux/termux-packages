TERMUX_PKG_HOMEPAGE=https://github.com/mongodb/mongo
TERMUX_PKG_DESCRIPTION="MongoDB Database"
TERMUX_PKG_LICENSE="MIT" # Edit this
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/mongodb/mongo/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04441784c364caf6d2603307c93c21c3b55808d0a3efae00bd34b4edf37e492d

termux_step_make() {
	termux_setup_scons

	cd $TERMUX_PKG_SRCDIR

	python3 -m pip install -r etc/pip/compile-requirements.txt

	sed -i '/"-ggdb" if not env.TargetOSIs/d' SConstruct

	export SCONSFLAGS="$MAKEFLAGS"

	scons core
}

termux_step_make_install() {
	scons install --prefix="$TERMUX_PREFIX/usr"
}
