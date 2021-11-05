TERMUX_PKG_HOMEPAGE=https://github.com/mongodb/mongo
TERMUX_PKG_DESCRIPTION="MongoDB Database"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/mongodb/mongo/archive/refs/tags/r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc1363049afe51f52510848acc8799dc228a451bb64c8c11a26a300db9480b0c
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	termux_setup_ninja
	cd $TERMUX_PKG_SRCDIR

	echo $CCTERMUX_HOST_PLATFORM

	local TARGET_ARCH
	if [ $TERMUX_ARCH = "aarch64" ]; then
		TARGET_ARCH="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		TARGET_ARCH="x64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	sed -i '/"-ggdb" if not env.TargetOSIs/d' SConstruct

	pip3 install -r etc/pip/compile-requirements.txt

	python3 buildscripts/scons.py install-core \
		CC=$CC \
		CXX=$CXX \
		TARGET_ARCH=$TARGET_ARCH \
		HOST_ARCH="x86_64" \
		MONGO_VERSION="$TERMUX_PKG_VERSION" \
		DESTDIR="$TERMUX_PREFIX" \
		--ninja \
		--disable-warnings-as-errors | cat /home/builder/.termux-build/mongodb/src/build/scons/config.log
}
