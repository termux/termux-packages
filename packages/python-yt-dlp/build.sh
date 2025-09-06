TERMUX_PKG_HOMEPAGE=https://github.com/yt-dlp/yt-dlp
TERMUX_PKG_DESCRIPTION="A youtube-dl fork with additional features and fixes"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2025.09.05"
TERMUX_PKG_SRCURL=https://github.com/yt-dlp/yt-dlp/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ee27c601e60d703dc3e16f8d6306cbffd2a4dc801e3fa91d6323f496dd8a52ec
TERMUX_PKG_DEPENDS="libc++, libexpat, openssl, python, python-brotli, python-pip, python-pycryptodomex"
TERMUX_PKG_RECOMMENDS="ffmpeg"
TERMUX_PKG_PYTHON_COMMON_DEPS="hatchling, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="mutagen, pycryptodomex, websockets, certifi, brotli, requests, urllib3"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PROVIDES='yt-dlp'

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
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
