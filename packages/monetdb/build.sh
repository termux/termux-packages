TERMUX_PKG_HOMEPAGE=https://www.monetdb.org/
TERMUX_PKG_DESCRIPTION="A high-performance database kernel for query-intensive applications"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.47.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.monetdb.org/downloads/sources/archive/MonetDB-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e248df0e41803ed9c3b43e2d1179808c12769ed2ccc9314f89a308c111401a44
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, libbz2, libcurl, libiconv, liblz4, liblzma, libxml2 (>= 2.11.4-2), netcdf-c, pcre, readline, zlib"
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
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_post_get_source() {
	find . -name '*.c' | xargs -n 1 sed -i \
		-e 's:"\(/tmp\):"'$TERMUX_PREFIX'\1:g'
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-sysv-semaphore -lm"
}
