TERMUX_PKG_HOMEPAGE=https://alist.nn.ci
TERMUX_PKG_DESCRIPTION="A file list program that supports multiple storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION=(3.22.1) # alist version
TERMUX_PKG_VERSION+=(3.22.0) # alist-web version
TERMUX_PKG_SRCURL=(https://github.com/alist-org/alist/archive/v${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/alist-org/alist-web/releases/download/${TERMUX_PKG_VERSION[1]}/dist.tar.gz)
TERMUX_PKG_SHA256=(d7ca163b972aa861ed4dde2fb37065ffa10bccc5273d88accfcfb633bf079fa7
		   aff30e21c90ec3a456ccb29b5bd09bbac8a90f6074b7851a7613f062e74dad45)
TERMUX_PKG_BUILD_IN_SRC=true
# termux_pkg_upgrade_version couldn't check multiple versions now.
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_get_source() {
	rm -rf public/dist
	mv -f dist public
}

termux_step_make() {
	termux_setup_golang

	local ldflags
	local _builtAt=$(date +'%F %T %z')
	local _goVersion=$(go version | sed 's/go version //')
	local _gitAuthor="Andy Hsu <i@nn.ci>"
	local _gitCommit=$(git ls-remote https://github.com/alist-org/alist refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export CGO_ENABLED=1

	ldflags="\
	-w -s \
	-X 'github.com/alist-org/alist/v3/internal/conf.BuiltAt=$_builtAt' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GoVersion=$_goVersion' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitAuthor=$_gitAuthor' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitCommit=$_gitCommit' \
	-X 'github.com/alist-org/alist/v3/internal/conf.Version=$TERMUX_PKG_VERSION' \
	-X 'github.com/alist-org/alist/v3/internal/conf.WebVersion=${TERMUX_PKG_VERSION[1]}' \
	"
	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags" -tags=jsoniter
}

termux_step_make_install() {
	install -Dm700 ./"${TERMUX_PKG_NAME}" "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/bin

	install -Dm644 /dev/null "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash"
	install -Dm644 /dev/null "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/share/zsh/site-functions/_alist"
	install -Dm644 /dev/null "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		alist completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash
		alist completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_alist
		alist completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish
	EOF
}
