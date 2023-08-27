TERMUX_PKG_HOMEPAGE=https://github.com/ggerganov/llama.cpp
TERMUX_PKG_DESCRIPTION="Port of Facebook's LLaMA model in C/C++"
TERMUX_PKG_LICENSE=GPL-3.0
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION=0.0.0-b1094
TERMUX_PKG_SRCURL=https://github.com/ggerganov/llama.cpp/archive/refs/tags/${TERMUX_PKG_VERSION#*-}.tar.gz
TERMUX_PKG_SHA256=315071e1034846e8ed448008cda35da481f056d6495696cb862ef8b94aaae0f6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libopenblas, openmpi"
TERMUX_PKG_RECOMMENDS="python-numpy, python-sentencepiece"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLAMA_MPI=ON
-DBUILD_SHARED_LIBS=ON
-DLLAMA_BLAS=ON
-DLLAMA_BLAS_VENDOR=OpenBLAS
"

# XXX: llama.cpp uses `int64_t`, but on 32-bit Android `size_t` is `int32_t`.
# XXX: I don't think it will work if we simply casting it.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(
		termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}"
	)"

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "0.0.0-${latest_tag}"
}

termux_step_post_make_install() {
	cd "$TERMUX_PREFIX/bin" || exit 1
	mv main llama
	mv server llama-server
}
