TERMUX_PKG_HOMEPAGE=https://elixir-lang.org/
TERMUX_PKG_DESCRIPTION="Elixir is a dynamic, functional language designed for building scalable and maintainable applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.2
TERMUX_PKG_SRCURL=https://github.com/elixir-lang/elixir/releases/download/v${TERMUX_PKG_VERSION}/Precompiled.zip
TERMUX_PKG_SHA256=b8f10682bce3d2c215bc4ecb2872987a734071f0d7fee8bff3e46afa981f3dd7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dash, erlang"
TERMUX_PKG_SUGGESTS="clang, make"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	termux_download "$TERMUX_PKG_SRCURL" "$TERMUX_PKG_CACHEDIR"/prebuilt.zip \
		"$TERMUX_PKG_SHA256"
	# Create src directory to avoid build-package.sh errors.
	mkdir -p "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	# Unpack directly to $PREFIX/opt/elixir.
	mkdir -p "$TERMUX_PREFIX"/opt
	rm -rf "$TERMUX_PREFIX"/opt/elixir
	unzip -d "$TERMUX_PREFIX"/opt/elixir "$TERMUX_PKG_CACHEDIR"/prebuilt.zip

	# Remove unneeded files.
	(cd "$TERMUX_PREFIX"/opt/elixir/man; rm -f common elixir.1.in iex.1.in)

	# Put manpages to standard location.
	for page in elixir.1 elixirc.1 iex.1 mix.1; do
		install -Dm600 "$TERMUX_PREFIX/opt/elixir/man/$page" \
			"$TERMUX_PREFIX/share/man/man1/$page"
	done
	unset page
	rm -rf "$TERMUX_PREFIX"/opt/elixir/man

	# Symlink startup scripts to $PREFIX/bin.
	for file in elixir elixirc iex mix; do
		ln -sfr "$TERMUX_PREFIX/opt/elixir/bin/$file" \
			"$TERMUX_PREFIX/bin/$file"
	done
	unset file
}
