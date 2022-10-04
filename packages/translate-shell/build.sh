TERMUX_PKG_HOMEPAGE=https://www.soimort.org/translate-shell
TERMUX_PKG_DESCRIPTION="Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc."
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.7"
TERMUX_PKG_SRCURL=https://github.com/soimort/translate-shell/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fe328bff9670a925f6dd6f80629ed92b078edd9a4c3f8414fbb3d921365c59a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, curl, gawk, less, rlwrap"
# hunspell - spell checking
# mpv - text-to-speech functionality
TERMUX_PKG_RECOMMENDS="hunspell, mpv"
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
