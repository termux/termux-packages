TERMUX_PKG_HOMEPAGE=https://git-annex.branchable.com
TERMUX_PKG_DESCRIPTION="Manage large files with git, without storing the file contents in git"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=10.20260717
TERMUX_PKG_SRCURL="git+https://git.joeyh.name/git/git-annex.git"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="botan3, zlib, libandroid-posix-semaphore, libandroid-utimes, libffi, libiconv, libgmp, libmagic, libsqlite"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_RECOMMENDS="git, rsync, gnupg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-f+Production -f+Botan -f+OsPath -f+MagicMime -f+ParallelBuild"

# This is needed since upstream doesn't support 'shallow' clone.
termux_step_get_source() {
	local cache="$TERMUX_COMMON_CACHEDIR"/git-annex-"$TERMUX_PKG_VERSION"

	if [[ ! -d "$cache" ]]; then
		git clone "${TERMUX_PKG_SRCURL#git+}" --branch="$TERMUX_PKG_VERSION" "$cache"
	fi

	mkdir -p "$TERMUX_PKG_SRCDIR"
	cp -R "$cache"/* "$TERMUX_PKG_SRCDIR"/
}

termux_step_pre_configure() {
	sed -i -E 's|(Build-type:\s*)Custom|\1Simple|' "$TERMUX_PKG_SRCDIR"/git-annex.cabal

	local git_version
	git_version="$(sed -nE 's|^TERMUX_PKG_VERSION="(.*)"|\1|p' "$TERMUX_PKG_BUILDER_DIR"/../git/build.sh)"

	sed -e "s|@TERMUX_PKG_VERSION@|$TERMUX_PKG_VERSION|" \
		"$TERMUX_PKG_BUILDER_DIR"/build-config/Version >"$TERMUX_PKG_SRCDIR"/Build/Version

	sed -e "s|@GIT_VERSION@|$git_version|" \
		"$TERMUX_PKG_BUILDER_DIR"/build-config/SysConfig >"$TERMUX_PKG_SRCDIR"/Build/SysConfig

	# netbd stub:
	"$CC" -fPIC -c "$TERMUX_PKG_BUILDER_DIR"/netdb.c -o "$TERMUX_PKG_TMPDIR"/netdb.o
	"$AR" rcu "$TERMUX_PKG_TMPDIR"/libandroid-netdb.a "$TERMUX_PKG_TMPDIR"/netdb.o

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --ghc-options=-optl-L$TERMUX_PKG_TMPDIR --ghc-options=-optl-landroid-netdb"
}

termux_step_post_configure() {
	# NOTE: [crypton]: version >=1.1 has shifted to 'ram' from 'memory' package.
	# upstream doesn't have guard against it but depends upon API of 'memory' package.
	# [aws]: also 'memory' to 'ram' switch in >0.25.3.
	# [magic]: 2.0 breaks build.

	# Unfortunately constraints has to be done here as passing them as flags with
	# quotes doesn't work due to shell splitting of TERMUX_PKG_EXTRA_CONFIGURE_ARGS.
	local constraints="persistent-sqlite +systemlib +use-pkgconfig, entropy +donotgetentropy, crypton <1.1, aws <0.25.3, magic <=1.1"

	if [[ "$TERMUX_ARCH" == "aarch64" || "$TERMUX_ARCH" == "arm" ]]; then
		constraints+=", blake3 -avx512 -avx2 -sse41 -sse2"
	fi

	cat <<-EOF >>cabal.project.local
		packages: splitmix entropy basement cborg memory xml-conduit persistent-sqlite network-bsd
		constraints: $constraints
	EOF

	cabal get cborg-0.2.10.0 && mv cborg{-*,}
	cabal get memory-0.18.0 && mv memory{-*,}
	cabal get entropy-0.4.1.11 && mv entropy{-*,}
	cabal get basement-0.0.16 && mv basement{-*,}
	cabal get splitmix-0.1.3.2 && mv splitmix{-*,}
	cabal get network-bsd-2.8.1.0 && mv network-bsd{-*,}
	cabal get xml-conduit-1.10.1.0 && mv xml-conduit{-*,}
	cabal get persistent-sqlite-2.13.3.1 && mv persistent-sqlite{-*,}

	for f in "$TERMUX_PKG_BUILDER_DIR"/splitmix-patches/*.patch; do
		patch --silent -p1 -d splitmix <"$f"
	done

	for f in "$TERMUX_PKG_BUILDER_DIR"/{basement,cborg,memory,persistent-sqlite,network-bsd}-patches/*.patch; do
		patch --silent -p1 <"$f"
	done

	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' entropy/entropy.cabal
	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' xml-conduit/xml-conduit.cabal

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			package *
			    ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
		EOF
	fi
}

termux_step_post_make_install() {
	for b in git-annex-shell git-remote{,-p2p,-tor}-annex; do
		ln -sfv "$TERMUX_PREFIX"/bin/git-annex "$TERMUX_PREFIX"/bin/"$b"
	done

	mkdir -p man
	for f in doc/git-annex*.mdwn doc/git-remote-*.mdwn; do
		local command_name
		command_name=$(basename "$f" .mdwn)

		perl ./Build/mdwn2man "$command_name" 1 "$f" >man/"${command_name}".1
	done

	install -v -Dm0600 ./man/*.1 -t "$TERMUX_PREFIX"/share/man/man1/
	install -v -Dm644 bash-completion.bash "$TERMUX_PREFIX"/share/bash-completion/completions/git-annex

	# Create empty completions file so that it is removed while uninstalling the package:
	install -v -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_git-annex
	install -v -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/git-annex.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		git-annex --zsh-completion-script git-annex 2>/dev/null > $TERMUX_PREFIX/share/zsh/site-functions/_git-annex
		git-annex --fish-completion-script git-annex 2>/dev/null > $TERMUX_PREFIX/share/fish/vendor_completions.d/git-annex.fish
	EOF
}
