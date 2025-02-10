TERMUX_PKG_HOMEPAGE=https://sftpgo.com/
TERMUX_PKG_DESCRIPTION="Full-featured and highly configurable SFTP, HTTP/S, FTP/S and WebDAV server"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.5"
TERMUX_PKG_SRCURL=https://github.com/drakkan/sftpgo/releases/download/v$TERMUX_PKG_VERSION/sftpgo_v${TERMUX_PKG_VERSION}_src_with_deps.tar.xz
TERMUX_PKG_SHA256=d59ff577b786db01bce358c74b99faf9170e53451d89200d9a51276b67ae1e29
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_HOSTBUILD=true

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR" --strip-components=0
}

termux_step_host_build() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	go build -mod vendor -o sftpgo
	mv sftpgo "$TERMUX_PKG_HOSTBUILD_DIR"/sftpgo
}

termux_step_make() {
	termux_setup_golang

	local _commit="$(cat VERSION.txt | head -n 2 | tail -n 1)"
	local _go_ldflags="-s -w"
	_go_ldflags+=" -X github.com/drakkan/sftpgo/v2/internal/version.commit=${_commit}"
	_go_ldflags+=" -X github.com/drakkan/sftpgo/v2/internal/version.date=$(date -u +%FT%TZ)"

	go build -trimpath -ldflags "$_go_ldflags" -mod vendor -o sftpgo
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin sftpgo
	install -Dm600 -t "$TERMUX_PREFIX"/etc/sftpgo sftpgo.json

	mkdir -p "$TERMUX_PREFIX"/share/sftpgo/{templates,static,openapi}
	cp -Rf "$TERMUX_PKG_SRCDIR"/templates/* "$TERMUX_PREFIX"/share/sftpgo/templates
	cp -Rf "$TERMUX_PKG_SRCDIR"/static/* "$TERMUX_PREFIX"/share/sftpgo/static
	cp -Rf "$TERMUX_PKG_SRCDIR"/openapi/* "$TERMUX_PREFIX"/share/sftpgo/openapi

	mkdir -p "$TERMUX_PREFIX"/share/bash-completion/completions
	"$TERMUX_PKG_HOSTBUILD_DIR"/sftpgo gen completion bash > \
		"$TERMUX_PREFIX"/share/bash-completion/completions/sftpgo

	mkdir -p "$TERMUX_PREFIX"/share/zsh/site-functions
	"$TERMUX_PKG_HOSTBUILD_DIR"/sftpgo gen completion zsh > \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_sftpgo

	mkdir -p "$TERMUX_PREFIX"/share/fish/vendor_completions.d
	"$TERMUX_PKG_HOSTBUILD_DIR"/sftpgo gen completion fish > \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/sftpgo.fish

	mkdir -p "$TERMUX_PREFIX"/share/sftpgo/man/man1
	"$TERMUX_PKG_HOSTBUILD_DIR"/sftpgo gen man -d "$TERMUX_PREFIX"/share/sftpgo/man/man1

	# for sftpgo.db
	mkdir -p "$TERMUX_PREFIX"/var/lib/sftpgo
	touch "$TERMUX_PREFIX"/var/lib/sftpgo/.placeholder
}
