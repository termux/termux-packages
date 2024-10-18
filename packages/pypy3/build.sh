TERMUX_PKG_HOMEPAGE=https://pypy.org
TERMUX_PKG_DESCRIPTION="A fast, compliant alternative implementation of Python 3"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
_MAJOR_VERSION=3.9
TERMUX_PKG_VERSION=7.3.15
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.python.org/pypy/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION-src.tar.bz2
TERMUX_PKG_SHA256=6bb9537d85aa7ad13c0aad2e41ff7fd55080bc9b4d1361b8f502df51db816e18
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libexpat, libffi, liblzma, libsqlite, ncurses, ncurses-ui-libs, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="bionic-host, clang, make, pkg-config, python2, tk, xorgproto"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_SUGGESTS="pypy3-tkinter"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local p="$TERMUX_PKG_BUILDER_DIR/9998-link-against-pypy3-on-testcapi.diff"
	echo "Applying $(basename "${p}")"
	sed 's|@TERMUX_PYPY_MAJOR_VERSION@|'"${_MAJOR_VERSION}"'|g' "${p}" \
		| patch --silent -p1

	p="$TERMUX_PKG_BUILDER_DIR/9999-add-ANDROID_API_LEVEL-for-sysconfigdata.diff"
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

__setup_proot() {
	mkdir -p "$TERMUX_PKG_CACHEDIR"/proot-bin
	termux_download \
		https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-x86_64-static \
		"$TERMUX_PKG_CACHEDIR"/proot-bin/proot \
		d1eb20cb201e6df08d707023efb000623ff7c10d6574839d7bb42d0adba6b4da
	chmod +x "$TERMUX_PKG_CACHEDIR"/proot-bin/proot
	mkdir -p "$TERMUX_PKG_TMPDIR"/proot-tmp-dir
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

__setup_docker_utils() {
	mkdir -p "$TERMUX_PKG_CACHEDIR"/docker-utils
	termux_download \
		https://raw.githubusercontent.com/NotGlop/docker-drag/5413165a2453aa0bc275d7dc14aeb64e814d5cc0/docker_pull.py \
		"$TERMUX_PKG_CACHEDIR"/docker-utils/docker_pull.py \
		04e52b70c862884e75874b2fd229083fdf09a4bac35fc16fd7a0874ba20bd075
	termux_download \
		https://raw.githubusercontent.com/larsks/undocker/649f3fdeb0a9cf8aa794d90d6cc6a7c7698a25e6/undocker.py \
		"$TERMUX_PKG_CACHEDIR"/docker-utils/undocker.py \
		32bc122c53153abeb27491e6d45122eb8cef4f047522835bedf9b4b87877a907
}

__setup_termux_docker_rootfs() {
	__setup_docker_utils

	# Pick up host platform arch
	local __pypy3_host_arch=""
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		__pypy3_host_arch="i686"
	else
		__pypy3_host_arch="x86_64"
	fi

	# Get host platform rootfs tar if needed
	if [ ! -f "$TERMUX_PKG_CACHEDIR/termux_termux-docker_$__pypy3_host_arch.tar" ]; then
		(
			cd "$TERMUX_PKG_CACHEDIR"
			python docker-utils/docker_pull.py termux/termux-docker:$__pypy3_host_arch
			mv termux_termux-docker.tar termux_termux-docker_$__pypy3_host_arch.tar
		)
	fi

	# Download update-static-dns and static-dns-hosts.txt from older termux-docker commit
	mkdir -p "$TERMUX_PKG_CACHEDIR"/termux-docker-utils
	termux_download \
		https://github.com/termux/termux-docker/raw/98af62205f4da832b71bb4de09cb8d6b17ceeaca/static-dns-hosts.txt \
		"$TERMUX_PKG_CACHEDIR"/termux-docker-utils/static-dns-hosts.txt \
		f5e28c8d37dc69e4876372cc05dcfd07aadc8499f5fa05bb6af1cfbff7cd656a
	termux_download \
		https://github.com/termux/termux-docker/raw/98af62205f4da832b71bb4de09cb8d6b17ceeaca/system/arm/bin/update-static-dns \
		"$TERMUX_PKG_CACHEDIR"/termux-docker-utils/update-static-dns \
		14b6ba13506dd90b691e5dbb84bf79ca155837dd43eb05c0e68fbe991c05ee5e

	# Extract host platform rootfs tar
	__pypy3_host_rootfs="$TERMUX_PKG_CACHEDIR/host-termux-rootfs-$__pypy3_host_arch"
	if [ ! -d "$__pypy3_host_rootfs" ]; then
		rm -rf "$__pypy3_host_rootfs".tmp
		mkdir -p "$__pypy3_host_rootfs".tmp
		cat "$TERMUX_PKG_CACHEDIR"/termux_termux-docker_$__pypy3_host_arch.tar | \
			python "$TERMUX_PKG_CACHEDIR"/docker-utils/undocker.py -o "$__pypy3_host_rootfs".tmp
		mkdir -p "$__pypy3_host_rootfs".tmp/"$TERMUX_PREFIX"/bin
		mkdir -p "$__pypy3_host_rootfs".tmp/"$TERMUX_ANDROID_HOME"
		cp "$TERMUX_PKG_CACHEDIR"/termux-docker-utils/static-dns-hosts.txt \
			"$__pypy3_host_rootfs".tmp/system/etc/
		cp "$TERMUX_PKG_CACHEDIR"/termux-docker-utils/update-static-dns \
			"$__pypy3_host_rootfs".tmp/"$TERMUX_PREFIX"/bin/
		cp "$TERMUX_PKG_CACHEDIR"/proot-bin/proot \
			"$__pypy3_host_rootfs".tmp/"$TERMUX_PREFIX"/bin/
		chmod +x "$__pypy3_host_rootfs".tmp/"$TERMUX_PREFIX"/bin/update-static-dns
		rm -f "$__pypy3_host_rootfs".tmp/bin
		rm -f "$__pypy3_host_rootfs".tmp/usr
		rm -f "$__pypy3_host_rootfs".tmp/tmp
		mv "$__pypy3_host_rootfs".tmp "$__pypy3_host_rootfs"
	fi
}

__setup_termux_envs() {
	__pypy3_termux_envs="
ANDROID_DATA=/data
ANDROID_ROOT=/system
HOME=$TERMUX_ANDROID_HOME
LANG=en_US.UTF-8
PATH=$TERMUX_PREFIX/bin
PREFIX=$TERMUX_PREFIX
TMPDIR=$TERMUX_PREFIX/tmp
TERM=$TERM
TZ=UTC"

	__pypy3_run_on_host="
env -i
PROOT_NO_SECCOMP=1
PROOT_TMP_DIR=/tmp
$__pypy3_termux_envs
$TERMUX_PKG_CACHEDIR/proot-bin/proot
-b /proc -b /dev -b /sys
-b $HOME
-b /tmp
-b /data/:/target-termux-rootfs/data/
-b /system/:/target-termux-rootfs/system/
-w $TERMUX_PKG_TMPDIR
-r $__pypy3_host_rootfs/
"

	__pypy3_run_on_target_from_builder="
env -i
PROOT_NO_SECCOMP=1
PROOT_TMP_DIR=/tmp
$__pypy3_termux_envs
$TERMUX_PKG_CACHEDIR/proot-bin/proot
-b /data/:/target-termux-rootfs/data/
-b /system/:/target-termux-rootfs/system/
-w $TERMUX_PKG_TMPDIR
-R /
/usr/bin/env -i
PROOT_NO_SECCOMP=1
PROOT_TMP_DIR=/tmp
$__pypy3_termux_envs
$TERMUX_PKG_CACHEDIR/proot-bin/proot
-b /proc -b /dev -b /sys
-b /bin/bash
-b /lib -b /lib64
-b $HOME
-b /tmp
-w $TERMUX_PKG_TMPDIR
-r /target-termux-rootfs/
"

	__pypy3_run_on_target_from_host="
env -i
PROOT_NO_SECCOMP=1
PROOT_TMP_DIR=/tmp
$__pypy3_termux_envs
$TERMUX_PKG_CACHEDIR/proot-bin/proot
-b /proc -b /dev -b /sys
-b $HOME
-b /tmp
-b $TERMUX_ANDROID_HOME:$TERMUX_ANDROID_HOME
-w $TERMUX_PKG_TMPDIR
-r /target-termux-rootfs/
"

	# Set qemu-user-static if needed
	case "$TERMUX_ARCH" in
		"aarch64" |  "arm")
			__pypy3_run_on_target_from_host+=" -q $TERMUX_PKG_CACHEDIR/qemu-static-bin/qemu-$TERMUX_ARCH-static"
			__pypy3_run_on_target_from_builder+=" -q $TERMUX_PKG_CACHEDIR/qemu-static-bin/qemu-$TERMUX_ARCH-static"
			;;
		*)
			;;
	esac
}

__run_on_host_docker_rootfs() {
	$__pypy3_run_on_host "$@"
}

termux_step_configure() {
	__setup_proot
	__setup_qemu_static_binaries
	__setup_docker_utils
	__setup_termux_docker_rootfs
	__setup_termux_envs

	# Install deps on host termux rootfs if needed
	__run_on_host_docker_rootfs update-static-dns
	__run_on_host_docker_rootfs apt update
	__run_on_host_docker_rootfs apt upgrade -yq -o Dpkg::Options::=--force-confnew
	__run_on_host_docker_rootfs apt update
	__run_on_host_docker_rootfs apt install binutils clang ndk-sysroot ndk-multilib python2 make -y
	__run_on_host_docker_rootfs python2 -m pip install cffi pycparser

	CFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD=1"
	# error: incompatible function pointer types passing 'Signed (*)(void *, const char *, XML_Encoding *)' (aka 'long (*)(void *, const char *, XML_Encoding *)') to parameter of type 'XML_UnknownEncodingHandler' (aka 'int (*)(void *, const char *, XML_Encoding *)') [-Wincompatible-function-pointer-types]
	CFLAGS+=" -Wno-incompatible-function-pointer-types"
}

termux_step_make() {
	mkdir -p "$TERMUX_PKG_SRCDIR"/usession-dir

	__run_on_host_docker_rootfs uname -a
	__run_on_host_docker_rootfs $__pypy3_run_on_target_from_host uname -a

	# (Cross) Translation
	__run_on_host_docker_rootfs \
		env \
		-C "$TERMUX_PKG_SRCDIR"/pypy/goal \
		PYPY_USESSION_DIR="$TERMUX_PKG_SRCDIR/usession-dir" \
		PROOT_TARGET="$__pypy3_run_on_target_from_host" \
		TARGET_CFLAGS="$CFLAGS $CPPFLAGS" \
		TARGET_LDFLAGS="$LDFLAGS" \
		python2 -u ../../rpython/bin/rpython \
				--platform=termux-"$TERMUX_ARCH" \
				--source --no-compile -Ojit \
				targetpypystandalone.py

	# Build
	cd "$TERMUX_PKG_SRCDIR"/usession-dir
	cd "$(ls -C | awk '{print $1}')"/testing_1
	local srcdir="$(pwd)"
	__run_on_host_docker_rootfs \
		env -C "$srcdir" make clean
	__run_on_host_docker_rootfs \
		env -C "$srcdir" make -j$TERMUX_PKG_MAKE_PROCESSES

	# Copy the built files
	cp ./pypy$_MAJOR_VERSION-c "$TERMUX_PKG_SRCDIR"/pypy/goal/pypy$_MAJOR_VERSION-c
	cp ./libpypy$_MAJOR_VERSION-c.so "$TERMUX_PKG_SRCDIR"/pypy/goal/libpypy$_MAJOR_VERSION-c.so
	cp ./libpypy$_MAJOR_VERSION-c.so "$TERMUX_PREFIX"/lib/libpypy$_MAJOR_VERSION-c.so

	echo $__pypy3_run_on_host
	echo $__pypy3_run_on_target_from_host
	echo $__pypy3_run_on_target_from_builder

	# Dummy cc and strip
	rm -rf "$TERMUX_PKG_TMPDIR"/dummy-bin
	mkdir -p "$TERMUX_PKG_TMPDIR"/dummy-bin
	cp "$TERMUX_PKG_BUILDER_DIR"/cc.sh "$TERMUX_PKG_TMPDIR"/dummy-bin/cc
	chmod +x "$TERMUX_PKG_TMPDIR"/dummy-bin/cc
	ln -sf $(command -v llvm-strip) "$TERMUX_PKG_TMPDIR"/dummy-bin/strip

	# Set host-rootfs if needed
	local HOST_ROOTFS=""
	case "$TERMUX_ARCH" in
		"aarch64" |  "arm")
			HOST_ROOTFS="/host-rootfs"
			;;
		*)
			;;
	esac

	# Build cffi imports (Cross exec)
	$__pypy3_run_on_target_from_builder \
		env -i \
		PATH="$TERMUX_PKG_TMPDIR/dummy-bin:$TERMUX_PREFIX/bin" \
		HOST_ROOTFS="$HOST_ROOTFS" \
		TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_STANDALONE_TOOLCHAIN" \
		CC="$TERMUX_PKG_TMPDIR/dummy-bin/cc" \
		LDSHARED="$TERMUX_PKG_TMPDIR/dummy-bin/cc -pthread -shared" \
		CCTERMUX_HOST_PLATFORM="$CCTERMUX_HOST_PLATFORM" \
		CFLAGS="$CFLAGS $CPPFLAGS" \
		LDFLAGS="$LDFLAGS" \
		"$TERMUX_PKG_SRCDIR"/pypy/goal/pypy$_MAJOR_VERSION-c \
			$TERMUX_PKG_SRCDIR/pypy/tool/release/package.py \
			--archive-name=pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION \
			--targetdir=$TERMUX_PKG_SRCDIR \
			--no-embedded-dependencies \
			--no-keep-debug || bash

	rm -f "$TERMUX_PREFIX"/lib/libpypy$_MAJOR_VERSION-c.so
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/opt/pypy3
	unzip -d $TERMUX_PREFIX/opt/ pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION.zip
	mv $TERMUX_PREFIX/opt/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION $TERMUX_PREFIX/opt/pypy3
	ln -sfr $TERMUX_PREFIX/opt/pypy3/bin/pypy3 $TERMUX_PREFIX/bin/
	ln -sfr $TERMUX_PREFIX/opt/pypy3/bin/libpypy3-c.so $TERMUX_PREFIX/lib/
}

termux_step_create_debscripts() {
	# Pre-rm script to cleanup runtime-generated files.
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh

	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	    exit 0
	fi

	echo "Deleting files from site-packages..."
	rm -Rf $TERMUX_PREFIX/opt/pypy3/lib/pypy$_MAJOR_VERSION/site-packages/*

	echo "Deleting *.pyc..."
	find $TERMUX_PREFIX/opt/pypy3/lib/ | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

	exit 0
	PRERM_EOF

	chmod 0755 prerm
}
