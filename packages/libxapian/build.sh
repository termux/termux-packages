TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_VERSION=1.4.6
TERMUX_PKG_SHA256=1e0ef1c1d3e2119874d545b7edbb60e6e17d7d18fb802eb890d9ef7bb0bbd898
TERMUX_PKG_SRCURL=http://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
# ac_cv_c_bigendian=no: We can use /proc/sys/kernel/random/uuid and do not need libuuid.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c_bigendian=no ac_cv_header_uuid_uuid_h=no"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/xapian-config share/man/man1/xapian-config.1"
