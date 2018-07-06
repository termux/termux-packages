TERMUX_PKG_HOMEPAGE=https://gitea.io
TERMUX_PKG_DESCRIPTION="Git with a cup of tea, painless self-hosted git service"
TERMUX_PKG_VERSION=1.5.0-rc1
TERMUX_PKG_SHA256=f86e95ff7f70be55f0bbdefe6ff47a065b78218fd53df21b955ef97c05df8c5b
TERMUX_PKG_SRCURL=https://github.com/go-gitea/gitea/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="git"

termux_step_make () {
	termux_setup_golang

	export GOPATH=${TERMUX_PKG_BUILDDIR}

	mkdir -p "${GOPATH}/src/code.gitea.io"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/code.gitea.io/gitea"
	cd "${GOPATH}/src/code.gitea.io/gitea"

	# go-bindata shoudn't be cross-compiled
	GOOS=linux GOARCH=amd64 go get -u github.com/jteeuwen/go-bindata/...
	export PATH=$PATH:${GOPATH}/bin/

	TAGS="bindata sqlite" make generate all
	cp gitea $TERMUX_PREFIX/bin/gitea
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/bin"
	mkdir -p "${TERMUX_PREFIX}/etc/gitea"

	cp -f "${TERMUX_PKG_BUILDDIR}/src/code.gitea.io/gitea/gitea" "${TERMUX_PREFIX}/bin/"

	cp "${TERMUX_PKG_BUILDER_DIR}/app.ini" "${TERMUX_PREFIX}/etc/gitea/"
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" -i "${TERMUX_PREFIX}/etc/gitea/app.ini"

	cp "${TERMUX_PKG_BUILDER_DIR}/gitea-service.sh" "${TERMUX_PREFIX}/bin/"
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" -i "${TERMUX_PREFIX}/bin/gitea-service.sh"

	chmod +x ${TERMUX_PREFIX}/bin/gitea-service.sh

}


termux_step_post_massage () {

	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/gitea
	mkdir -p ${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/var/log/gitea
}
