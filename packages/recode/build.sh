TERMUX_PKG_HOMEPAGE="https://github.com/pinard/Recode"
TERMUX_PKG_DESCRIPTION="Charset converter tool and library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
TERMUX_PKG_VERSION="3.7.14"
TERMUX_PKG_SRCURL=https://github.com/rrthomas/recode/releases/download/v${TERMUX_PKG_VERSION}/recode-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=786aafd544851a2b13b0a377eac1500f820ce62615ccc2e630b501e7743b9f33
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv"
# recode needs to be explicitly linked to avoid:
# CANNOT LINK EXECUTABLE "recode": cannot locate symbol "libiconv_open"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-liconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
ac_cv_path_HELP2MAN=:
"
