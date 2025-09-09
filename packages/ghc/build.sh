TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compiler"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=9.12.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://downloads.haskell.org/~ghc/$TERMUX_PKG_VERSION/ghc-$TERMUX_PKG_VERSION-src.tar.xz"
TERMUX_PKG_SHA256=0e49cd5dde43f348c5716e5de9a5d7a0f8d68d945dc41cf75dfdefe65084f933
TERMUX_PKG_DEPENDS="libiconv, libffi, libgmp, libandroid-posix-semaphore, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--host=$TERMUX_BUILD_TUPLE
--with-system-libffi
--disable-ld-override"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_REPLACES="ghc-libs-static, ghc-libs"
TERMUX_PKG_PROVIDES="ghc-libs, ghc-libs-static"

__setup_bootstrap_compiler() {
	local version=9.10.1
	local temp_folder="$TERMUX_PKG_CACHEDIR/ghc-bootstrap-$version"
	local tarball="$temp_folder.tar.xz"
	local runtime_folder="$temp_folder-runtime"

	export PATH="$runtime_folder/bin:$PATH"

	[[ -d "$runtime_folder" ]] && return

	termux_download "https://downloads.haskell.org/~ghc/$version/ghc-$version-x86_64-ubuntu20_04-linux.tar.xz" \
		"$tarball" \
		ae3be406fdb73bd2b0c22baada77a8ff2f8cde6220dd591dc24541cfe9d895eb

	mkdir -p "$temp_folder" "$runtime_folder"
	tar xf "$tarball" --strip-components=1 -C "$temp_folder"
	(
		set -e
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		cd "$temp_folder"
		./configure --prefix="$runtime_folder"
		make install
	) &>/dev/null

	rm -Rf "$temp_folder" "$tarball"
}

termux_step_pre_configure() {
	__setup_bootstrap_compiler && termux_setup_cabal

	export CONF_CC_OPTS_STAGE2="$CFLAGS $CPPFLAGS"
	export CONF_GCC_LINKER_OPTS_STAGE2="$LDFLAGS"
	export CONF_CXX_OPTS_STAGE2="$CXXFLAGS"

	export target="$TERMUX_HOST_PLATFORM"
	export no_profiled_libs=""

	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		target="armv7a-linux-androideabi"
		# NOTE: We do not build profiled libs for arm. It exceeds the 6 hours usage
		# limit of github CI.
		no_profiled_libs="+no_profiled_libs"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$TERMUX_PKG_EXTRA_CONFIGURE_ARGS --target=$target"
	./boot.source
}

termux_step_make() {
	(
		unset CFLAGS LDFLAGS CPPFLAGS # For hadrian compilation

		./hadrian/build binary-dist-dir \
			-j"$TERMUX_PKG_MAKE_PROCESSES" \
			--flavour="release$no_profiled_libs" --docs=none \
			"stage1.unix.ghc.link.opts += -optl-landroid-posix-semaphore"
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
		--host="$target"

	HOST_GHC_PKG="$(realpath ../../stage0/bin/ghc-pkg)" make install
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
