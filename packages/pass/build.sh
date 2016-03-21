TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org/
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_VERSION=1.6.5
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="bash, coreutils, gnupg, pwgen, tree"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
