# Build script for Zig 0.13.0 (legacy version for Termux)
# This package installs Zig 0.13.0 binaries.

TERMUX_PKG_HOMEPAGE="https://ziglang.org"
TERMUX_PKG_DESCRIPTION="Zig programming language 0.13.0 (compatible with Termux from Google Play)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="TIBI624"
TERMUX_PKG_NAME="zig-0.13"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_PLATFORM_INDEPENDENT=false
TERMUX_PKG_AUTO_UPDATE=false

termux_step_make_install() {
    local _ZIG_URL
    case "${TERMUX_ARCH}" in
        aarch64)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-aarch64-${TERMUX_PKG_VERSION}.tar.xz"
            ;;
        arm)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-armv7a-${TERMUX_PKG_VERSION}.tar.xz"
            ;;
        i686)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-x86-${TERMUX_PKG_VERSION}.tar.xz"
            ;;
        x86_64)
            _ZIG_URL="https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-linux-x86_64-${TERMUX_PKG_VERSION}.tar.xz"
            ;;
        *)
            termux_error_exit "Unsupported architecture: ${TERMUX_ARCH}"
            ;;
    esac

    _ZIG_TAR="${TERMUX_PKG_TMPDIR}/zig.tar.xz"

    # Download Zig if not already present
    if [ ! -f "${_ZIG_TAR}" ]; then
        termux_download "${_ZIG_URL}" "${_ZIG_TAR}" SKIP_CHECKSUM
    fi

    # Install Zig
    rm -rf "${TERMUX_PREFIX}/lib/zig"
    mkdir -p "${TERMUX_PREFIX}/lib/zig"
    tar -xf "${_ZIG_TAR}" -C "${TERMUX_PREFIX}/lib/zig" --strip-components=1

    # Copy zig executable directly (no symlink)
    cp "${TERMUX_PREFIX}/lib/zig/zig" "${TERMUX_PREFIX}/bin/zig-0.13"
    chmod +x "${TERMUX_PREFIX}/bin/zig-0.13"
}
