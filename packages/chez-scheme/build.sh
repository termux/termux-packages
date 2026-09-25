TERMUX_PKG_HOMEPAGE=https://cisco.github.io/ChezScheme
TERMUX_PKG_DESCRIPTION="Chez Scheme is both a programming language, an implementation, and a superset of R6RS"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.4.1
TERMUX_PKG_SRCURL="https://github.com/cisco/ChezScheme/releases/download/v${TERMUX_PKG_VERSION}/csv${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2e74952db7bc177f0c3602e2217a341ba677d733eec4cd7726418c3a4e1ef308
TERMUX_PKG_DEPENDS="libiconv, liblz4, ncurses, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Target names copied from Alpine's chez-scheme APKBUILD
	case "${TERMUX_ARCH}" in
		aarch64) CHEZ_HOST=tarm64le ;;
		arm) CHEZ_HOST=tarm32le ;;
		i686) CHEZ_HOST=ti3le ;;
		x86_64) CHEZ_HOST=ta6le ;;
	esac
	export CHEZ_HOST
}

termux_step_host_build() {
	local configure_args=()
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == true ]]; then
		configure_args+=(LIBS=-liconv)
	fi

	"${TERMUX_PKG_SRCDIR}/configure" "${configure_args[@]}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" bootquick XM="${CHEZ_HOST}"
}

termux_step_pre_configure() {
	cp -a "${TERMUX_PKG_HOSTBUILD_DIR}/boot/${CHEZ_HOST}" "${TERMUX_PKG_SRCDIR}/boot/"
}

# Chez Scheme uses a non-Autotools configure script, which does not accept
# the extra options passed by Termux's standard configure step.
termux_step_configure() {
	# X11 is used only for optional clipboard support in the expression editor.
	# Keep this package in the main repository without an X11 dependency.
	./configure --cross --force \
		--prefix="${TERMUX_PREFIX}" \
		--installman="${TERMUX_PREFIX}/share/man" \
		--nogzip-man-pages \
		--machine="${CHEZ_HOST}" \
		--installschemename=chez \
		--installpetitename=chez-petite \
		--disable-x11 \
		ZLIB="-lz" LZ4="-llz4" LIBS="-liconv"
}
