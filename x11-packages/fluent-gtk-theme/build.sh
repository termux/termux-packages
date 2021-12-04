TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-gtk-theme
TERMUX_PKG_DESCRIPTION="Fluent is a Fluent design theme for GNOME/GTK based desktop environments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <jesuspixel5@gmail.com>"
TERMUX_PKG_VERSION=2021.11.23
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=c416900ae9f3e036dde53279e25c00c6f055a0f54cb7f680bf9f6caeefd2ce92
TERMUX_PKG_DEPENDS="gtk3, gtk2-engines-murrine"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/themes
}
