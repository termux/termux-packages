TERMUX_PKG_HOMEPAGE=https://github.com/go-shiori/shiori
TERMUX_PKG_DESCRIPTION="Simple bookmark manager built with Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://github.com/go-shiori/shiori/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ccf315a83631e29f297940563cb3966c7a42d67c9d40ca9ca2aab2cc0fbb6d5
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/go-shiori/
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/go-shiori/shiori
	cd "$GOPATH"/src/github.com/go-shiori/shiori/
	go get -d -v

	# https://github.com/termux/termux-packages/issues/18395
	# https://gitlab.com/cznic/libc/-/blob/master/libc_linux.go
	if [[ "${TERMUX_ARCH_BITS}" == "32" ]]; then
		local libc_version=$(grep modernc.org/libc go.mod | awk '{print $2}')
		go mod edit -replace "modernc.org/libc@${libc_version}=./libc"
		rm -fr libc
		cp --no-preserve=mode,ownership -fr "${GOPATH}/pkg/mod/modernc.org/libc@${libc_version}" libc
		sed -e "s|unix.SYS_GETEUID|unix.SYS_GETEUID32|" -i ./libc/libc_linux.go
	fi

	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/go-shiori/shiori/shiori
	mkdir -p "${TERMUX_PREFIX}"/share/doc/shiori
	cp -a "$TERMUX_PKG_SRCDIR"/docs/ "$TERMUX_PREFIX"/share/doc/shiori
}
