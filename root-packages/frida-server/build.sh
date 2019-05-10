TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
TERMUX_PKG_LICENSE="wxWindows"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=12.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/frida/frida.git
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"
TERMUX_PKG_HOSTBUILD=yes

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
		git submodule update --init # --depth 1
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER $TERMUX_PKG_SRCDIR
}

termux_step_host_build () {
	local node_version=8.14.0 #9.11.2
	termux_download https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-x64.tar.xz \
			${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz \
			a56d1af4d7da81504338b09809cf10b3144808d47d4117b9bd9a5a4ec4d5d9b9
	tar -xf ${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz --strip-components=1
}

termux_step_make () {
	if [[ ${TERMUX_ARCH} == "aarch64" ]]; then
		arch=arm64
	elif [[ ${TERMUX_ARCH} == "i686" ]]; then
		arch=x86
	else
		arch=${TERMUX_ARCH}
	fi
	# Build only for desired architecture:
	sed -i "s/@TERMUX_ARCH@/$arch/g" ${TERMUX_PKG_SRCDIR}/Makefile.linux.mk
	PATH=${TERMUX_PKG_HOSTBUILD_DIR}/bin:$PATH make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	# Only include frida-server and frida-inject. Is something else useful?
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-server ${TERMUX_PREFIX}/bin/
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-inject ${TERMUX_PREFIX}/bin/
}
