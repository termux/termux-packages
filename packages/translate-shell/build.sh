TERMUX_PKG_HOMEPAGE=https://github.com/soimort/translate-shell
TERMUX_PKG_DESCRIPTION="Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc."
TERMUX_PKG_VERSION=0.9.6.5
TERMUX_PKG_SRCURL=https://github.com/soimort/translate-shell/archive/v${TERMUX_PKG_VERSION}.tar.gz
# also available as .zip
TERMUX_PKG_MAINTAINER="@Quasic"
TERMUX_PKG_DEPENDS="bash, gawk"
# can use zsh instead of bash, other dependencies are optional
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_BUILD_IN_SRC=yes
