TERMUX_PKG_HOMEPAGE=https://github.com/jnsh/arc-theme/
TERMUX_PKG_DESCRIPTION="A flat theme with transparent elements"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20221218
TERMUX_PKG_SRCURL=https://github.com/jnsh/arc-theme/releases/download/${TERMUX_PKG_VERSION}/arc-theme-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=264570cc90a13b88d181334fb325f99a6ddc2a45392aa9ed7dba312aea042bb0
TERMUX_PKG_BUILD_DEPENDS="sassc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=false

termux_step_configure(){
	termux_setup_meson

	$TERMUX_MESON --prefix=${TERMUX_PREFIX} build -Dgnome_shell_gresource=true -Dcinnamon_version=5.6 -Dgnome_shell_version=43

	$TERMUX_MESON compile -C build
}

termux_step_make_install(){
	$TERMUX_MESON install -C build
}
