TERMUX_PKG_HOMEPAGE=https://pypy.org
TERMUX_PKG_DESCRIPTION="A fast, compliant alternative implementation of Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
_MAJOR_VERSION=2.7
TERMUX_PKG_VERSION="7.3.20"
TERMUX_PKG_SRCURL=(
	https://downloads.python.org/pypy/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION-src.tar.bz2
	https://downloads.python.org/pypy/pypy2.7-v$TERMUX_PKG_VERSION-linux64.tar.bz2
	https://downloads.python.org/pypy/pypy2.7-v$TERMUX_PKG_VERSION-linux32.tar.bz2
)
TERMUX_PKG_SHA256=(
	bf958498445f7bf78338723c8d86bd6711e8792461725d2481df77a9566a3e62
	aa3bb92dbb529fa2d4920895b16d67a810b0c709207857d56cfe4a6e3b41e02a
	9d554c5efcb6ef80146bb82965f5d8404d6848e6f04b25c378852a095768a69c
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libexpat, libffi, liblzma, libsqlite, ncurses, ncurses-ui-libs, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, tk, xorgproto"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_SUGGESTS="pypy-tkinter"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local p="$TERMUX_PKG_BUILDER_DIR/9999-add-ANDROID_API_LEVEL-for-sysconfigdata.diff"
	echo "Applying $(basename "${p}")"
	sed 's|@TERMUX_PKG_API_LEVEL@|'"${TERMUX_PKG_API_LEVEL}"'|g' "${p}" \
		| patch --silent -p1

	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR"/termux.py.in > \
		"$TERMUX_PKG_SRCDIR"/rpython/translator/platform/termux.py
}

termux_step_pre_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

__setup_host_pypy2() {
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		export PATH="$TERMUX_PKG_SRCDIR/pypy2.7-v$TERMUX_PKG_VERSION-linux32/bin:$PATH"
	else
		export PATH="$TERMUX_PKG_SRCDIR/pypy2.7-v$TERMUX_PKG_VERSION-linux64/bin:$PATH"
	fi

	pypy2 -m ensurepip --altinstall --no-default-pip
	pypy2 -m pip install cparser cffi
}

__setup_proot() {
	mkdir -p "$TERMUX_PKG_CACHEDIR"/proot-bin
	termux_download \
		https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-x86_64-static \
		"$TERMUX_PKG_CACHEDIR"/proot-bin/proot \
		d1eb20cb201e6df08d707023efb000623ff7c10d6574839d7bb42d0adba6b4da
	chmod +x "$TERMUX_PKG_CACHEDIR"/proot-bin/proot
	export PATH="$TERMUX_PKG_CACHEDIR/proot-bin:$PATH"
}

__setup_qemu_static_binaries() {
	mkdir -p "$TERMUX_PKG_CACHEDIR"/qemu-static-bin
	termux_download \
		https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-aarch64-static \
		"$TERMUX_PKG_CACHEDIR"/qemu-static-bin/qemu-aarch64-static \
		dce64b2dc6b005485c7aa735a7ea39cb0006bf7e5badc28b324b2cd0c73d883f
	termux_download \
		https://github.com/multiarch/qemu-user-static/releases/download/v7.2.0-1/qemu-arm-static \
		"$TERMUX_PKG_CACHEDIR"/qemu-static-bin/qemu-arm-static \
		9f07762a3cd0f8a199cb5471a92402a4765f8e2fcb7fe91a87ee75da9616a806
	chmod +x "$TERMUX_PKG_CACHEDIR"/qemu-static-bin/qemu-aarch64-static
	chmod +x "$TERMUX_PKG_CACHEDIR"/qemu-static-bin/qemu-arm-static
	export PATH="$TERMUX_PKG_CACHEDIR/qemu-static-bin:$PATH"
}

termux_step_configure() {
	__setup_host_pypy2
	__setup_proot
	__setup_qemu_static_binaries

	CFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD=1"
	# error: incompatible function pointer types passing 'Signed (*)(void *, const char *, XML_Encoding *)' (aka 'long (*)(void *, const char *, XML_Encoding *)') to parameter of type 'XML_UnknownEncodingHandler' (aka 'int (*)(void *, const char *, XML_Encoding *)') [-Wincompatible-function-pointer-types]
	CFLAGS+=" -Wno-incompatible-function-pointer-types"
}

termux_step_make() {
	mkdir -p "$TERMUX_PKG_SRCDIR"/usession-dir

	local HOST_ROOTFS=""
	local PROOT_TARGET="proot
-b $HOME
-b $TERMUX_PKG_TMPDIR
-b /proc -b /dev -b /sys
-w $TERMUX_PKG_TMPDIR
-r /
"

	# Set qemu-user-static if needed
	case "$TERMUX_ARCH" in
		"aarch64" |  "arm")
			PROOT_TARGET+=" -q $TERMUX_PKG_CACHEDIR/qemu-static-bin/qemu-$TERMUX_ARCH-static"
			HOST_ROOTFS="/host-rootfs"
			;;
		*)
			;;
	esac

	# Set arch32 if needed
	local SETARCH32=()
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		SETARCH32+=(CC="gcc -m32")
		SETARCH32+=("linux32")
	fi

	# (Cross) Translation
	env -i \
		-C "$TERMUX_PKG_SRCDIR"/pypy/goal \
		PATH="$PATH" \
		PYPY_USESSION_DIR="$TERMUX_PKG_SRCDIR/usession-dir" \
		PROOT_TARGET="$PROOT_TARGET" \
		TARGET_CFLAGS="$CFLAGS $CPPFLAGS" \
		TARGET_LDFLAGS="$LDFLAGS" \
		TARGET_CC="$CC" \
		"${SETARCH32[@]}" \
		pypy2 -u ../../rpython/bin/rpython \
				--platform=termux-"$TERMUX_ARCH" \
				--source --no-compile -Ojit \
				targetpypystandalone.py

	# Build
	cd "$TERMUX_PKG_SRCDIR"/usession-dir
	cd "$(ls -C | awk '{print $1}')"/testing_1
	make clean
	make -j$TERMUX_PKG_MAKE_PROCESSES

	# Copy the built files
	cp ./pypy-c "$TERMUX_PKG_SRCDIR"/pypy/goal/pypy-c
	cp ./libpypy-c.so "$TERMUX_PKG_SRCDIR"/pypy/goal/libpypy-c.so

	# Dummy cc and strip
	mkdir -p "$TERMUX_PKG_SRCDIR"/dummy-bin
	cp "$TERMUX_PKG_BUILDER_DIR"/cc.sh "$TERMUX_PKG_SRCDIR"/dummy-bin/cc
	chmod +x "$TERMUX_PKG_SRCDIR"/dummy-bin/cc
	ln -sf $(command -v llvm-strip) "$TERMUX_PKG_SRCDIR"/dummy-bin/strip

	# Build cffi imports (Cross exec)
	$PROOT_TARGET env -i \
				PATH="$TERMUX_PKG_SRCDIR/dummy-bin:$PATH" \
				HOST_ROOTFS="$HOST_ROOTFS" \
				TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_STANDALONE_TOOLCHAIN" \
				CCTERMUX_HOST_PLATFORM="$CCTERMUX_HOST_PLATFORM" \
				CFLAGS="$CFLAGS $CPPFLAGS" \
				LDFLAGS="$LDFLAGS" \
				"$TERMUX_PKG_SRCDIR"/pypy/goal/pypy-c \
					$TERMUX_PKG_SRCDIR/pypy/tool/release/package.py \
					--archive-name=pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION \
					--targetdir=$TERMUX_PKG_SRCDIR \
					--no-embedded-dependencies \
					--no-keep-debug
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/opt/pypy
	unzip -d $TERMUX_PREFIX/opt/ pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION.zip
	mv $TERMUX_PREFIX/opt/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION $TERMUX_PREFIX/opt/pypy
	ln -sfr $TERMUX_PREFIX/opt/pypy/bin/pypy $TERMUX_PREFIX/bin/
	ln -sfr $TERMUX_PREFIX/opt/pypy/bin/libpypy-c.so $TERMUX_PREFIX/lib/
}

termux_step_create_debscripts() {
	# Pre-rm script to cleanup runtime-generated files.
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh

	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	    exit 0
	fi

	echo "Deleting files from site-packages..."
	rm -Rf $TERMUX_PREFIX/opt/pypy/site-packages/*

	echo "Deleting *.pyc..."
	find $TERMUX_PREFIX/opt/pypy/lib-python/ | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
	find $TERMUX_PREFIX/opt/pypy/lib_pypy/ | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

	exit 0
	PRERM_EOF

	chmod 0755 prerm
}
