TERMUX_PKG_HOMEPAGE="https://www.termux.com"
TERMUX_PKG_DESCRIPTION="Padre Livio Fanzaga ASCII art"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@enrilinux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_METAPACKAGE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true

build() {
    echo "Nothing here"
}

package() {
    install -Dm755 "$TERMUX_PKG_BUILDER_DIR/padrelivio" "$TERMUX_PREFIX/bin/padrelivio"
}
