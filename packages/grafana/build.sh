TERMUX_PKG_HOMEPAGE=https://grafana.com/
TERMUX_PKG_DESCRIPTION="The open-source platform for monitoring and observability"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.1.0
TERMUX_PKG_SRCURL=git+https://github.com/grafana/grafana
TERMUX_PKG_BUILD_DEPENDS="yarn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="SPEC_TARGET= MERGED_SPEC_TARGET="
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_nodejs

	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	mkdir -p "$bin"

	local yarn="$bin/yarn"
	cat > "$yarn" <<-EOF
		#!$(command -v sh)
		exec sh $TERMUX_PREFIX/bin/yarn "\$@"
		EOF
	chmod 0755 "$yarn"

	export PATH="$bin:$PATH"

	export NODE_OPTIONS=--max-old-space-size=6000
	NODE_OPTIONS+=" --openssl-legacy-provider"
}

termux_step_post_get_source() {
	termux_setup_golang
	#there is currently a bug in this version of go-sockaddr that prevents building. We download it here to patch it.
	sockaddr_version=v1.0.6
	go mod download github.com/hashicorp/go-sockaddr@$sockaddr_version
	cp -r "$(go env GOPATH)"/pkg/mod/github.com/hashicorp/go-sockaddr@$sockaddr_version go-sockaddr
	chmod +w -R go-sockaddr
}

termux_step_make() {
	GO_BUILD_FLAGS="-goos=$(go env GOOS) -goarch=$(go env GOARCH) -cc=$(go env CC)" \
		GOOS=linux GOARCH=amd64 \
		make "$TERMUX_PKG_EXTRA_MAKE_ARGS" build-go
	make "$TERMUX_PKG_EXTRA_MAKE_ARGS" deps-js
	# get rid of unnecessary things during build to not run out of storage
	rm -r .yarn/cache node_modules/@storybook
	make "$TERMUX_PKG_EXTRA_MAKE_ARGS" build-js
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin bin/*/grafana-server bin/*/grafana-cli bin/*/grafana
	local sharedir="$TERMUX_PREFIX/share/grafana"
	mkdir -p "$sharedir"
	for d in conf public; do
		cp -rT $d "$sharedir"/$d
	done
}
