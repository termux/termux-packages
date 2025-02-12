TERMUX_PKG_HOMEPAGE=https://gitlab.winehq.org/mono/mono
TERMUX_PKG_DESCRIPTION="Framework Mono"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.12.0.206"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://gitlab.winehq.org/mono/mono
TERMUX_PKG_GIT_BRANCH=mono-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="krb5, zlib"
TERMUX_PKG_HOSTBUILD=true
# https://github.com/mono/mono/issues/21796
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-btls
--without-ikvm-native
"

termux_step_host_build() {
	termux_setup_cmake

	pushd $TERMUX_PKG_SRCDIR
	NOCONFIGURE=1 ./autogen.sh
	popd

	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	$TERMUX_PKG_SRCDIR/configure --prefix=$_PREFIX_FOR_BUILD \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", mono-libs"

	termux_setup_cmake

	if [ "$TERMUX_ARCH" == "arm" ]; then
		CFLAGS="${CFLAGS//-mthumb/}"
	fi
	LDFLAGS+=" -lgssapi_krb5"

	NOCONFIGURE=1 ./autogen.sh
}

termux_step_post_make_install() {
	pushd $TERMUX_PKG_HOSTBUILD_DIR/prefix/lib/mono
	find . -name '*.so' -exec rm -f \{\} \;
	rm -f ./4.5/mono-shlib-cop.exe.config
	cp -rT . $TERMUX_PREFIX/lib/mono
	popd

	# Strip off SOVERSION suffix for shared libraries.
	sed -i -E 's/\.so\.[0-9]+/.so/g' $TERMUX_PREFIX/etc/mono/config
}
