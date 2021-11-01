TERMUX_PKG_HOMEPAGE=https://github.com/mongodb/mongo
TERMUX_PKG_DESCRIPTION="MongoDB Database"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/mongodb/mongo/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc1363049afe51f52510848acc8799dc228a451bb64c8c11a26a300db9480b0c
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR

	sed -i '/"-ggdb" if not env.TargetOSIs/d' SConstruct

	pip3 install -r etc/pip/compile-requirements.txt

	export SCONSFLAGS="$TERMUX_PKG_EXTRA_MAKE_ARGS"
	python3 buildscripts/scons.py install-mongod MONGO_VERSION="$TERMUX_PKG_VERSION" --disable-warnings-as-errors

	echo "BUILDED MONGODB!"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	scons install MONGO_VERSION="$TERMUX_PKG_VERSION" --prefix="$TERMUX_PREFIX"
}
