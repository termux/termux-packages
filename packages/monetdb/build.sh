TERMUX_PKG_HOMEPAGE=https://www.monetdb.org/
TERMUX_PKG_DESCRIPTION="A high-performance database kernel for query-intensive applications"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.55.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://www.monetdb.org/downloads/sources/archive/MonetDB-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9592aa0fb18aeb22ceb6a4f9b60cd7960362832704e3625a025673e89e861a51
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, libbz2, libcurl, libiconv, liblz4, liblzma, libxml2, netcdf-c, pcre2, readline, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DODBC=OFF
-DTESTING=OFF
"

# ```
# In file included from [...]/src/common/stream/stream.c:58:
# In file included from [...]/src/common/stream/stream_internal.h:19:
# [...]/src/common/utils/matomic.h:90:2: error: "we need _Atomic(unsigned long long) to be lock free"
# #error "we need _Atomic(unsigned long long) to be lock free"
#  ^
# ```
TERMUX_PKG_EXCLUDED_ARCHES="i686"

termux_step_post_get_source() {
	find . -name '*.c' | xargs -n 1 sed -i \
		-e 's:"\(/tmp\):"'$TERMUX_PREFIX'\1:g'
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-sysv-semaphore -lm"
}
