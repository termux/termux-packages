TERMUX_PKG_HOMEPAGE=https://github.com/mongodb/mongo
TERMUX_PKG_DESCRIPTION="MongoDB Database"
TERMUX_PKG_LICENSE="MIT" # Edit this
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/mongodb/mongo/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc1363049afe51f52510848acc8799dc228a451bb64c8c11a26a300db9480b0c

termux_step_make() {
	pip install scons

	cd $TERMUX_PKG_SRCDIR

	pip install -r etc/pip/compile-requirements.txt

	sed -i '/"-ggdb" if not env.TargetOSIs/d' SConstruct

	export SCONSFLAGS="$MAKEFLAGS"

	scons core
}

termux_step_make_install() {
	scons install --prefix="$TERMUX_PREFIX/usr"
}
