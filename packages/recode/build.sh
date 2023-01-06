TERMUX_PKG_HOMEPAGE="https://github.com/pinard/Recode"
TERMUX_PKG_DESCRIPTION="Charset converter tool and library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
TERMUX_PKG_VERSION=3.7.13
TERMUX_PKG_SRCURL=https://github.com/rrthomas/recode/releases/download/v${TERMUX_PKG_VERSION}/recode-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22bbdf79725a59f4d84c3dad63a911c5e8f443f109443c032cad564900b6b733
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv"
# recode needs to be explicitly linked to avoid:
# CANNOT LINK EXECUTABLE "recode": cannot locate symbol "libiconv_open"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-liconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
ac_cv_path_HELP2MAN=:
"
