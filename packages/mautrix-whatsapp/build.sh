TERMUX_PKG_HOMEPAGE=https://maunium.net/go/mautrix-whatsapp/
TERMUX_PKG_DESCRIPTION="A Matrix-WhatsApp puppeting bridge"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08"
TERMUX_PKG_SRCURL="https://github.com/mautrix/whatsapp/archive/refs/tags/v0.${TERMUX_PKG_VERSION/.}.0.tar.gz"
TERMUX_PKG_SHA256=536ebb23ecb410c84af0fbeb1ea04d62fa7020c74139e1959754a089cccd5d92
TERMUX_PKG_DEPENDS="libolm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="0\.\K\d+(?=\.0)"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/([0-9][0-9])([0-9][0-9])/\1.\2/"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build \
	-ldflags "-X main.Tag=$TERMUX_PKG_VERSION -X 'main.BuildTime=$(date -d @"$SOURCE_DATE_EPOCH" '+%b %_d %Y, %H:%M:%S')'" \
	./cmd/mautrix-whatsapp
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin mautrix-whatsapp
}
