TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_VERSION=1.4.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=85b5f952de9df925fd13e00f6e82484162fd506d38745613a50b0a2064c6b02b
TERMUX_PKG_SRCURL=http://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
# ac_cv_c_bigendian=no: We can use /proc/sys/kernel/random/uuid and do not need libuuid.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c_bigendian=no ac_cv_header_uuid_uuid_h=no"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/xapian-config share/man/man1/xapian-config.1"
