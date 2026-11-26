TERMUX_PKG_HOMEPAGE="https://binsider.dev"
TERMUX_PKG_DESCRIPTION="A tactical terminal ELF and binary inspector"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.2"
TERMUX_PKG_SRCURL="https://github.com/orhun/binsider/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="78d8ccb0497fd32bdd3c46d1ca6557725154af179021b30a00150e96e4ead8f8"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_RECOMMENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	# Disable dynamic-analysis feature (lurk-cli is unsupported on Android)
	sed -i 's/default = \["dynamic-analysis"\]/default = []/' Cargo.toml
	grep -q 'default = \[\]' Cargo.toml || termux_error_exit "Failed to disable dynamic-analysis feature in Cargo.toml"

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/arboard \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/arboard-fallback.diff"
	local dir="vendor/arboard"
	echo "Applying patch: $patch"
	patch -p1 --ignore-whitespace -d "$dir" < "$patch"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'arboard = { path = "./vendor/arboard" }' >> Cargo.toml

	# Android < 8 (API < 26) does not provide {set,get,end}{pw,gr}ent in libc.
	# Provide stubs so sysinfo can link on API 24, forwarding via dlsym on API >= 26.
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/pwent-stubs.c" -o pwent-stubs.o
	"${AR}" cru libpwent-stubs.a pwent-stubs.o

	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=${TERMUX_PKG_BUILDDIR}/libpwent-stubs.a"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/binsider"
}
