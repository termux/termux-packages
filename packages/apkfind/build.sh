cat << 'EOF' > build.sh
TERMUX_PKG_HOMEPAGE=https://github.com/Deuterium-P/apkfind
TERMUX_PKG_DESCRIPTION="Cross-platform app version compatibility finder for Android, HyperOS, and iOS"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Deuterium-P"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/Deuterium-P/apkfind/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4cb709b14513597b4ffc188d5c12cf1192975fe60fa00368b845865c19713542
TERMUX_PKG_DEPENDS="curl, jq"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install -Dm755 apkfind "${TERMUX_PREFIX}/bin/apkfind"
}
EOF
