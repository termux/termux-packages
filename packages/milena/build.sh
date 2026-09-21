TERMUX_PKG_HOMEPAGE=https://github.com/46Neon/Milena
TERMUX_PKG_DESCRIPTION="Spanish programming language for reproducible data analysis"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Milena contributors"
TERMUX_PKG_VERSION=0.2.0
# Pin the source to the canonical Milena commit; the version is not a release tag yet.
TERMUX_PKG_SRCURL="https://github.com/46Neon/Milena/archive/bba8fa987450a824159c0ec90b8332462c96563d.tar.gz"
TERMUX_PKG_SHA256=27502b0c1556f68590c84dde856a95656f23af9ed1519301bc35afab2cc3ba53
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	[[ -f Makefile ]] || termux_error_exit "Milena source is missing Makefile."
	[[ -f LICENSE ]] || termux_error_exit "Milena source is missing LICENSE."
	grep -q '^TARGET = milena$' Makefile || \
		termux_error_exit "Refusing to build a non-canonical Milena target."
	grep -q '^#define MILENA_VERSION "0.2.0-identity"$' include/common.h || \
		termux_error_exit "Milena source identity/version check failed."
	[[ -f src/language_runtime.c && -f src/language_semantic.c ]] || \
		termux_error_exit "Canonical language runtime sources are missing."
}

termux_step_make() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES:-1}" \
		CC="${CC}" \
		CFLAGS="${CFLAGS} -std=c17 -Iinclude" \
		LDFLAGS="${LDFLAGS} -lm"
}

termux_step_make_test() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES:-1}" test
}

termux_step_make_install() {
	install -Dm755 milena "${TERMUX_PREFIX}/bin/milena"
	install -Dm644 LICENSE "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE"
	install -Dm644 README.md "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/README.md"
}

termux_step_post_make_install() {
	[[ -x "${TERMUX_PREFIX}/bin/milena" ]] || \
		termux_error_exit "Milena binary was not installed."
}
