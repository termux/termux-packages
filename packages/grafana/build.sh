TERMUX_PKG_HOMEPAGE=https://grafana.com/
TERMUX_PKG_DESCRIPTION="The open-source platform for monitoring and observability"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:13.2.3"
TERMUX_PKG_SRCURL=git+https://github.com/grafana/grafana
TERMUX_PKG_BUILD_DEPENDS="yarn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="SPEC_TARGET= MERGED_SPEC_TARGET="
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_post_get_source() {
	termux_setup_golang
	go work vendor
}

termux_step_pre_configure() {
	termux_setup_nodejs

	export YARN_ENABLE_HARDENED_MODE=0

	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	mkdir -p "$bin"

	local yarn="$bin/yarn"
	cat > "$yarn" <<-EOF
		#!$(command -v sh)
		exec sh $TERMUX_PREFIX/bin/yarn "\$@"
		EOF
	chmod 0755 "$yarn"

	export PATH="$bin:$PATH"

	NODE_OPTIONS+=" --max-old-space-size=6000"
	NODE_OPTIONS+=" --openssl-legacy-provider"
}

termux_step_make() {
	make "$TERMUX_PKG_EXTRA_MAKE_ARGS" build-go
	make "$TERMUX_PKG_EXTRA_MAKE_ARGS" deps-js
	# get rid of unnecessary things during build to not run out of storage
	rm -rf .yarn/cache node_modules/@storybook
	make "$TERMUX_PKG_EXTRA_MAKE_ARGS" build-js
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin bin/*/*/grafana
	local c
	for c in server cli; do
		cat > "$TERMUX_PREFIX/bin/grafana-$c" <<-EOF
			#!$TERMUX_PREFIX/bin/sh
			echo "Deprecation warning: 'grafana-$c' is deprecated, use 'grafana $c' instead." >&2
			exec "$TERMUX_PREFIX/bin/grafana" $c "\$@"
		EOF
		chmod 0700 "$TERMUX_PREFIX/bin/grafana-$c"
	done
	local sharedir="$TERMUX_PREFIX/share/grafana"
	mkdir -p "$sharedir"
	for d in conf public; do
		cp -rT $d "$sharedir"/$d
	done
}
