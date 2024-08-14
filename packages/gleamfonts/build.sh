TERMUX_PKG_HOMEPAGE=https://github.com/massix/gleamfonts
TERMUX_PKG_DESCRIPTION="Command-line tool to fetch and install fonts from NerdFonts repository"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="massix"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/massix/gleamfonts/archive/refs/tags/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=5b9fa88bd9048c1c14ccb479081bbb5792f3bd77954405fc4b5611bc58af794b
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_DEPENDS="erlang, libsqlite"
TERMUX_PKG_BUILD_DEPENDS="gleam"
TERMUX_PKG_PLATFORM_INDEPENDENT=false
TERMUX_QUIET_BUILD=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	gleam deps download
	ESQLITE_USE_SYSTEM=1 gleam build -t erlang
}


termux_step_make_install() {
	ESQLITE_USE_SYSTEM=1 gleam export erlang-shipment
}

termux_step_extract_into_massagedir() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/{bin,opt/gleamfonts}
	install -m 0775 "$TERMUX_PKG_SRCDIR/scripts/gleamfonts" "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin"
	cp -r "$TERMUX_PKG_SRCDIR"/build/erlang-shipment/* "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/gleamfonts/"
}
