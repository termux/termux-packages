TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
TERMUX_PKG_LICENSE="wxWindows"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=16
_MINOR_VERSION=0
_MICRO_VERSION=2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}.${_MICRO_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/frida/frida
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$NDK"
TERMUX_PKG_CONFFILES="var/service/frida-server/run var/service/frida-server/down"
TERMUX_PKG_CONFLICTS="frida-tools (<< 15.1.24-1)"
TERMUX_PKG_BREAKS="frida-server (<< 15.1.24)"
TERMUX_PKG_REPLACES="frida-tools (<< 15.1.24-1), frida-server (<< 15.1.24)"

termux_step_pre_configure () {
	termux_setup_nodejs

	export TERMUX_PKG_EXTRA_MAKE_ARGS+=" PYTHON=/usr/bin/python${TERMUX_PYTHON_VERSION}"
	sed -e "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		-e "s%@PYTHON_VERSION@%$TERMUX_PYTHON_VERSION%g" \
		$TERMUX_PKG_BUILDER_DIR/frida-python-version.diff | patch -Np1
}

termux_step_make () {
	if [[ ${TERMUX_ARCH} == "aarch64" ]]; then
		arch=arm64
	elif [[ ${TERMUX_ARCH} == "i686" ]]; then
		arch=x86
	else
		arch=${TERMUX_ARCH}
	fi

	CC=gcc CXX=g++ make python-android-${arch} ${TERMUX_PKG_EXTRA_MAKE_ARGS}
	CC=gcc CXX=g++ make tools-android-${arch} ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	install build/frida-android-${arch}/bin/frida \
		build/frida-android-${arch}/bin/frida-apk \
		build/frida-android-${arch}/bin/frida-create \
		build/frida-android-${arch}/bin/frida-discover \
		build/frida-android-${arch}/bin/frida-inject \
		build/frida-android-${arch}/bin/frida-kill \
		build/frida-android-${arch}/bin/frida-ls-devices \
		build/frida-android-${arch}/bin/frida-portal \
		build/frida-android-${arch}/bin/frida-ps \
		build/frida-android-${arch}/bin/frida-server \
		build/frida-android-${arch}/bin/frida-trace \
		build/frida-android-${arch}/bin/gum-graft \
		${TERMUX_PREFIX}/bin/
	install build/frida-android-${arch}/lib/{*.so,*.a} ${TERMUX_PREFIX}/lib/
	cp -r build/frida-android-${arch}/lib/{pkgconfig,python*} ${TERMUX_PREFIX}/lib/
	cp -r build/frida-android-${arch}/include/frida-* ${TERMUX_PREFIX}/include/
	cp -r build/frida-android-${arch}/share/vala ${TERMUX_PREFIX}/share/
}

termux_step_post_make_install () {
	# Setup termux-services scripts
	mkdir -p $TERMUX_PREFIX/var/service/frida-server/log
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "unset LD_PRELOAD"
		echo "exec su -c $TERMUX_PREFIX/bin/frida-server 2>&1"
	} > $TERMUX_PREFIX/var/service/frida-server/run

	# Unfortunately, running sv down frida-server just kills the "su" process but leaves frida-server
	# running (even though it is running in the foreground). This finish script works around that.
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "su -c pkill -9 frida-server"
	} > $TERMUX_PREFIX/var/service/frida-server/finish
	chmod u+x $TERMUX_PREFIX/var/service/frida-server/run $TERMUX_PREFIX/var/service/frida-server/finish

	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger $TERMUX_PREFIX/var/service/frida-server/log/run

	touch $TERMUX_PREFIX/var/service/frida-server/down
}
