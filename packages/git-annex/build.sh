TERMUX_PKG_HOMEPAGE="https://git-annex.branchable.com/"
TERMUX_PKG_DESCRIPTION="Manage large files with git, without storing the file contents in git"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=10.20260717
TERMUX_PKG_SRCURL="git+git://git-annex.branchable.com/"
TERMUX_PKG_GIT_BRANCH="$TERMUX_PKG_VERSION"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, libandroid-posix-semaphore, libandroid-utimes, libsqlite"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-f+Production -f-Assistant -f-MagicMime -f-Benchmark"

export LANG=C.UTF-8

termux_step_pre_configure() {
	sed -i -E 's|(Build-type:\s*)Custom|\1Simple|' "$TERMUX_PKG_SRCDIR"/git-annex.cabal
	cp "$TERMUX_PKG_BUILDER_DIR"/build-config/* "$TERMUX_PKG_SRCDIR"/Build/

	# netbd stub:
	"$CC" -fPIC -c "$TERMUX_PKG_BUILDER_DIR"/netdb.c -o "$TERMUX_PKG_TMPDIR"/netdb.o
	"$AR" rcu "$TERMUX_PKG_TMPDIR"/libandroid-netdb.a "$TERMUX_PKG_TMPDIR"/netdb.o

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --ghc-options=-optl-L$TERMUX_PKG_TMPDIR --ghc-options=-optl-landroid-netdb"

}

termux_step_post_configure() {
	# NOTE: [crypton]: version >=1.1 has shifted to 'ram' from 'memory' package.
	# upstream doesn't have guard against it but depends upon API of 'memory' package.
	# [aws]: also 'memory' to 'ram' switch in >0.25.3.

	# Unfortunately constraints has to be done here as passing them as flags with
	# quotes doesn't work due to shell splitting of TERMUX_PKG_EXTRA_CONFIGURE_ARGS.
	local constraints="persistent-sqlite +systemlib +use-pkgconfig, entropy +donotgetentropy, crypton <1.1, aws <0.25.3"

	if [[ "$TERMUX_ARCH" == "aarch64" || "$TERMUX_ARCH" == "arm" ]]; then
		constraints+=", blake3 -avx512 -avx2 -sse41 -sse2"
	fi

	cat <<-EOF >>cabal.project.local
		constraints: $constraints
	EOF

	cabal get splitmix-0.1.3.2 && mv splitmix{-*,}
	cabal get entropy-0.4.1.11 && mv entropy{-*,}
	cabal get basement-0.0.16 && mv basement{-*,}
	cabal get cborg-0.2.10.0 && mv cborg{-*,}
	cabal get memory-0.18.0 && mv memory{-*,}
	cabal get xml-conduit-1.10.1.0 && mv xml-conduit{-1.10.1.0,}
	cabal get persistent-sqlite-2.13.3.1 && mv persistent-sqlite{-2.13.3.1,}
	cabal get network-bsd-2.8.1.0 && mv network-bsd{-2.8.1.0,}

	for f in "$TERMUX_PKG_BUILDER_DIR"/splitmix-patches/*.patch; do
		patch --silent -p1 -d splitmix <"$f"
	done

	for f in "$TERMUX_PKG_BUILDER_DIR"/{basement,cborg,memory,persistent-sqlite,network-bsd}-patches/*.patch; do
		patch --silent -p1 <"$f"
	done

	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' xml-conduit/xml-conduit.cabal
	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' entropy/entropy.cabal

	cat <<-EOF >>cabal.project.local
		packages: splitmix entropy basement cborg memory xml-conduit persistent-sqlite network-bsd
	EOF

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			package *
			    ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
		EOF
	fi
}
