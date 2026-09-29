TERMUX_PKG_HOMEPAGE=https://docker.com
TERMUX_PKG_DESCRIPTION="Set of products that use OS-level virtualization to deliver software in packages called containers."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=24.0.6
DOCKER_GITCOMMIT=ed223bc
TERMUX_PKG_SRCURL=https://github.com/docker/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c1a4a580ced3633e489c5c9869a20198415da44df7023fdc200d425cdf5fa652

TERMUX_PKG_RECOMMENDS=dockerd
TERMUX_PKG_PROVIDES=docker
TERMUX_PKG_REPLACES=docker
TERMUX_PKG_CONFLICTS=docker

_GOPATH="${TERMUX_PKG_BUILDDIR}"/go
TERMUX_PKG_BUILDDIR="${_GOPATH}"/src/github.com/docker/cli

termux_step_configure() {
	termux_setup_golang
	export GOPATH="${_GOPATH}"

	mkdir -p "${TERMUX_PKG_BUILDDIR}"
	cp -rT "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}"
}

termux_step_make() {
	make=(make -j "${TERMUX_PKG_MAKE_PROCESSES}")
	if [ "$TERMUX_QUIET_BUILD" = true ]; then
		make+=(-s)
	fi

	# Disable this warning,
	# we are using our own build infrastructure that often uses it's own container
	export DISABLE_WARN_OUTSIDE_CONTAINER=1
	export VERSION=v${TERMUX_PKG_VERSION}-ce

	"${make[@]}" dynbinary
	(
		# manpages cannot be cross-compiled
		if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
			unset GOOS GOARCH CGO_LDFLAGS CC CXX CFLAGS CXXFLAGS LDFLAGS
		fi
		"${make[@]}" manpages
	)
}

termux_step_make_install() {
	install -Dm 700 "${TERMUX_PKG_BUILDDIR}"/build/docker-android-* "${TERMUX_PREFIX}"/bin/docker
	install -Dm 600 -t "${TERMUX_PREFIX}"/share/man/man1 "${TERMUX_PKG_BUILDDIR}"/man/man1/*
	install -Dm 600 -t "${TERMUX_PREFIX}"/share/man/man5 "${TERMUX_PKG_BUILDDIR}"/man/man5/*
	install -Dm 600 -t "${TERMUX_PREFIX}"/share/man/man8 "$TERMUX_PKG_BUILDDIR"/man/man8/*
}

termux_step_create_debscripts() {
	cat >postinst <<-POSTINST_EOF
		#!${TERMUX_PREFIX}/bin/sh

		echo 'NOTE: the \`docker\` package was split into \`docker-cli\` and \`dockerd\`.'
	POSTINST_EOF
}
