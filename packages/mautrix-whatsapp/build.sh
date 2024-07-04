TERMUX_PKG_HOMEPAGE=https://maunium.net/go/mautrix-whatsapp/
TERMUX_PKG_DESCRIPTION="A Matrix-WhatsApp puppeting bridge"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.8"
TERMUX_PKG_SRCURL=https://github.com/mautrix/whatsapp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7da90c2989f60dae38ae6f8f48fbba6dd4cf781091d9289a935cd07863730b29
TERMUX_PKG_DEPENDS="libolm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -ldflags "-X 'main.BuildTime=$(date '+%b %_d %Y, %H:%M:%S')'"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin mautrix-whatsapp
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME example-config.yaml
}
