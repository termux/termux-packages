TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compiler libraries"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=9.12.1
TERMUX_PKG_SRCURL="https://downloads.haskell.org/~ghc/$TERMUX_PKG_VERSION/ghc-$TERMUX_PKG_VERSION-src.tar.xz"
TERMUX_PKG_SHA256=4a7410bdeec70f75717087b8f94bf5a6598fd61b3a0e1f8501d8f10be1492754
TERMUX_PKG_DEPENDS="libiconv, libffi, libgmp, libandroid-posix-semaphore, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--host=$TERMUX_BUILD_TUPLE
--with-system-libffi
--disable-ld-override"
TERMUX_PKG_REPLACES="ghc-libs-static, ghc-libs"
TERMUX_PKG_PROVIDES="ghc-libs, ghc-libs-static"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_LICENSE_FILE="LICENSE"

termux_step_pre_configure() {
	termux_setup_ghc && termux_setup_cabal

	export CONF_CC_OPTS_STAGE1="$CFLAGS $CPPFLAGS"
	export CONF_GCC_LINKER_OPTS_STAGE1="$LDFLAGS"
	export CONF_CXX_OPTS_STAGE1="$CXXFLAGS"

	export CONF_CC_OPTS_STAGE2="$CFLAGS $CPPFLAGS"
	export CONF_GCC_LINKER_OPTS_STAGE2="$LDFLAGS"
	export CONF_CXX_OPTS_STAGE2="$CXXFLAGS"

	export target="$TERMUX_HOST_PLATFORM"
	[[ "$TERMUX_ARCH" == "arm" ]] && target="armv7a-linux-androideabi"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$TERMUX_PKG_EXTRA_CONFIGURE_ARGS --target=$target"
}

termux_step_make() {
	(
		unset CFLAGS CPPFLAGS LDFLAGS # For stage0 compilation.

		# NOTE: We do not build profiled libs. It exceeds the 6 hours usage limit of github CI.
		./hadrian/build binary-dist-dir \
			-j"$TERMUX_PKG_MAKE_PROCESSES" \
			--flavour="perf+split_sections+no_profiled_libs" \
			--docs=none \
			"stage1.unix.ghc.link.opts += -optl-landroid-posix-semaphore" \
			"stage2.unix.ghc.link.opts += -optl-landroid-posix-semaphore"
	)
}

termux_step_make_install() {
	cd _build/bindist/ghc-"$TERMUX_PKG_VERSION"-"$target" || exit 1

	# Remove unnecessary flags. They would get written to settings file otherwise:
	unset CONF_CC_OPTS_STAGE2 CONF_GCC_LINKER_OPTS_STAGE2 CONF_CXX_OPTS_STAGE2

	# We need to re-run configure:
	# See: https://gitlab.haskell.org/ghc/ghc/-/issues/22058
	./configure \
		--prefix="$TERMUX_PREFIX" \
		--with-system-libffi \
		--host="$target"

	HOST_GHC_PKG="$(realpath ../../stage1/bin/ghc-pkg)" make install
}

termux_step_post_massage() {
	local ghclibs_dir="lib/ghc-$TERMUX_PKG_VERSION"

	if ! [[ -d "$ghclibs_dir" ]]; then
		echo "ERROR: GHC lib directory is not at expected place. Please verify before continuing."
		exit 1
	fi

	# Remove version suffix from `llc` and `opt`:
	sed -i -E 's|("LLVM llc command",) "llc.*"|\1 "llc"|' "$ghclibs_dir"/lib/settings
	sed -i -E 's|("LLVM opt command",) "opt.*"|\1 "opt"|' "$ghclibs_dir"/lib/settings

	# Remove cross-prefix from tools:
	sed -i "s|$CC|${CC/${target}-/}|g" "$ghclibs_dir"/lib/settings
	sed -i "s|$CXX|${CXX/${target}-/}|g" "$ghclibs_dir"/lib/settings

	# Strip unneeded symbols:
	find . -type f \( -name "*.so" -o -name "*.a" \) -exec "$STRIP" --strip-unneeded {} \;
	find "$ghclibs_dir"/bin -type f -exec "$STRIP" {} \;
}
