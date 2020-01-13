TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.13.0
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=bc50ce2c3faa7b1ae9103c432017df98dfd989c4239f9f8270bb3a314ed9e5bd
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
