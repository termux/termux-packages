TERMUX_PKG_HOMEPAGE=https://github.com/46Neon/Milena
TERMUX_PKG_DESCRIPTION="Spanish programming language for reproducible data analysis"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@46Neon"
TERMUX_PKG_VERSION=0.2.0
TERMUX_PKG_SRCURL=https://github.com/46Neon/Milena/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=56e189bbd1e89aa25a7e8588e0606f0ea42d3bf5f1086fcfa3442d632d571153
# Milena only links against the Android/Bionic system libc and libm.
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	[[ -f Makefile ]] || termux_error_exit "Milena source is missing Makefile."
	[[ -f LICENSE ]] || termux_error_exit "Milena source is missing LICENSE."
	grep -q '^TARGET = milena$' Makefile || \
		termux_error_exit "Refusing to build a non-canonical Milena target."
	grep -q '^#define MILENA_VERSION "0.2.0"$' include/common.h || \
		termux_error_exit "Milena source identity/version check failed."
	[[ -f src/language_runtime.c && -f src/language_semantic.c ]] || \
		termux_error_exit "Canonical language runtime sources are missing."
}

termux_step_make() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" \
		TERMUX=1 \
		CC="${CC:-clang}" \
		CFLAGS="${CFLAGS:-} -std=c17 -Iinclude" \
		LDFLAGS="${LDFLAGS:-} -lm -Wl,--gc-sections" \
		all
}

termux_step_make_install() {
	install -Dm755 milena "${TERMUX_PREFIX}/bin/milena"
	install -Dm644 README.md "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/README.md"
}

termux_step_post_make_install() {
	[[ -x "${TERMUX_PREFIX}/bin/milena" ]] || \
		termux_error_exit "Milena binary was not installed."
}
