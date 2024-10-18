TERMUX_PKG_HOMEPAGE=https://github.com/cswinter/LocustDB
TERMUX_PKG_DESCRIPTION="An experimental analytics database"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.6"
TERMUX_PKG_SRCURL=https://github.com/cswinter/LocustDB/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db1ee671dab19c1226a0c2d56007fd186b5c6b2ce230b9c1775bba20e19d8c28
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# ```
# error: this arithmetic operation will overflow
#    --> src/locustdb.rs:189:36
#     |
# 189 |             mem_size_limit_tables: 8 * 1024 * 1024 * 1024, // 8 GiB
#     |                                    ^^^^^^^^^^^^^^^^^^^^^^ attempt to multiply with overflow
#     |
#     = note: `#[deny(arithmetic_overflow)]` on by default
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -T target/${CARGO_TARGET_NAME}/release/repl $TERMUX_PREFIX/bin/locustdb
}
