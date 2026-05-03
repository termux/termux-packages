TERMUX_PKG_HOMEPAGE=https://github.com/HackerCompagnion7/qr-analyzer-pro
TERMUX_PKG_DESCRIPTION="Professional QR code analyzer - detects type (WiFi, URL, vCard, email, SMS, geo, OTP, Bitcoin) with history, stats and generator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@HackerCompagnion7"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/HackerCompagnion7/qr-analyzer-pro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eb3e96e3ba9594ddb145000f09cb49b6e5c6c8f9694dfacf6ec1e4b4a1cbaf05
TERMUX_PKG_DEPENDS="python, zbar"
TERMUX_PKG_RECOMMENDS="python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm755 qr-analyzer-pro "${TERMUX_PREFIX}/bin/qr-analyzer-pro"

	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	install -Dm644 qr-analyzer-pro.1 "${TERMUX_PREFIX}/share/man/man1/qr-analyzer-pro.1"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!$(command -v sh)
		pip install pyzbar pillow 2>/dev/null || true
	EOF
	chmod 755 ./postinst
}
