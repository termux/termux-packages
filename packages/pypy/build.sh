TERMUX_PKG_HOMEPAGE=https://pypy.org
TERMUX_PKG_DESCRIPTION="A fast, compliant alternative implementation of Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.7
TERMUX_PKG_VERSION=7.3.6
TERMUX_PKG_SRCURL=https://downloads.python.org/pypy/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION-src.tar.bz2
TERMUX_PKG_SHA256=0114473c8c57169cdcab1a69c60ad7fef7089731fdbe6f46af55060b29be41e4
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libexpat, libffi, liblzma, libsqlite, libxml2, ncurses, ncurses-ui-libs, openssl, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="binutils, clang, dash, make, pkg-config, python2, tk"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_SUGGESTS="pypy-tkinter"
TERMUX_PKG_BREAKS="pypy-dev"
TERMUX_PKG_REPLACES="pypy-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
opt/pypy/lib-python/${_MAJOR_VERSION}/test
opt/pypy/lib-python/${_MAJOR_VERSION}/*/test
opt/pypy/lib-python/${_MAJOR_VERSION}/*/tests
"

_docker_pull_url=https://raw.githubusercontent.com/NotGlop/docker-drag/5413165a2453aa0bc275d7dc14aeb64e814d5cc0/docker_pull.py
_docker_pull_checksums=04e52b70c862884e75874b2fd229083fdf09a4bac35fc16fd7a0874ba20bd075
_undocker_url=https://raw.githubusercontent.com/larsks/undocker/649f3fdeb0a9cf8aa794d90d6cc6a7c7698a25e6/undocker.py
_undocker_checksums=32bc122c53153abeb27491e6d45122eb8cef4f047522835bedf9b4b87877a907
_proot_url=https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-x86_64-static
_proot_checksums=d1eb20cb201e6df08d707023efb000623ff7c10d6574839d7bb42d0adba6b4da

termux_step_pre_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	DOCKER_PULL="python $TERMUX_PKG_CACHEDIR/docker_pull.py"
	UNDOCKER="python $TERMUX_PKG_CACHEDIR/undocker.py"
	PROOT="$TERMUX_PKG_CACHEDIR/proot"

	# Get docker_pull.py
	termux_download \
		$_docker_pull_url \
		$TERMUX_PKG_CACHEDIR/docker_pull.py \
		$_docker_pull_checksums

	# Get undocker.py
	termux_download \
		$_undocker_url \
		$TERMUX_PKG_CACHEDIR/undocker.py \
		$_undocker_checksums
	
	# Get proot
	termux_download \
		$_proot_url \
		$TERMUX_PKG_CACHEDIR/proot \
		$_proot_checksums
	
	chmod +x $TERMUX_PKG_CACHEDIR/proot
	
	# Pick up host platform arch.
	HOST_ARCH=$TERMUX_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		HOST_ARCH="i686"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		HOST_ARCH="x86_64"
	fi

	# Get host platform rootfs tar if needed.
	if [ ! -f "$TERMUX_PKG_CACHEDIR/kcubeterm_termux_$HOST_ARCH.tar" ]; then
		(
			cd $TERMUX_PKG_CACHEDIR
			$DOCKER_PULL kcubeterm/termux:$HOST_ARCH
			mv kcubeterm_termux.tar kcubeterm_termux_$HOST_ARCH.tar
		)
	fi

	# Get target platform rootfs tar if needed.
	if [ $HOST_ARCH != $TERMUX_ARCH ]; then
		if [ ! -f "$TERMUX_PKG_CACHEDIR/kcubeterm_termux_$TERMUX_ARCH.tar" ]; then
			(
				cd $TERMUX_PKG_CACHEDIR
				$DOCKER_PULL kcubeterm/termux:$TERMUX_ARCH
				mv kcubeterm_termux.tar kcubeterm_termux_$TERMUX_ARCH.tar
			)
		fi
	fi
}

termux_step_configure() {
	PYPY_USESSION_DIR=$TERMUX_ANDROID_HOME/tmp
	PYPY_SRC_DIR=$TERMUX_ANDROID_HOME/src

	# Bootstrap a proot rootfs for the host platform
	HOST_ROOTFS_BASE=$TERMUX_PKG_TMPDIR/host-rootfs
	cat "$TERMUX_PKG_CACHEDIR/kcubeterm_termux_$HOST_ARCH.tar" | $UNDOCKER -o $HOST_ROOTFS_BASE

	# Add build dependicies for pypy on the host platform rootfs
	# Build essential
	BUILD_DEP="binutils binutils-gold clang file patch pkg-config python2"
	# Build dependencies for pypy
	BUILD_DEP+=" gdbm libandroid-posix-semaphore libandroid-support libbz2"
	BUILD_DEP+=" libcrypt libexpat libffi liblzma libsqlite libxml2 ncurses"
	BUILD_DEP+=" ncurses-ui-libs openssl readline zlib tk xorgproto dash"
	BUILD_DEO+=" ndk-sysroot"

	# Environment variables for termux
	TERMUX_RUNTIME_ENV_VARS="ANDROID_DATA=/data
			ANDROID_ROOT=/system
			HOME=$TERMUX_ANDROID_HOME
			LANG=en_US.UTF-8
			PATH=$TERMUX_PREFIX/bin
			PREFIX=$TERMUX_PREFIX
			TMPDIR=$TERMUX_PREFIX/tmp
			TZ=UTC"

	PROOT_HOST="env -i PROOT_NO_SECCOMP=1
						$TERMUX_RUNTIME_ENV_VARS
						$PROOT 
						-b /proc -b /dev -b /sys
						-b /:$TERMUX_ANDROID_HOME/ndk-rootfs
						-b $TERMUX_PKG_SRCDIR:$PYPY_SRC_DIR
						-w $TERMUX_ANDROID_HOME
						-r $HOST_ROOTFS_BASE/"
	$PROOT_HOST update-static-dns
	$PROOT_HOST pkg install -yq $BUILD_DEP
	$PROOT_HOST python2 -m pip install pycparser

	# Copy the statically-built proot
	cp $PROOT $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/

	# Copy the fake CC
	cp $TERMUX_PKG_BUILDER_DIR/remote_cc.py $TERMUX_PKG_SRCDIR/
	chmod +x $TERMUX_PKG_SRCDIR/remote_cc.py

	# Extract the target platform rootfs to the host platform rootfs if needed.
	PROOT_TARGET=""
	if [ $HOST_ARCH != $TERMUX_ARCH ]; then
		cp /usr/bin/qemu-$TERMUX_ARCH-static $HOST_ROOTFS_BASE/$TERMUX_PREFIX/bin/
		mkdir -p $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs
		cat "$TERMUX_PKG_CACHEDIR/kcubeterm_termux_$TERMUX_ARCH.tar" | $UNDOCKER -o $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs
		# XXX: Copy these things since network is not avaliable in the aarch64 proot, but this may be the
		# XXX: reason why `ctypes.util.find_library` under proot cannot find some libs, such as `sqlite3`.
		# XXX: Maybe we can compile a statically-linked aarch64 busybox and replace /system/bin/busybox
		# XXX: later to make the `update-static-dns` script avaliable.
		cp -rf $TERMUX_PREFIX/* $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs/$TERMUX_PREFIX/
		# Use the fake cc to provide $TERMUX_PREFIX/bin/cc
		rm -f $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs/$TERMUX_PREFIX/bin/cc
		ln -sf $PYPY_SRC_DIR/remote_cc.py $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs/$TERMUX_PREFIX/bin/cc
		PROOT_TARGET="env -i PROOT_NO_SECCOMP=1
					$TERMUX_RUNTIME_ENV_VARS
					$TERMUX_ANDROID_HOME/proot
					-q qemu-$TERMUX_ARCH-static
					-b $TERMUX_ANDROID_HOME
					-w $TERMUX_ANDROID_HOME
					-R $TERMUX_ANDROID_HOME/target-rootfs"
		# Use dash to provide /system/bin/sh, since /system/bin/sh is a symbolic link
		# to /system/bin/busybox which is an arm binary rather than an aarch64 one.
		rm -f $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs/system/bin/sh
		$PROOT_HOST $PROOT_TARGET ln -sf $TERMUX_ANDROID_HOME/bin/dash /system/bin/sh
		$PROOT_HOST $PROOT_TARGET uname -a
	fi

	# XXX: If termux's clang could cross-compile, this may be not necessary.
	PROOT_NDK="env -i PROOT_NO_SECCOMP=1
						HOME=$HOME
						PATH=$PATH
						LD_LIBRARY_PATH=$TERMUX_STANDALONE_TOOLCHAIN/lib64
						$TERMUX_ANDROID_HOME/proot
						-b $TERMUX_ANDROID_HOME
						-b /dev -b /sys -b /proc
						-w $HOME
						-r $TERMUX_ANDROID_HOME/ndk-rootfs"
	$PROOT_HOST $PROOT_NDK uname -a
}

termux_step_make() {
	mkdir -p $HOST_ROOTFS_BASE/$PYPY_USESSION_DIR

	# Translation
	$PROOT_HOST env -i \
			-C $PYPY_SRC_DIR/pypy/goal \
			$TERMUX_RUNTIME_ENV_VARS \
			PYPY_USESSION_DIR=$PYPY_USESSION_DIR \
			TERMUX_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN \
			PROOT_TARGET="$PROOT_TARGET" \
			PROOT_NDK="$PROOT_NDK" \
			$TERMUX_PREFIX/bin/python2 -u ../../rpython/bin/rpython \
					--platform=termux-$TERMUX_ARCH \
					--source --no-compile -Ojit \
					targetpypystandalone.py

	# Build
	mkdir -p $TERMUX_ANDROID_HOME
	ln -s $TERMUX_PKG_SRCDIR $PYPY_SRC_DIR
	cd $HOST_ROOTFS_BASE/$PYPY_USESSION_DIR
	cd $(ls -C | awk '{print $1}')/testing_1
	make clean
	make -j$TERMUX_MAKE_PROCESSES

	# Copy the built files
	cp ./pypy-c $TERMUX_PKG_SRCDIR/pypy/goal/pypy-c
	cp ./libpypy-c.so $TERMUX_PKG_SRCDIR/pypy/goal/libpypy-c.so

	# Build cffi imports
	# TODO: _ssl ffi package may need to be linked against openssl-1.1
	cp $PROOT $TERMUX_ANDROID_HOME/
	ln -s $HOST_ROOTFS_BASE/$TERMUX_ANDROID_HOME/target-rootfs $TERMUX_ANDROID_HOME/
	PROOT_CFFI=""
	if [ $HOST_ARCH == $TERMUX_ARCH ]; then
		WITHOUT_SQLITE=""
		PROOT_CFFI="$PROOT_HOST"
	else
		WITHOUT_SQLITE="--without-sqlite3"
		PROOT_CFFI="env -i PROOT_NO_SECCOMP=1
					$TERMUX_RUNTIME_ENV_VARS
					$TERMUX_ANDROID_HOME/proot
					-q /usr/bin/qemu-$TERMUX_ARCH-static
					-w $TERMUX_ANDROID_HOME
					-b $TERMUX_ANDROID_HOME
					-b $TERMUX_PKG_SRCDIR:$PYPY_SRC_DIR
					-b /dev -b /sys -b /proc
					-r $TERMUX_ANDROID_HOME/target-rootfs"
	fi

	$PROOT_CFFI env \
				CC=$PYPY_SRC_DIR/remote_cc.py \
				TARGET_ARCH=$TERMUX_ARCH \
				PROOT_NDK="$PROOT_NDK" \
				TERMUX_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN \
				python2 $PYPY_SRC_DIR/pypy/tool/release/package.py \
					--archive-name=pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION \
					--targetdir=$PYPY_SRC_DIR \
					--no-keep-debug --without-_ssl $WITHOUT_SQLITE
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

termux_step_post_make_install() {
	rm -rf $TERMUX_ANDROID_HOME
}
