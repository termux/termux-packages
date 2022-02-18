TERMUX_PKG_HOMEPAGE=https://github.com/cswinter/LocustDB
TERMUX_PKG_DESCRIPTION="An experimental analytics database"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/cswinter/LocustDB/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b4ac9e44edc541522b7663ebbb6dfeafaf58a1a4fd060e86af59ed3baec6574a
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

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -T target/${CARGO_TARGET_NAME}/release/repl $TERMUX_PREFIX/bin/locustdb
}
