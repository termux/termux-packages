TERMUX_PKG_HOMEPAGE=https://grafana.com/
TERMUX_PKG_DESCRIPTION="The open-source platform for monitoring and observability"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.5.21
TERMUX_PKG_SRCURL=git+https://github.com/grafana/grafana
TERMUX_PKG_BUILD_DEPENDS="yarn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="SPEC_TARGET= MERGED_SPEC_TARGET="

termux_step_pre_configure() {
	termux_setup_golang
	termux_setup_nodejs

	local bin=$TERMUX_PKG_BUILDDIR/_bin
	mkdir -p $bin
	GOOS=linux GOARCH=amd64 go build build.go
	mv build $bin/_build
	local goexec=$bin/go_$(go env GOOS)_$(go env GOARCH)_exec
	cat > $goexec <<-EOF
		#!$(command -v sh)
		shift
		exec $bin/_build -goos=$GOOS -goarch=$GOARCH "\$@"
		EOF
	chmod 0755 $goexec

	local yarn=$bin/yarn
	cat > $yarn <<-EOF
		#!$(command -v sh)
		exec sh $TERMUX_PREFIX/bin/yarn "\$@"
		EOF
	chmod 0755 $yarn

	export PATH=$bin:$PATH

	export NODE_OPTIONS=--max-old-space-size=6000
	NODE_OPTIONS+=" --openssl-legacy-provider"

	yarn set version 3.2.4
}

termux_step_make() {
	make $TERMUX_PKG_EXTRA_MAKE_ARGS build-go
	make $TERMUX_PKG_EXTRA_MAKE_ARGS deps-js
	make $TERMUX_PKG_EXTRA_MAKE_ARGS build-js
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*/grafana-server bin/*/grafana-cli
	local sharedir=$TERMUX_PREFIX/share/grafana
	mkdir -p $sharedir
	for d in conf public; do
		cp -rT $d $sharedir/$d
	done
}
