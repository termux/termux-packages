TERMUX_PKG_HOMEPAGE=https://cooklang.org
TERMUX_PKG_DESCRIPTION="A suite of tools to create shopping lists and maintain food recipes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.0"
TERMUX_PKG_SRCURL=https://github.com/cooklang/cookcli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b4f7ace0d2d294ad16c989a99937dadb403e8410106aa6f05e7164098d7fa8cc
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# i686: __atomic_load
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}

termux_step_make() {
	npm install
	npm run build-css

	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/cook"
}
