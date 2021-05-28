TERMUX_PKG_HOMEPAGE="https://github.com/pinard/Recode"
TERMUX_PKG_DESCRIPTION="Charset converter tool and library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
TERMUX_PKG_VERSION="3.7.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rrthomas/recode/releases/download/v${TERMUX_PKG_VERSION}/recode-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fb75cacc7b80fda7147ea02580eafd2b4493461fb75159e9a49561d3e10cfa7
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
	cp -f "$TERMUX_PKG_BUILDER_DIR/invert-l-to-h" "./build-aux/"
    sed -i 's/scriptversion/if [ "$2" = "\/usr\/bin\/help2man" ]; then\nexit\nfi\nscriptversion/' ./build-aux/missing
}
