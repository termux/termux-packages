TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
TERMUX_PKG_LICENSE="wxWindows"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=12
_MINOR_VERSION=11
_MICRO_VERSION=6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}.${_MICRO_VERSION}
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=https://github.com/frida/frida.git
TERMUX_PKG_DEPENDS="libiconv, python"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$NDK"

termux_step_pre_configure () {
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	export TERMUX_PKG_EXTRA_MAKE_ARGS+=" PYTHON=/usr/bin/python${_PYTHON_VERSION}"
}

termux_step_host_build () {
	local node_version=14.6.0
	termux_download https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-x64.tar.xz \
			${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz \
			b8a39b2dac8e200e96586356c5525d20b0b43dba8bf9f7eb4e8c2d5366be2bb2
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
	CC= CXX= PATH=${TERMUX_PKG_HOSTBUILD_DIR}/bin:$PATH \
		make python-android-${arch} ${TERMUX_PKG_EXTRA_MAKE_ARGS}
	CC= CXX= PATH=${TERMUX_PKG_HOSTBUILD_DIR}/bin:$PATH \
		make tools-android-${arch} ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	install build/frida-android-${arch}/bin/frida-server \
	        build/frida-android-${arch}/bin/frida-inject \
	        build/frida-android-${arch}/bin/frida-discover \
	        build/frida-android-${arch}/bin/frida \
	        build/frida-android-${arch}/bin/frida-kill \
	        build/frida-android-${arch}/bin/frida-ls-devices \
	        build/frida-android-${arch}/bin/frida-ps \
	        build/frida-android-${arch}/bin/frida-trace \
	        ${TERMUX_PREFIX}/bin/
	install build/frida-android-${arch}/lib/{frida-gadget.so,libfrida-gumpp-*.so} ${TERMUX_PREFIX}/lib/
	cp -r build/frida-android-${arch}/lib/{pkgconfig,python*} ${TERMUX_PREFIX}/lib/
	cp -r build/frida-android-${arch}/include/{capstone,frida-*} ${TERMUX_PREFIX}/include/
	cp -r build/frida-android-${arch}/share/vala ${TERMUX_PREFIX}/share/
}
