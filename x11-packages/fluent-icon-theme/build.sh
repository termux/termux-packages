TERMUX_PKG_HOMEPAGE=https://github.com/vinceliuice/Fluent-icon-theme
TERMUX_PKG_DESCRIPTION="Fluent icon theme for linux desktops"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=2022.11.05
TERMUX_PKG_SRCURL=https://github.com/vinceliuice/Fluent-icon-theme/archive/${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=b942fd28994786af435e5da89da05316f49a9e71edc572b1c8bdcb41600fa495
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/*/icon-theme.cache"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install(){
	./install.sh -d ${TERMUX_PREFIX}/share/icons -r
}
