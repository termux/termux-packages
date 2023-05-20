TERMUX_PKG_HOMEPAGE=https://lld.llvm.org/
TERMUX_PKG_DESCRIPTION="LLD for debugging purposes"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_LICENSE_FILE="llvm/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@ghost"
TERMUX_PKG_VERSION=16.0.4
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/llvm-project-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=cf3c2a1152ed7a99866bd7f12c24528ada6d9f6336afb7a08416938762004c9f
TERMUX_PKG_DEPENDS="libc++, libffi, libxml2, ncurses, zlib, zstd, lld"
TERMUX_PKG_ANTI_BUILD_DEPENDS="lld"
TERMUX_PKG_BUILD_DEPENDS="binutils-libs"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STRIP=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

TERMUX_PKG_FORCE_CMAKE=true

termux_step_host_build() {
	(
		. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh
		termux_step_host_build
	)
}

termux_step_pre_configure() {
	MY_PREFIX=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=$(
		. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh
		echo $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	)
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DLLVM_ENABLE_PROJECTS=lld
		-DLLVM_USE_SANITIZER=Address
		-DCMAKE_INSTALL_PREFIX=$MY_PREFIX
		-DCMAKE_INSTALL_LIBDIR=$MY_PREFIX/lib
		-DLLVM_TARGET_ARCH=AArch64
		-DLLVM_HOST_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	"
	CFLAGS+=" -g"
	CXXFLAGS+=" -g"
	LDFLAGS="-Wl,-rpath=$MY_PREFIX/lib $LDFLAGS"

	TERMUX_SRCDIR_SAVE=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR+=/llvm
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_SRCDIR_SAVE
}

termux_step_create_debscripts() {
	cat > postinst <<-EOF
		#!$TERMUX_PREFIX/bin/sh
		lld=$TERMUX_PREFIX/bin/lld
		if [ ! -L "\${lld}" ] && [ -e "\${lld}" ]; then
		    mv "\${lld}" $MY_PREFIX/bin/lld.bak
		    echo
		    echo "    \\\$PREFIX/bin/lld is replaced with a wrapper from $TERMUX_PKG_NAME package."
		    echo "    The original file will be restored when the package is uninstalled."
		    echo
		fi
		ln -sf $MY_PREFIX/bin/lld.wrapper $TERMUX_PREFIX/bin/lld
		exit 0
	EOF
	cat > prerm <<-EOF
		#!$TERMUX_PREFIX/bin/sh
		lld=$TERMUX_PREFIX/bin/lld
		lld_bak=$MY_PREFIX/bin/lld.bak
		if [ -e "\${lld_bak}" ] && [ -L "\${lld}" ]; then
		    mv "\${lld_bak}" "\${lld}"
		fi
		rm -f "\${lld_bak}"
		exit 0
	EOF
}

termux_step_post_make_install() {
	cd $MY_PREFIX
	find . ! -type d \
		! -wholename "./lib/lib*.so" \
		! -wholename "./bin/ld.lld" \
		! -wholename "./bin/ld64.lld" \
		! -wholename "./bin/lld" \
		! -wholename "./bin/lld-link" \
		! -wholename "./bin/wasm-ld" \
		-exec rm -f '{}' \;
	ln -s lld ./bin/ld
	cat > ./bin/lld.wrapper <<-EOF
		#!$TERMUX_PREFIX/bin/sh
		cmd=\$(basename "\$0")
		if [ x"\$LD_LIBRARY_PATH" != x ]; then
		    LD_LIBRARY_PATH="$(pwd)/lib:\$LD_LIBRARY_PATH"
		fi
		exec $(pwd)/bin/"\${cmd}" "\$@"
	EOF
	chmod 0700 ./bin/lld.wrapper
}
