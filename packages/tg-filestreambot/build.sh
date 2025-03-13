TERMUX_PKG_HOMEPAGE=https://github.com/EverythingSuckz/TG-FileStreamBot
TERMUX_PKG_DESCRIPTION="A Telegram bot to generate direct link for your Telegram files. "
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL=https://github.com/EverythingSuckz/TG-FileStreamBot/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53bc9fda697bce2cfdef2a484901bd150c1d7d970f3c90ddd8027a2cf432daa9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go mod tidy
	go build -o fsb -ldflags="-checklinkname=0 -s -w" ./cmd/fsb
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/fsb
}
