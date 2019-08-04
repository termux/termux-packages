TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.12.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=3bd0b5c8e4c5175263dc9a92fd9aef94ce917e80af034f26fe5c45fde7e0f771
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc, zlib"
TERMUX_PKG_BREAKS="subversion-dev"
TERMUX_PKG_REPLACES="subversion-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
svn_cv_pycfmt_apr_int64_t=UNUSED_REMOVE_AFTER_NEXT_UPDATE
--without-sasl
--without-libmagic
"

termux_step_pre_configure() {
	CFLAGS+=" -std=c11"
}
