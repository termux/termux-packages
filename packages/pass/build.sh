TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.7.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=2b6c65846ebace9a15a118503dcd31b6440949a30d3b5291dfb5b1615b99a3f4
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
# Depend on coreutils as pass uses [:graph:] when calling tr, which busybox tr does not support:
TERMUX_PKG_DEPENDS="bash, gnupg (>= 2.2.9-1), tree, coreutils"
TERMUX_PKG_RECOMMENDS="git"
TERMUX_PKG_SUGGESTS="pass-otp"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
