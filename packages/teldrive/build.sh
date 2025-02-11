TERMUX_PKG_HOMEPAGE=https://github.com/tgdrive/teldrive
TERMUX_PKG_DESCRIPTION="A high-speed Telegram file management utility"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.12"
TERMUX_PKG_SRCURL=https://github.com/tgdrive/teldrive/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbde2663622f2a5c2e21975649e4e00531d4d0d8511932ac5c1f4ea220a82437
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_nodejs
	git clone https://github.com/tgdrive/teldrive-ui && cd teldrive-ui
	npm install
	npm run build
	termux_setup_golang
	pushd "${TERMUX_PKG_SRCDIR}"
	go generate ./...
	popd
}

termux_step_pre_configure() {
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/teldrive-ui/dist $TERMUX_PKG_SRCDIR/ui/
	termux_setup_golang
}

termux_step_make() {
	go build -o teldrive -trimpath -ldflags="-checklinkname=0 -s -w -X github.com/tgdrive/teldrive/internal/version.Version=${TERMUX_PKG_VERSION} -X github.com/tgdrive/teldrive/internal/version.CommitSHA={{ .ShortCommit }}"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/teldrive
}
