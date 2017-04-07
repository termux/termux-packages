TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org/
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_VERSION=1.7
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="bash, gnupg, pwgen, tree"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_SHA256=161ac3bd3c452a97f134aa7aa4668fe3f2401c839fd23c10e16b8c0ae4e15500
