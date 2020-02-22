TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
TERMUX_PKG_LICENSE="wxWindows"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=12
_MINOR_VERSION=8
_MICRO_VERSION=11
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}.${_MICRO_VERSION}
TERMUX_PKG_SRCURL=https://github.com/frida/frida.git
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"
TERMUX_PKG_HOSTBUILD=true

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch $TERMUX_PKG_VERSION \
			$TERMUX_PKG_SRCURL \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init --recursive
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER $TERMUX_PKG_SRCDIR
}

termux_step_host_build () {
	local node_version=13.8.0
	termux_download https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-x64.tar.xz \
			${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz \
			47a8cb675358f2ff534ad3d6709f14de0433f76d3af92cf389b8dcc78a1236ad
	tar -xf ${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz --strip-components=1
}

termux_step_post_configure () {
	# frida-version.h is normally generated from git and the commits.
	sed -i "s/@TERMUX_PKG_VERSION@/$TERMUX_PKG_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MAJOR_VERSION@/$_MAJOR_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MINOR_VERSION@/$_MINOR_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MICRO_VERSION@/$_MICRO_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
}

termux_step_make () {
	if [[ ${TERMUX_ARCH} == "aarch64" ]]; then
		arch=arm64
	elif [[ ${TERMUX_ARCH} == "i686" ]]; then
		arch=x86
	else
		arch=${TERMUX_ARCH}
	fi
	PATH=${TERMUX_PKG_HOSTBUILD_DIR}/bin:$PATH make core-android-${arch} ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	# Only include frida-server and frida-inject. Is something else useful?
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-server ${TERMUX_PREFIX}/bin/
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-inject ${TERMUX_PREFIX}/bin/
}
