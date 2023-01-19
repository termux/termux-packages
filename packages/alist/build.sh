TERMUX_PKG_HOMEPAGE=https://alist.nn.ci
TERMUX_PKG_DESCRIPTION="A file list program that supports multiple storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="3.9.1"
TERMUX_PKG_SRCURL=https://github.com/alist-org/alist/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db43130797448bda7c56fe1ccb3043f0d39faafdbf74e55109f99e17daf02fee
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	# Get alist-web:
	local ldflags webTag
	webTag=$(
		wget -qO- -t1 -T2 "https://api.github.com/repos/alist-org/alist-web/releases/latest" \
			| grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'
	)
	wget https://github.com/alist-org/alist-web/releases/download/${webTag}/dist.tar.gz
	tar -zxvf dist.tar.gz
	rm -rf public/dist
	mv -f dist public
	rm -rf dist.tar.gz

	local _builtAt=$(date +'%F %T %z')
	local _goVersion=$(go version | sed 's/go version //')
	local _gitAuthor="Noah Hsu <i@nn.ci>"
	local _gitCommit=$(git ls-remote https://github.com/alist-org/alist refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export CGO_ENABLED=1

	ldflags="\
	-w -s \
	-X 'github.com/alist-org/alist/v3/internal/conf.BuiltAt=$_builtAt' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GoVersion=$_goVersion' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitAuthor=$_gitAuthor' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitCommit=$_gitCommit' \
	-X 'github.com/alist-org/alist/v3/internal/conf.Version=$TERMUX_PKG_VERSION' \
	-X 'github.com/alist-org/alist/v3/internal/conf.WebVersion=$webTag' \
	"
	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags" -tags=jsoniter
}

termux_step_make_install() {
	install -Dm700 ./"${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}"/bin

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_alist"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		alist completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash
		alist completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_alist
		alist completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish
	EOF
}
