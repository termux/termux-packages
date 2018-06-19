TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org/
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_SHA256=4768c5e1965c4d2aeb28818681e484fb105b6f46cbd75a97608615c4ec6980ea
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
# Depend on coreutils as pass uses [:graph:] when calling tr, which
# busybox tr does not support:
TERMUX_PKG_DEPENDS="bash, gnupg2, tree, coreutils"
TERMUX_PKG_RECOMMENDS="git"
TERMUX_PKG_SUGGESTS="pass-otp"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
