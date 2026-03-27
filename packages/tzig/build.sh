# Package build script for tzig (Zig 0.13.0 + ZLS)
# Only aarch64 and arm are supported

TERMUX_PKG_HOMEPAGE="https://ziglang.org"
TERMUX_PKG_DESCRIPTION="Zig programming language 0.13.0 (compatible with Termux from Google Play) and Zig Language Server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="TIBI624"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_PLATFORM_INDEPENDENT=false

# Restrict to aarch64 and arm only
if [ "${TERMUX_ARCH}" != "aarch64" ] && [ "${TERMUX_ARCH}" != "arm" ]; then
    termux_error_exit "This package is only available for aarch64 and arm architectures."
fi

termux_step_make_install() {
    local _ZIG_URL
    local _ZLS_URL
    local _ZIG_TAR
    local _ZLS_TAR

    case "${TERMUX_ARCH}" in
        aarch64)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-aarch64-${TERMUX_PKG_VERSION}.tar.xz"
            _ZLS_URL="https://github.com/zigtools/zls/releases/download/${TERMUX_PKG_VERSION}/zls-aarch64-linux.tar.xz"
            ;;
        arm)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-armv7a-${TERMUX_PKG_VERSION}.tar.xz"
            _ZLS_URL="https://github.com/zigtools/zls/releases/download/${TERMUX_PKG_VERSION}/zls-arm-linux.tar.xz"
            ;;
    esac

    _ZIG_TAR="${TERMUX_PKG_TMPDIR}/zig.tar.xz"
    _ZLS_TAR="${TERMUX_PKG_TMPDIR}/zls.tar.xz"

    # Download Zig if not already present
    if [ ! -f "${_ZIG_TAR}" ]; then
        termux_download "${_ZIG_URL}" "${_ZIG_TAR}" SKIP_CHECKSUM
    fi

    # Download ZLS if not already present
    if [ ! -f "${_ZLS_TAR}" ]; then
        termux_download "${_ZLS_URL}" "${_ZLS_TAR}" SKIP_CHECKSUM
    fi

    # Install Zig
    rm -rf "${TERMUX_PREFIX}/lib/zig"
    mkdir -p "${TERMUX_PREFIX}/lib/zig"
    tar -xf "${_ZIG_TAR}" -C "${TERMUX_PREFIX}/lib/zig" --strip-components=1

    # Install ZLS
    tar -xf "${_ZLS_TAR}" -C "${TERMUX_PREFIX}/bin" --strip-components=1
    chmod +x "${TERMUX_PREFIX}/bin/zls"

    # Symlink zig to bin
    ln -sf "${TERMUX_PREFIX}/lib/zig/zig" "${TERMUX_PREFIX}/bin/zig"
}