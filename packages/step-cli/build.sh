TERMUX_PKG_HOMEPAGE=https://smallstep.com/cli
TERMUX_PKG_DESCRIPTION="An easy-to-use CLI tool for building, operating, and automating Public Key Infrastructure (PKI) systems and workflows"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.30.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/smallstep/cli/releases/download/v${TERMUX_PKG_VERSION}/step_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cea2360b959320cbc81a21b0497bc40811ceb4e822ea77cb21f69507d5e5df08
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="termux-tools"

termux_step_post_get_source() {
	# termux_unpack_src_archive defaults to strip-components=1
	# which works for majority of archives with source code
	# in a subfolder
	# unfortunately this breaks archives with source code at
	# root level
	# manually extract without strip-components
	termux_download_src_archive
	local file="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	termux_setup_golang

	# rename to step-cli like arch linux does to not conflict with KDE step
	# https://gitlab.archlinux.org/archlinux/packaging/packages/step-cli/-/blob/7271a552567d98b0ab3532ba22dc0a2aaeec4e2a/PKGBUILD#L19
	# https://github.com/termux/termux-packages/issues/30285
	sed -i "s/step/${TERMUX_PKG_NAME}/g" autocomplete/zsh_autocomplete
	sed -i "s/step/${TERMUX_PKG_NAME}/g" autocomplete/bash_autocomplete

	local _DATE=$(date -u '+%Y-%m-%d %H:%M UTC')
	go build -v -ldflags "-X \"main.Version=$TERMUX_PKG_VERSION\" -X \"main.BuildTime=$_DATE\"" \
		./cmd/step
}

termux_step_make_install() {
	install -Dm700 step "$TERMUX_PREFIX/bin/${TERMUX_PKG_NAME}"
}


termux_step_post_massage() {
	mkdir -p ./share/bash-completion/completions
	mkdir -p ./share/zsh/site-functions
	mkdir -p ./share/fish/vendor_completions.d
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME} completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}
		${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME} completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}
		${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME} completion fish | sed -e "s/-c step/-c ${TERMUX_PKG_NAME}/g" > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}
		rm -f ${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish
		exit 0
	EOF
}
