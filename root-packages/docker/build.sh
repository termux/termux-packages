TERMUX_PKG_HOMEPAGE=https://docker.com
TERMUX_PKG_DESCRIPTION="Set of products that use OS-level virtualization to deliver software in packages called containers."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# v20.10.x is the last version confirmed to work.
# Do not update it further unless you tested it on your device.
TERMUX_PKG_VERSION=1:20.10.26
LIBNETWORK_COMMIT=67e0588f1ddfaf2faf4c8cae8b7ea2876434d91c
DOCKER_GITCOMMIT=12df1c1
TERMUX_PKG_SRCURL=(https://github.com/moby/moby/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
                   https://github.com/docker/cli/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
                   https://github.com/moby/libnetwork/archive/${LIBNETWORK_COMMIT}.tar.gz)
TERMUX_PKG_DEPENDS="containerd, libdevmapper"
TERMUX_PKG_SHA256=(47315270a5f8c3274231be7f2ed86b5f081c80ee952d7fdab66065ca1e06871a
                   73ed25a12dc9e470d8346030f6ca060ce8b28d821f3f3854b004e7e2ae60f2e6
                   4ab6f6c97db834c2eedc053d06c4d32d268f33051b8148098b4a0e8eee51e97b)
TERMUX_PKG_CONFFILES="etc/docker/daemon.json"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
	local PKG_SRCURL=(${TERMUX_PKG_SRCURL[@]})
	local PKG_SHA256=(${TERMUX_PKG_SHA256[@]})

	if [ ${#PKG_SRCURL[@]} != ${#PKG_SHA256[@]} ]; then
		termux_error_exit "Error: length of TERMUX_PKG_SRCURL isn't equal to length of TERMUX_PKG_SHA256."
	fi

	# download and extract packages into its own folder inside $TERMUX_PKG_SRCDIR
	mkdir -p "$TERMUX_PKG_CACHEDIR"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	for i in $(seq 0 $(( ${#PKG_SRCURL[@]} - 1 ))); do
		# Archives from moby/moby and docker/cli have same name, so cache them as {moby,cli}-v...
		local file="${TERMUX_PKG_CACHEDIR}/$(echo ${PKG_SRCURL[$i]}|cut -d"/" -f 5)-$(basename ${PKG_SRCURL[$i]})"
		termux_download "${PKG_SRCURL[$i]}" "$file" "${PKG_SHA256[$i]}"
		tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
	done

	# delete trailing -$TERMUX_PKG_VERSION from folder name
	# so patches become portable across different versions
	cd "$TERMUX_PKG_SRCDIR"
	for folder in $(ls); do
		if [ ! $folder == ${folder%%-*} ]; then
			mv $folder ${folder%%-*}
		fi
	done
}

termux_step_pre_configure() {
	# setup go build environment
	termux_setup_golang
	export GO111MODULE=auto
}

termux_step_make() {
	# BUILD DOCKERD DAEMON
	echo -n "Building dockerd daemon..."
	(
	set -e
	cd moby

	# apply some patches in a batch
	xargs sed -i "s_\(/etc/docker\)_${TERMUX_PREFIX}\1_g" < <(grep -R /etc/docker | cut -d':' -f1 | sort | uniq)
	xargs sed -i "s_\(/run/docker/plugins\)_${TERMUX_PREFIX}/var\1_g" < <(grep -R '/run/docker/plugins' | cut -d':' -f1 | sort | uniq)
	xargs sed -i 's/[a-zA-Z0-9]*\.GOOS/"linux"/g' < <(grep -R '[a-zA-Z0-9]*\.GOOS' | cut -d':' -f1 | sort | uniq)

	# issue the build command
	export DOCKER_GITCOMMIT
	export DOCKER_BUILDTAGS='exclude_graphdriver_btrfs exclude_graphdriver_devicemapper exclude_graphdriver_quota selinux exclude_graphdriver_aufs'
	# horrible, but effective way to apply patches on the fly while compiling
	while ! IFS='' files=$(AUTO_GOPATH=1 PREFIX='' hack/make.sh dynbinary 2>&1 1>/dev/null); do
		if ! xargs sed -i 's/\("runtime"\)/_ \1/' < <(echo $files | grep runtime | cut -d':' -f1 | cut -c38-); then
			echo $files;
			exit 1
		fi
	done
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
	export GOPATH="${PWD}/libnetwork/go"
	cd "${GOPATH}/src/github.com/docker/libnetwork"

	# issue the build command
	go build -o docker-proxy github.com/docker/libnetwork/cmd/proxy
	)
	echo " Done!"

	# BUILD DOCKER-CLI CLIENT
	echo -n "Building docker-cli client..."
	(
	set -e

	# fix path locations to build with go
	mkdir -p go/src/github.com/docker
	mv cli go/src/github.com/docker
	mkdir cli
	mv go cli
	export GOPATH="${PWD}/cli/go"
	cd "${GOPATH}/src/github.com/docker/cli"

	# apply some patches in a batch
	xargs sed -i "s_\(/var/run/docker\.sock\)_${TERMUX_PREFIX}\1_g" < <(grep -R /var/run/docker\.sock | cut -d':' -f1 | sort | uniq)

	# issue the build command
	export VERSION=v${TERMUX_PKG_VERSION}-ce
	export DISABLE_WARN_OUTSIDE_CONTAINER=1
	export LDFLAGS="-L ${TERMUX_PREFIX}/lib -r ${TERMUX_PREFIX}/lib"
	make -j ${TERMUX_MAKE_PROCESSES} dynbinary
	unset GOOS GOARCH CGO_LDFLAGS CC CXX CFLAGS CXXFLAGS LDFLAGS
	make -j ${TERMUX_MAKE_PROCESSES} manpages
	)
	echo " Done!"
}

termux_step_make_install() {
	install -Dm 700 moby/bundles/dynbinary-daemon/dockerd ${TERMUX_PREFIX}/libexec/dockerd
	install -Dm 700 libnetwork/go/src/github.com/docker/libnetwork/docker-proxy ${TERMUX_PREFIX}/bin/docker-proxy
	install -Dm 700 cli/go/src/github.com/docker/cli/build/docker-android-* ${TERMUX_PREFIX}/bin/docker
	install -Dm 600 -t ${TERMUX_PREFIX}/share/man/man1 cli/go/src/github.com/docker/cli/man/man1/*
	install -Dm 600 -t ${TERMUX_PREFIX}/share/man/man5 cli/go/src/github.com/docker/cli/man/man5/*
	install -Dm 600 -t ${TERMUX_PREFIX}/share/man/man8 cli/go/src/github.com/docker/cli/man/man8/*
	mkdir -p "${TERMUX_PREFIX}"/etc/docker
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/daemon.json > "${TERMUX_PREFIX}"/etc/docker/daemon.json
        chmod 600 "${TERMUX_PREFIX}"/etc/docker/daemon.json
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
	       "${TERMUX_PKG_BUILDER_DIR}/dockerd.sh" > "${TERMUX_PREFIX}/bin/dockerd"
	chmod 700 "${TERMUX_PREFIX}/bin/dockerd"
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh

		echo 'NOTE: Docker requires the kernel to support'
		echo 'device cgroups, namespace, VETH, among others.'
		echo
		echo 'To check a full list of features needed, run the script:'
		echo 'https://github.com/moby/moby/blob/master/contrib/check-config.sh'
	EOF
}
