TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-gtk-theme
TERMUX_PKG_DESCRIPTION="Fluent is a Fluent design theme for GNOME/GTK based desktop environments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=2022.01.15
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=e0cff57bd6b0a153315155584f144785d743fb29d30c5a3ea9e14bfbad7aad17 
TERMUX_PKG_DEPENDS="gtk3, gtk2-engines-murrine"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/themes
}
