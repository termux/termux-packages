TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION="3.9"
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/pandoc-cli-$TERMUX_PKG_VERSION/pandoc-cli-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=dd6e00c53da0ef12d75a21a643d7f0a1cdd8cb81178f725280124bda20aa24a9
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, lua54, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-f+lua -f+server
-c lua+system-lua
-c lua+pkg-config
-c lua+cross-compile
-c pandoc+embed_data_files
"

TERMUX_PKG_EXCLUDED_ARCHES="arm, i686" # Upstream doesn't support 32bit.

termux_step_post_configure() {
	cabal get splitmix-0.1.3.1
	mv splitmix{-*,}

	for f in "$TERMUX_PKG_BUILDER_DIR"/splitmix-patches/*.patch; do
		patch --silent -p1 -d splitmix < "$f"
	done

	cat <<-EOF >>cabal.project.local
		packages: splitmix

		package splitmix
			benchmarks: False
			tests: False
	EOF

	cabal get xml-conduit-1.10.0.0 # NOTE: Confirm version before updating.
	mv xml-conduit{-1.10.0.0,}

	# We cannot use `Custom` build while cross-compiling:
	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' ./xml-conduit/xml-conduit.cabal

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			packages: ./xml-conduit
			          ./
			package *
			    ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
		EOF
	fi
}

termux_step_post_make_install() {
	ln -sfv "$TERMUX_PREFIX"/bin/pandoc "$TERMUX_PREFIX"/bin/pandoc-server

	install -Dm600 ./man/*.1 -t "$TERMUX_PREFIX"/share/man/man1/

	# Create empty completions file so that it is removed while uninstalling the package:
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/pandoc
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		pandoc --bash-completion > $TERMUX_PREFIX/share/bash-completion/completions/pandoc
	EOF
}
