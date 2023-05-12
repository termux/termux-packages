TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compiler libraries"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION=9.2.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://downloads.haskell.org/~ghc/${TERMUX_PKG_VERSION}/ghc-${TERMUX_PKG_VERSION}-src.tar.xz"
TERMUX_PKG_SHA256=0606797d1b38e2d88ee2243f38ec6b9a1aa93e9b578e95f0de9a9c0a4144021c
TERMUX_PKG_DEPENDS="libiconv, libffi, ncurses, libgmp, libandroid-posix-semaphore"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ld-override
--build=x86_64-unknown-linux
--host=x86_64-unknown-linux
--with-system-libffi
--with-ffi-includes=${TERMUX_PREFIX}/include
--with-ffi-libraries=${TERMUX_PREFIX}/lib
--with-gmp-includes=${TERMUX_PREFIX}/include
--with-gmp-libraries=${TERMUX_PREFIX}/lib
--with-iconv-includes=${TERMUX_PREFIX}/include
--with-iconv-libraries=${TERMUX_PREFIX}/lib
--with-curses-libraries=${TERMUX_PREFIX}/lib
--with-curses-includes=${TERMUX_PREFIX}/include
"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_REPLACES="ghc-libs-static"

# 'network' is used by 'libiserv'. This will enable over the network support in 'iserv-proxy' which is
# used to cross-compile haskell-template.
termux_step_post_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"/libraries/network
	local tar_file="$TERMUX_PKG_CACHEDIR/network.tar"
	termux_download \
		https://hackage.haskell.org/package/network-2.8.0.1/network-2.8.0.1.tar.gz \
		"$tar_file" \
		61f55dbfed0f0af721a8ea36079e9309fcc5a1be20783b44ae500d9e4399a846
	tar xf "$tar_file" -C "$TERMUX_PKG_SRCDIR"/libraries/network --strip-components=1
	# Alllow newer versions of 'bytestring':
	sed -ri 's|(bytestring) == .*|\1|' "$TERMUX_PKG_SRCDIR"/libraries/network/network.cabal
	# XXX: Please verify above command works when updating.
}

termux_step_pre_configure() {
	termux_setup_ghc

	local host_platform="${TERMUX_HOST_PLATFORM}"
	[ "${TERMUX_ARCH}" = "arm" ] && host_platform="armv7a-linux-androideabi"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --target=${host_platform}"

	local extra_flags="-O -optl-Wl,-rpath=${TERMUX_PREFIX}/lib -optl-Wl,--enable-new-dtags"
	[ "${TERMUX_ARCH}" != "i686" ] && extra_flags+=" -fllvm"

	# Suppress warnings for LLVM 13
	sed -i 's/LlvmMaxVersion=13/LlvmMaxVersion=15/' configure.ac

	export LIBTOOL && LIBTOOL="$(command -v libtool)"

	cp mk/build.mk.sample mk/build.mk
	cat >>mk/build.mk <<-EOF
		SRC_HC_OPTS        = -O -H64m
		GhcStage1HcOpts    = -O
		GhcStage2HcOpts    = ${extra_flags}
		GhcLibHcOpts       = ${extra_flags} -optl-landroid-posix-semaphore
		BuildFlavour       = quick-cross
		GhcLibWays         = v dyn
		BUILD_PROF_LIBS    = NO
		HADDOCK_DOCS       = NO
		BUILD_SPHINX_HTML  = NO
		BUILD_SPHINX_PDF   = NO
		BUILD_MAN          = NO
		WITH_TERMINFO      = YES
		DYNAMIC_GHC_PROGRAMS = YES
		SplitSections      = YES
		StripLibraries     = YES
		libraries/libiserv_CONFIGURE_OPTS += --flags=+network
	EOF

	patch -p1 <<-EOF
		--- ghc.orig/rules/build-package-data.mk 2022-11-07 01:10:29.000000000 +0530
		+++ ghc.mod/rules/build-package-data.mk  2022-11-11 13:08:01.992488180 +0530
		@@ -68,6 +68,12 @@
		 \$1_\$2_CONFIGURE_LDFLAGS = \$\$(SRC_LD_OPTS) \$\$(\$1_LD_OPTS) \$\$(\$1_\$2_LD_OPTS)
		 \$1_\$2_CONFIGURE_CPPFLAGS = \$\$(SRC_CPP_OPTS) \$\$(CONF_CPP_OPTS_STAGE\$3) \$\$(\$1_CPP_OPTS) \$\$(\$1_\$2_CPP_OPTS)

		+ifneq "\$3" "0"
		+ \$1_\$2_CONFIGURE_LDFLAGS += ${LDFLAGS}
		+ \$1_\$2_CONFIGURE_CPPFLAGS += ${CPPFLAGS}
		+ \$1_\$2_CONFIGURE_CFLAGS += ${CFLAGS}
		+endif
		+
		 \$1_\$2_CONFIGURE_OPTS += --configure-option=CFLAGS="\$\$(\$1_\$2_CONFIGURE_CFLAGS)"
		 \$1_\$2_CONFIGURE_OPTS += --configure-option=LDFLAGS="\$\$(\$1_\$2_CONFIGURE_LDFLAGS)"
		 \$1_\$2_CONFIGURE_OPTS += --configure-option=CPPFLAGS="\$\$(\$1_\$2_CONFIGURE_CPPFLAGS)"
		@@ -104,9 +110,12 @@
		 \$1_\$2_CONFIGURE_OPTS += --configure-option=--with-gmp
		 endif

		-
		 ifneq "\$\$(CURSES_LIB_DIRS)" ""
		-\$1_\$2_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="\$\$(CURSES_LIB_DIRS)"
		+ ifeq "\$3" "0"
		+  \$1_\$2_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="/usr/lib"
		+ else
		+  \$1_\$2_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="\$\$(CURSES_LIB_DIRS)"
		+ endif
		 endif

		 \$1_\$2_CONFIGURE_OPTS += --configure-option=--host=\$(TargetPlatformFull)
	EOF

	./boot
}

termux_step_make_install() {
	make install-strip INSTALL="$(command -v install) --strip-program=${STRIP}"
}

termux_step_post_make_install() {
	# We may build GHC with `llc-9` etc., but only `llc` is present in Termux
	sed -i 's/"LLVM llc command", "llc.*"/"LLVM llc command", "llc"/' \
		"${TERMUX_PREFIX}/lib/ghc-${TERMUX_PKG_VERSION}/settings"
	sed -i 's/"LLVM opt command", "opt.*"/"LLVM opt command", "opt"/' \
		"${TERMUX_PREFIX}/lib/ghc-${TERMUX_PKG_VERSION}/settings"

	sed -i 's|"/usr/bin/libtool"|"libtool"|' \
		"${TERMUX_PREFIX}/lib/ghc-${TERMUX_PKG_VERSION}/settings"
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}
