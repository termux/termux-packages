TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-icon-theme
TERMUX_PKG_DESCRIPTION="Fluent icon theme for linux desktops"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <yisus7u7v@gmail.com>"
TERMUX_PKG_VERSION=2022.02.04
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-icon-theme/archive/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=d0bb0cba28e2da3365d15e7fa770d42266793fbe88ac468fb9e6289a2d0fbd64
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/*/icon-theme.cache"

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/icons -b
}
