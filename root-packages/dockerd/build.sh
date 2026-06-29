TERMUX_PKG_HOMEPAGE=https://docker.com
TERMUX_PKG_DESCRIPTION="Set of products that use OS-level virtualization to deliver software in packages called containers."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=24.0.6
LIBNETWORK_COMMIT=67e0588f1ddfaf2faf4c8cae8b7ea2876434d91c
DOCKER_GITCOMMIT=ed223bc
TERMUX_PKG_SRCURL=(
	https://github.com/moby/moby/archive/refs/tags/v"${TERMUX_PKG_VERSION}".tar.gz
	https://github.com/moby/libnetwork/archive/"${LIBNETWORK_COMMIT}".tar.gz
)
TERMUX_PKG_SHA256=(
	29a8ee54e9ea008b40eebca42dec8b67ab257eb8ac175f67e79c110e4187d7d2
	4ab6f6c97db834c2eedc053d06c4d32d268f33051b8148098b4a0e8eee51e97b
)
TERMUX_PKG_DEPENDS="containerd, libdevmapper, resolv-conf"
TERMUX_PKG_CONFLICTS="dockerd"
TERMUX_PKG_CONFFILES=etc/docker/daemon.json
TERMUX_PKG_SERVICE_SCRIPT=("dockerd" "exec su -c \"PATH=\$PATH $TERMUX_PREFIX/bin/dockerd 2>&1\"")
TERMUX_PKG_BUILD_IN_SRC=true

termux_extract_src_archive() {
	cd "$TERMUX_PKG_TMPDIR"
	local PKG_SRCURL=("${TERMUX_PKG_SRCURL[@]}")
	for i in $(seq 0 $((${#PKG_SRCURL[@]} - 1))); do
		mkdir -p "$TERMUX_PKG_SRCDIR"
		tar xf "$TERMUX_PKG_CACHEDIR/$(basename "${PKG_SRCURL[$i]}")" -C "$TERMUX_PKG_SRCDIR"
	done
}

termux_step_post_get_source() {
	for folder in *; do
		mv "${folder}" "${folder%%-*}"
	done
}

termux_step_pre_configure() {
	termux_setup_golang
	export GO111MODULE=auto
}

termux_step_make() {
	# BUILD DOCKER DAEMON
	echo -n "Building Docker daemon..."
	(
		set -e
		cd moby

		# issue the build command
		export DOCKER_GITCOMMIT
		export DOCKER_BUILDTAGS='exclude_graphdriver_btrfs exclude_graphdriver_devicemapper exclude_graphdriver_quota selinux exclude_graphdriver_aufs'
		AUTO_GOPATH=1 PREFIX='' hack/make.sh dynbinary
	)
	echo " Done!"

	# BUILD DOCKER-PROXY BINARY FROM LIBNETWORK
	echo -n "Building docker-proxy from libnetwork..."
	(
		set -e

		# fix path locations to build with go
		mkdir -p go/src/github.com/docker
		mv libnetwork go/src/github.com/docker
		mkdir libnetwork
		mv go libnetwork
		export GOPATH="${PWD}"/libnetwork/go
		cd "${GOPATH}"/src/github.com/docker/libnetwork

		# issue the build command
		go build -o docker-proxy github.com/docker/libnetwork/cmd/proxy
	)
	echo " Done!"
}

termux_step_make_install() {
	install -Dm 700 moby/bundles/dynbinary-daemon/dockerd "${TERMUX_PREFIX}"/libexec/dockerd
	install -Dm 700 libnetwork/go/src/github.com/docker/libnetwork/docker-proxy "${TERMUX_PREFIX}"/bin/docker-proxy
	mkdir -p "${TERMUX_PREFIX}"/etc/docker
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/daemon.json >"${TERMUX_PREFIX}"/etc/docker/daemon.json
	chmod 600 "${TERMUX_PREFIX}"/etc/docker/daemon.json
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"${TERMUX_PKG_BUILDER_DIR}/dockerd.sh" >"${TERMUX_PREFIX}/bin/dockerd"
	chmod 700 "${TERMUX_PREFIX}/bin/dockerd"
}

termux_step_post_make_install() {
	# Running sv down dockerd kills just the "su" process but
	# leaves dockerd running (even though it is running in the
	# foreground). This finish script works around that.
	mkdir -p $TERMUX_PREFIX/var/service/dockerd/
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "su -c pkill dockerd"
	} >$TERMUX_PREFIX/var/service/dockerd/finish
	chmod u+x $TERMUX_PREFIX/var/service/dockerd/finish
}

termux_step_create_debscripts() {
	cat <<-EOF >postinst
		#!${TERMUX_PREFIX}/bin/sh

		echo 'NOTE: Docker requires the kernel to support'
		echo 'device cgroups, namespace, VETH, among others.'
		echo
		echo 'To check a full list of features needed, run the script:'
		echo 'https://github.com/moby/moby/blob/master/contrib/check-config.sh'
	EOF
}
