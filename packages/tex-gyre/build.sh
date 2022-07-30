TERMUX_PKG_HOMEPAGE=http://www.gust.org.pl/projects/e-foundry/tex-gyre/
TERMUX_PKG_DESCRIPTION="The TeX Gyre (TG) Collection of Fonts"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="GUST-FONT-LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.501
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg${TERMUX_PKG_VERSION//./_}otf.zip
TERMUX_PKG_SHA256=d7f8be5317bec4e644cf16c5abf876abeeb83c43dbec0ccb4eee4516b73b1bbe
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_download http://www.gust.org.pl/fonts/licenses/GUST-FONT-LICENSE.txt \
		$TERMUX_PKG_SRCDIR/GUST-FONT-LICENSE.txt \
		a746108477b2fa685845e7596b7ad8342bc358704b2b7da355f2df0a0cb8ad85
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/fonts/tex-gyre *.otf
}
