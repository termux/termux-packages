TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_VERSION=1.4.9
TERMUX_PKG_SHA256=cde9c39d014f04c09b59d9c21551db9794c10617dc69ab4c9826352a533df5cc
TERMUX_PKG_SRCURL=http://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
# Note that we cannot /proc/sys/kernel/random/uuid (permission denied on
# new android versions) so need libuuid.
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/xapian-config share/man/man1/xapian-config.1"
