TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (command line utility)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BREAKS="brotli-dev"
TERMUX_PKG_REPLACES="brotli-dev"
TERMUX_PKG_FORCE_CMAKE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local _ABI_CURRENT="$(grep -E '^#define\s+BROTLI_ABI_CURRENT\s+' \
			c/common/version.h | awk '{ print $3 }')"
	local _ABI_AGE="$(grep -E '^#define\s+BROTLI_ABI_AGE\s+' \
			c/common/version.h | awk '{ print $3 }')"
	local v=$(( _ABI_CURRENT - _ABI_AGE ))
	if [ ! "${_ABI_CURRENT}" ] || [ ! "${_ABI_AGE}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp "$TERMUX_PKG_SRCDIR/docs/brotli.1" "$TERMUX_PREFIX/share/man/man1/"
	cp "$TERMUX_PKG_SRCDIR"/docs/*.3 "$TERMUX_PREFIX/share/man/man3/"

	cd "$TERMUX_PKG_SRCDIR"
	# ERROR: ./lib/python3.12/site-packages/_brotli.cpython-312.so contains undefined symbols:
	# 31: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND log2
	LDFLAGS+=" -lm"
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
	pip install . --prefix="$TERMUX_PREFIX" -vv --no-build-isolation --no-deps
}
