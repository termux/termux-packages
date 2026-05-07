TERMUX_PKG_HOMEPAGE=https://github.com/nginx/nginx-acme/
TERMUX_PKG_DESCRIPTION="NGINX module with the implementation of the automatic certificate management (ACMEv2) protocol"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.1"
TERMUX_PKG_SRCURL="https://github.com/nginx/nginx-acme/releases/download/v$TERMUX_PKG_VERSION/nginx-acme-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b4f99f971bd0bebc89b2037f3afeaa3281004fe434de558df87d69cab2be1f22
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, nginx"
# build-only dependency
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/nginx/modules.d/20-ngx_http_acme_module.conf"

# translation of Arch Linux PKGBUILD to Termux build.sh of this logic:
# https://gitlab.archlinux.org/archlinux/packaging/packages/nginx-mod-acme/-/blob/8b7b30b8520928898d00941dcfe9a308b4923baa/PKGBUILD
# nginx source code is acquired, melded with the plugin source code, then
# patched and configured the same way it's built in the main nginx package,
# then cargo build is used with the configured nginx to build the plugin

termux_step_configure() {
	(
		. "$TERMUX_SCRIPTDIR/packages/nginx/build.sh"
		TERMUX_PKG_BUILDER_DIR="$TERMUX_SCRIPTDIR/packages/nginx"
		termux_step_get_source
		termux_step_patch_package
		termux_step_pre_configure
		termux_step_configure
	)
}

termux_step_make() {
	termux_setup_rust
	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
		arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi${TERMUX_PKG_API_LEVEL}" ;;
		*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android${TERMUX_PKG_API_LEVEL}" ;;
	esac
	BINDGEN_EXTRA_CLANG_ARGS+=" $CPPFLAGS"
	export NGINX_BUILD_DIR="${TERMUX_PKG_SRCDIR}/objs"
	cargo build --target "${CARGO_TARGET_NAME}" --release --all-features
}

termux_step_make_install() {
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/libnginx_acme.so" \
		"${TERMUX_PREFIX}/lib/nginx/modules/ngx_http_acme_module.so"

	install -dm755 "${TERMUX_PREFIX}/etc/nginx/modules.d"
	echo "load_module ${TERMUX_PREFIX}/lib/nginx/modules/ngx_http_acme_module.so;" > \
		"${TERMUX_PREFIX}/etc/nginx/modules.d/20-ngx_http_acme_module.conf"
}
