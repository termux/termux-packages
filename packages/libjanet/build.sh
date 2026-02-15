TERMUX_PKG_HOMEPAGE=https://janet-lang.org
TERMUX_PKG_DESCRIPTION="Development library for Janet"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION="1.41.1"
TERMUX_PKG_SRCURL=https://github.com/janet-lang/janet/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f35dfe8198ead4aca27415a43f2e16f419f3a4c9666999211a552b196ab0b253
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "failed to perform host-build for janet"

	cat >> config.mk <<-EOF
	HOSTCC=$(command -v gcc)
	EOF

	make -j "${TERMUX_PKG_MAKE_PROCESSES}" build/janet_boot
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" build/janet_host
}

# Prefer Make over Meson
termux_step_configure() { :; }

termux_step_make() {
	cat >> config.mk <<-EOF
	PREFIX=${TERMUX_PREFIX}
	CFLAGS=${CPPFLAGS} ${CFLAGS}
	LDFLAGS=${LDFLAGS} -landroid-spawn
	LIBJANET_LDFLAGS=\$(LDFLAGS)
	EOF

	make -j "${TERMUX_PKG_MAKE_PROCESSES}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" HAS_SHARED=0
}

termux_step_make_install() {
	make build/janet.pc
	install -Dm700 -t "${TERMUX_PREFIX}/bin" build/janet
	install -Dm600 -t "${TERMUX_PREFIX}/include" build/janet.h
	install -Dm600 -t "${TERMUX_PREFIX}/lib" build/libjanet.a
	install -Dm600 build/libjanet.so "${TERMUX_PREFIX}/lib/libjanet.so.${TERMUX_PKG_VERSION}"
	ln -sf "${TERMUX_PREFIX}/lib/"{libjanet.so.${TERMUX_PKG_VERSION},libjanet.so.${TERMUX_PKG_VERSION%.*}}
	ln -sf "${TERMUX_PREFIX}/lib/"{libjanet.so.${TERMUX_PKG_VERSION%.*},libjanet.so}
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" janet.1
	install -Dm600 -t "${TERMUX_PREFIX}/lib/pkgconfig" build/janet.pc
}

termux_step_post_make_install() {
	# Fix rebuilds without ./clean.sh.
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}
