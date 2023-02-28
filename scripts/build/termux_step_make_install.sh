# shellcheck disable=SC2086
termux_step_make_install() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES install
	elif test -f setup.py || test -f pyproject.toml || test -f setup.cfg; then
		pip install --no-deps . --prefix $TERMUX_PREFIX
	elif ls ./*.cabal &>/dev/null; then
		# Workaround until `cabal install` is fixed.
		while read -r bin; do
			[[ -f "$bin" ]] || termux_error_exit "'$bin', no such file. Has build completed?"
			echo "INFO: Installing '$bin' component..."
			cp "$bin" "$TERMUX_PREFIX/bin"
		done< <(cat ./dist-newstyle/cache/plan.json | jq -r '."install-plan"[]|select(."component-name"? and (."component-name"|test("exe:.*")) and (.style == "local") )|."bin-file"')
	elif ls ./*akefile &>/dev/null || [ -n "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		: "${TERMUX_PKG_MAKE_INSTALL_TARGET:="install"}"
		# Some packages have problem with parallell install, and it does not buy much, so use -j 1.
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j 1 ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		else
			make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		fi
	elif test -f Cargo.toml; then
		termux_setup_rust
		cargo install \
			--jobs $TERMUX_MAKE_PROCESSES \
			--path . \
			--force \
			--locked \
			--no-track \
			--target $CARGO_TARGET_NAME \
			--root $TERMUX_PREFIX \
			$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	fi
}
