TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-gtk-theme
TERMUX_PKG_DESCRIPTION="Fluent is a Fluent design theme for GNOME/GTK based desktop environments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <yisus7u7v@gmail.com>"
TERMUX_PKG_VERSION=2021.12.20
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=505723190391941147183807cb550a1b5ac0115fb2b01ce3f3b0da63b4fbafa4
TERMUX_PKG_DEPENDS="gtk3, gtk2-engines-murrine"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/themes
}
