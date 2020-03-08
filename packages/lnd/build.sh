TERMUX_PKG_HOMEPAGE=https://github.com/lightningnetwork/lnd
TERMUX_PKG_DESCRIPTION="Lightning Network Daemon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9.1-beta
TERMUX_PKG_SRCURL=(https://github.com/lightningnetwork/lnd/archive/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/lightningnetwork/lnd/releases/download/v${TERMUX_PKG_VERSION}/vendor.tar.gz)
TERMUX_PKG_SHA256=(b0b0386e7e5a0edf08f3d333523915cd9c1255c7bf854f56d2e19078ecef0e3a
                   b5c8285ac709672c051a1b1b92a281183b90d4a84102f497cb45bb47f8f007f8)
TERMUX_PKG_DEPENDS="bitcoin"
TERMUX_PKG_CONFFILES="var/service/lnd/run var/service/lnd/log/run"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lnd
	GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lncli
}

termux_step_make_install() {
	install -Dm700 lnd lncli "$TERMUX_PREFIX"/bin/
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p lnd/log
	echo "#!$TERMUX_PREFIX/bin/sh" > lnd/run
	echo 'exec lnd 2>&1' >> lnd/run
	chmod +x lnd/run
	touch lnd/down

	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger lnd/log/run
}
