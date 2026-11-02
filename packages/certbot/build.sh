TERMUX_PKG_HOMEPAGE=https://certbot.eff.org/
TERMUX_PKG_DESCRIPTION="Automatically enable HTTPS on websites with EFF's Certbot"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="certbot/LICENSE.txt"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="5.8.0"
TERMUX_PKG_SRCURL=https://github.com/certbot/certbot/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=84eed9f149b6dd9f43174b4c2cfaf93105a74b58b0eadc82946b65edfde8045b
TERMUX_PKG_DEPENDS="python, python-cryptography, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, setuptools, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="'acme==${TERMUX_PKG_VERSION}', ConfigArgParse, configobj, distro, josepy, parsedatetime, pyrfc3339"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/certbot"
}
