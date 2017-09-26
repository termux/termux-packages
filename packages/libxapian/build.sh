TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a6a985a9841a452d75cf2169196b7ca6ebeef27da7c607078cd401ad041732d9
# ac_cv_c_bigendian=no: We can use /proc/sys/kernel/random/uuid and do not need libuuid.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c_bigendian=no ac_cv_header_uuid_uuid_h=no"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/xapian-config share/man/man1/xapian-config.1"
