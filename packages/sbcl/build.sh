TERMUX_PKG_HOMEPAGE="http://www.sbcl.org/"
TERMUX_PKG_DESCRIPTION="A high performance Common Lisp compiler"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.3"
TERMUX_PKG_SRCURL="https://github.com/sbcl/sbcl/archive/refs/tags/sbcl-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f3b923778f7d1f151f2bdc08a0e92ec4f5a3db5efca5f46ea2ac439dda06cc35
TERMUX_PKG_DEPENDS="zstd"
# TERMUX_ON_DEVICE_BUILD=true  build dependencies: ecl, strace
# TERMUX_ON_DEVICE_BUILD=false build dependencies: aosp-libs, bash, coreutils, strace
# NOTE: if you are bootstrapping on-device, if either is desired, it is possible to manually
# implement both an on-device build and an x86 build of ecl, but those are currently
# unimplemented in termux-packages at time of writing.
# the build dependency is disabled to avoid dependency errors when cross-compiling in CI for x86.
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, bash, coreutils, strace"
# it is extremely difficult to port SBCL to 32-bit Android because of multiple severe
# incompatibilties, like the lack of support for a fully position-independent runtime executable.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	# precompiled SBCL release for GNU/Linux to use as host Lisp for bootstrapping
	SBCL_BINURL="https://sourceforge.net/projects/sbcl/files/sbcl/${TERMUX_PKG_VERSION}/sbcl-${TERMUX_PKG_VERSION}-x86-64-linux-binary.tar.bz2"
	SBCL_BINARCHIVE="${TERMUX_PKG_CACHEDIR}/sbcl-${TERMUX_PKG_VERSION}-x86-64-linux-binary.tar.bz2"
	SBCL_BINSHA256=e207fa6e851631dee0a467cea4f15276d31d4192c949a2b1d3d0daadbf70d443
	SBCL_WORKDIR="${TERMUX_PKG_TMPDIR}/sbcl"
	mkdir -p "$SBCL_WORKDIR"
	termux_download "$SBCL_BINURL" "$SBCL_BINARCHIVE" "$SBCL_BINSHA256"
	tar -xf "$SBCL_BINARCHIVE" --strip-components=1 -C "$SBCL_WORKDIR"
	export INSTALL_ROOT="$TERMUX_PKG_HOSTBUILD_DIR"
	cd "$SBCL_WORKDIR"
	sh install.sh
}

termux_step_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
	fi

	# See doc/PACKAGING-SBCL.txt
	echo "\"${TERMUX_PKG_FULLVERSION}.termux\"" > version.lisp-expr
}

termux_step_make() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		export LINKFLAGS="$LDFLAGS"
		sh make.sh \
			--xc-host="${TERMUX_PREFIX}/bin/ecl --norc" \
			--prefix="$TERMUX_PREFIX" \
			--with-android \
			--fancy \
			--without-gcc-tls

		pushd tests
		sh run-tests.sh
		popd
	else
		# if not appended to make.sh, the build fails with no error message
		# only after cross-compilation, not non-cross-compilation
		echo "exit 0" >> make.sh

		# build SBCL inside a proot that runs bionic-libc $TERMUX_PREFIX/bin/uname,
		# some other bionic-libc commands, and bionic-libc build artifacts,
		# but runs the host cross-compiler and the host sbcl binary to compile
		# bootstrapping lisp code and compile the C-based runtime code.
		termux-proot-run env LD_PRELOAD= LD_LIBRARY_PATH= \
			CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LINKFLAGS="$LDFLAGS" \
			sh make.sh \
				--xc-host="${TERMUX_PKG_HOSTBUILD_DIR}/bin/sbcl --norc" \
				--prefix="$TERMUX_PREFIX" \
				--with-android \
				--fancy \
				--without-gcc-tls

		pushd tests
		# for passing some tests
		mkdir -p "$TERMUX_ANDROID_HOME"

		# run test suite inside proot
		termux-proot-run env LD_PRELOAD= LD_LIBRARY_PATH= \
			CC="$CC" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LINKFLAGS="$LDFLAGS" \
			TMPDIR="$TERMUX_PREFIX/tmp" \
			sh run-tests.sh
		popd
	fi

	# docs fail to build even after trying to configure texinfo and texlive,
	# both on-device and after cross-compilation.
	# error:
	# texi2dvi -q -I "docstrings/" -I "../../contrib/" sbcl.texinfo
	# start-stop.texinfo:113: I can't find file `fun-sb-ext-exit.texinfo'.
	# texi2dvi: etex exited with bad status, quitting
	#if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
	#	make -C doc/manual
	#else
	#	# build docs inside proot because this step needs the newly compiled bionic-libc sbcl
	#	termux-proot-run env LD_PRELOAD= LD_LIBRARY_PATH= \
	#		make -C doc/manual
	#fi
	# however, at least the command "man sbcl" does work after installation despite this.
}

termux_step_make_install() {
	INSTALL_ROOT="$TERMUX_PREFIX" sh install.sh
}
