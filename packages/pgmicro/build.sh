TERMUX_PKG_HOMEPAGE='https://github.com/glommer/pgmicro'
TERMUX_PKG_DESCRIPTION='An in-process reimplementation of PostgreSQL, backed by a SQLite-compatible storage engine'
TERMUX_PKG_LICENSE='MIT'
TERMUX_PKG_MAINTAINER='@termux'
TERMUX_PKG_VERSION='0.0.3'
TERMUX_PKG_SRCURL=https://github.com/glommer/pgmicro/archive/refs/tags/pgmicro-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SHA256='17f4279b53eea4508d6b7dfd9033e0665b8f512b4d30c609d81248c99e11e623'

termux_step_pre_configure() {
	termux_setup_rust
}
