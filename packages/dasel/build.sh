TERMUX_PKG_HOMEPAGE=https://github.com/TomWright/dasel
TERMUX_PKG_DESCRIPTION="Select, put and delete data from JSON, TOML, YAML, XML and CSV files with a single utility"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.27.3"
TERMUX_PKG_SRCURL=https://github.com/TomWright/dasel/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1dfd0bf372ab252931adc636887c1d34a75e9ac767b5e6baabf9fd91fdfa15a6
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	go build -o ./bin -trimpath ./cmd/dasel
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
