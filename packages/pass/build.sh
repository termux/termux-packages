TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org/
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="bash, gnupg, pwgen, tree"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_SHA256=f6d2199593398aaefeaa55e21daddfb7f1073e9e096af6d887126141e99d9869
