TERMUX_PKG_HOMEPAGE="https://github.com/DebaA17/CVE-scanner-cli"
TERMUX_PKG_DESCRIPTION="Command-line tool to search CVEs using public APIs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@DebaA17"
TERMUX_PKG_VERSION=1.0.7

TERMUX_PKG_SRCURL="https://github.com/DebaA17/CVE-scanner-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=03d2042c57c4edbc655bdd21f7a9a9824c7783cdaeb91f41799be9d5e68c4de3

TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

# Termux doesn't ship separate packages named python-requests/python-rich.
# Instead, let termux-packages vendor pure-Python deps at build time.
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_TARGET_DEPS="requests, rich"

termux_step_make_install() {
    # Install main script to libexec (recommended location)
    install -Dm644 cve_search_cli.py \
        "$TERMUX_PREFIX/libexec/cvecli/cve_search_cli.py"

    # Create executable wrapper in bin/
    install -Dm755 /dev/stdin "$TERMUX_PREFIX/bin/cvecli" <<-EOF
#!/data/data/com.termux/files/usr/bin/sh
exec python "$TERMUX_PREFIX/libexec/cvecli/cve_search_cli.py" "\$@"
EOF
}