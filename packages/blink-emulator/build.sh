TERMUX_PKG_HOMEPAGE=https://justine.lol/blinkenlights/
TERMUX_PKG_DESCRIPTION="Tiniest x86-64-linux emulator"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/jart/blink/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=38757098cdc9822399fe6eedb9529cc8c79ee44396bbecddce65fb9b7bbb47f9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_configure() {
	# custom configure script that errors
	# instead of ignores unknown arguments
	# also run tests on host rather than target
	# which gives wrong result
	# we run this to generate config.mk
	./configure

	sed -i config.mk \
		-e "s|^TMPDIR =.*|TMPDIR = ${TERMUX_PKG_TMPDIR}|" \
		-e "s|^PREFIX =.*|PREFIX = ${TERMUX_PREFIX}|" \
		-e "s|^CFLAGS =.*|& --sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot|" \
		#-e "s|^LDLIBS =.*|LDLIBS = -L${TERMUX_PREFIX}/lib -lz -lm|" \
		#-e "s|^ZLIB =.*|ZLIB =|"

	# replace config.h and enable all working features
	cp -f config.h.in config.h
	sed -i config.h \
		-e "s|^// #define HAVE_|#define HAVE_|g" \
		-e "s|^#define HAVE_SYSCTL|// #define HAVE_SYSCTL|"


	echo "========== config.log =========="
	cat config.log
	echo "========== config.log =========="
	echo "========== config.h =========="
	cat config.h
	echo "========== config.h =========="
	echo "========== config.mk =========="
	cat config.mk
	echo "========== config.mk =========="
	grep cpu_set_t -nHR $TERMUX_PREFIX || echo "$TERMUX_PREFIX not found"
	grep cpu_set_t -nHR $TERMUX_STANDALONE_TOOLCHAIN || echo "$TERMUX_STANDALONE_TOOLCHAIN not found"
}
