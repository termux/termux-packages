TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
TERMUX_PKG_LICENSE="wxWindows"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=17
_MINOR_VERSION=2
_MICRO_VERSION=14
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}.${_MICRO_VERSION}
TERMUX_PKG_REVISION=2
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/frida/frida
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_CONFFILES="var/service/frida-server/run var/service/frida-server/down"
TERMUX_PKG_RM_AFTER_INSTALL="share/gir-1.0/G*"
TERMUX_PKG_CONFLICTS="frida-tools (<< 15.1.24-1)"
TERMUX_PKG_BREAKS="frida-server (<< 15.1.24)"
TERMUX_PKG_REPLACES="frida-tools (<< 15.1.24-1), frida-server (<< 15.1.24)"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-server
--enable-frida-python
--enable-frida-tools
"

termux_step_host_build() {
	termux_setup_nodejs

	# make and save frida-resource-compiler and quickcompile in
	# hostbuild step, otherwise the ones that are compiled in
	# termux_step_make segfaults when compiled with ld.lld from
	# termux's toolchain
	cp -a $TERMUX_PKG_SRCDIR/subprojects/frida-core $TERMUX_PKG_HOSTBUILD_DIR/
	make -C frida-core

	cp frida-core/build/tools/frida-resource-compiler \
		$TERMUX_PKG_HOSTBUILD_DIR/

	cp frida-core/build/subprojects/frida-gum/bindings/gumjs/quickcompile \
		$TERMUX_PKG_HOSTBUILD_DIR/
}

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_nodejs
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR":"$PATH"
	export ANDROID_NDK_ROOT="${NDK}"

	local patch="${TERMUX_PKG_BUILDER_DIR}/ndk-version-and-api-level.diff"
	echo "Applying patch: $(basename $patch)"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" \
		-e "s%\@TERMUX_NDK_VERSION_NUM\@%${TERMUX_NDK_VERSION_NUM}%g" \
		"$patch" | patch --silent -p1 -d "${TERMUX_PKG_SRCDIR}"

	# allows repeated builds of frida by removing some files of
	# the previously-installed build of frida from $TERMUX_PREFIX
	# Prevents the error:
	# ...files/usr/lib/libfrida-gum-1.0.a(meson-generated_.._gumenumtypes.c.o)
	# is incompatible with armelf_linux_eabi
	rm -rf "$TERMUX_PREFIX"/lib/pkgconfig/frida*

	# Frida needs to get cflags and ldflags for our python, but we
	# do not want it to pick up other dependencies as frida has
	# its own fork of quite a few libraries, so hack around it by
	# copying the python pc file to TMPDIR
	ln -sf "$TERMUX_PREFIX"/lib/pkgconfig/python-"${TERMUX_PYTHON_VERSION}".pc \
		"$TERMUX_PKG_TMPDIR/"
	export PKG_CONFIG_PATH="$TERMUX_PKG_TMPDIR"

	if [[ $TERMUX_ARCH == "aarch64" ]]; then
		FRIDA_ARCH=arm64
	elif [[ $TERMUX_ARCH == "i686" ]]; then
		FRIDA_ARCH=x86
	else
		FRIDA_ARCH=${TERMUX_ARCH}
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=android-${FRIDA_ARCH}"

	if [ "$TERMUX_DEBUG_BUILD" = true ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-symbols"
	fi
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure \
		--prefix $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_configure() {
	# frida's glib uses pidfd_open syscall, which will not work on
	# android. To work around issue we build glib in
	# post_configure and replace the library that was fetched as
	# part of the sdk in the configure step.
	local _FRIDA_GLIB_COMMIT=8f43c78bc4f6a510c610c7738fdf23ecf99c6be8
	git clone https://github.com/frida/glib \
		$TERMUX_PKG_SRCDIR/subprojects/glib
	cd $TERMUX_PKG_SRCDIR/subprojects/glib
	git checkout ${_FRIDA_GLIB_COMMIT}
	patch -d $TERMUX_PKG_SRCDIR -Np1 \
		-i $TERMUX_PKG_BUILDER_DIR/glib-no-pidfd_open-syscall.diff
	cd $TERMUX_PKG_BUILDDIR

	local _meson_buildtype="minsize"
	local _meson_stripflag="--strip"
	local _GLIB_EXTRA_CONFIGURE_ARGS="
		-Dcocoa=disabled
		-Dselinux=disabled
		-Dxattr=false
		-Dlibmount=disabled
		-Dtests=false
		--force-fallback-for=pcre
		-Diconv=external
		-Ddefault_library=static
	"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_meson_buildtype="debug"
		_meson_stripflag=
	else
		_GLIB_EXTRA_CONFIGURE_ARGS+="
			-Dglib_debug=disabled
			-Dglib_assert=false
			-Dglib_checks=false
		"
	fi
	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		setup \
		$TERMUX_PKG_SRCDIR/subprojects/glib \
		$TERMUX_PKG_BUILDDIR/subprojects/glib \
		--$(test "${TERMUX_PKG_MESON_NATIVE}" = "true" && echo "native-file" || echo "cross-file") $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PREFIX \
		--libdir $(test "${TERMUX_ARCH}" = "${TERMUX_REAL_ARCH}" && echo "lib" || echo "lib32") \
		--includedir $(test "${TERMUX_ARCH}" = "${TERMUX_REAL_ARCH}" && echo "include" || echo "include32") \
		--buildtype ${_meson_buildtype} \
		${_meson_stripflag} \
		$_GLIB_EXTRA_CONFIGURE_ARGS

	ninja -C $TERMUX_PKG_BUILDDIR/subprojects/glib

	ls -l $TERMUX_PKG_BUILDDIR/subprojects/glib/glib/libglib-2.0.a \
		$TERMUX_PKG_SRCDIR/deps/sdk-android-${FRIDA_ARCH}/lib/libglib-2.0.a \
		$TERMUX_PKG_SRCDIR/deps/sdk-linux-x86_64/lib/libglib-2.0.a
	install $TERMUX_PKG_BUILDDIR/subprojects/glib/glib/libglib-2.0.a \
		$TERMUX_PKG_SRCDIR/deps/sdk-android-${FRIDA_ARCH}/lib/libglib-2.0.a
}

termux_step_post_make_install () {
	# Fixup installation location..
	rm -rf "$TERMUX_PREFIX"/lib/python"${TERMUX_PYTHON_VERSION}"/site-packages/frida*
	mv "$TERMUX_PREFIX"/lib/python3/dist-packages/frida* \
		"$TERMUX_PREFIX"/lib/python"${TERMUX_PYTHON_VERSION}"/site-packages/

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
