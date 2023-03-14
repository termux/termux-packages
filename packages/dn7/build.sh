TERMUX_PKG_HOMEPAGE=dn7
TERMUX_PKG_DESCRIPTION="dn7"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.5
TERMUX_PKG_SRCURL=git+https://github.com/dotnet/runtime
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="krb5, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -lgssapi_krb5 -lz"
	termux_setup_cmake
	termux_setup_ninja
}

termux_step_make() {
	local arch
	case "$TERMUX_ARCH" in
		aarch64) arch=arm64;;
		arm) arch=arm;;
		i686) arch=x86;;
		x86_64) arch=x64;;
	esac

	find $TERMUX_PREFIX/lib | sort

	rm -fr $TERMUX_PKG_TMPDIR/sysroot
	mkdir -p $TERMUX_PKG_TMPDIR/sysroot
	cp -fr $TERMUX_PREFIX $TERMUX_PKG_TMPDIR/sysroot

	export ROOTFS_DIR=${TERMUX_PKG_TMPDIR}/sysroot
	./build.sh --cross --arch ${arch} --clang14 --configuration Release --subset clr --os linux-bionic
}
