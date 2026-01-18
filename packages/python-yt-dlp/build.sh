TERMUX_PKG_HOMEPAGE=https://github.com/yt-dlp/yt-dlp
TERMUX_PKG_DESCRIPTION="A youtube-dl fork with additional features and fixes"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2025.12.08"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/yt-dlp/yt-dlp/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=10bec5b2bfb367263e7e46ddb69187204506f9d67b7f01bb499d07fa0d54d4b7
TERMUX_PKG_DEPENDS="libc++, libexpat, openssl, python, python-brotli, python-pip, python-pycryptodomex"
TERMUX_PKG_RECOMMENDS="ffmpeg, yt-dlp-ejs"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="hatchling, wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PROVIDES='yt-dlp'
TERMUX_PKG_CONFFILES="etc/yt-dlp/config"

termux_step_host_build() {
	cp -Rf $TERMUX_PKG_SRCDIR ./

	( cd src && make completions )
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# Install library
	pip install . --prefix=$TERMUX_PREFIX -vv --no-build-isolation --no-deps

	# Install completions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/bash/yt-dlp \
		-t "$TERMUX_PREFIX"/share/bash-completion/completions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/zsh/_yt-dlp \
		-t "$TERMUX_PREFIX"/share/zsh/site-functions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/fish/yt-dlp.fish \
		-t "$TERMUX_PREFIX"/share/fish/completions

	# Install config file
	if (( TERMUX_ARCH_BITS == 32 )); then
		mkdir -p "$TERMUX_PREFIX/etc/yt-dlp"
		cat <<- EOF > "$TERMUX_PREFIX/etc/yt-dlp/config"
		# yt-dlp-ejs defaults to using Deno as the JS runtime,
		# Deno doesn't currently have 32 bit build support.
		# So use Node instead on '$TERMUX_ARCH'.
		--js-runtimes node
		EOF
	fi
}
