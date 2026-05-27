# shellcheck disable=SC2086
termux_step_make_install() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	if test -f build.ninja; then
		if $TERMUX_SAFE_BUILD; then
			$TERMUX_SCRIPTDIR/scripts/meson_prefix.py $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX $TERMUX_PKG_BUILDDIR/meson-private/install.dat
			# strings  $TERMUX_PKG_BUILDDIR/meson-private/install.dat | ack prefix -A1
			# read -p "confirm new prefix path"
		fi
		ninja -j $TERMUX_PKG_MAKE_PROCESSES install
	elif test -f setup.py || test -f pyproject.toml || test -f setup.cfg; then
		pip install --no-deps . --prefix $TERMUX_PREFIX
	elif ls ./*.cabal &>/dev/null || ls ./cabal.project &>/dev/null; then
		# Workaround until `cabal install` is fixed.
		while read -r bin; do
			[[ -f "$bin" ]] || termux_error_exit "'$bin', no such file. Has build completed?"
			echo "INFO: Installing '$bin' component..."
			cp "$bin" "$TERMUX_PREFIX/bin"
		done< <(cat ./dist-newstyle/cache/plan.json | jq -r '."install-plan"[]|select(."component-name"? and (."component-name"|test("exe:.*")) and (.style == "local") )|."bin-file"')
	elif ls ./*akefile &>/dev/null || [ -n "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		if $TERMUX_SAFE_BUILD; then
			: "${TERMUX_PKG_MAKE_INSTALL_TARGET:="install DESTDIR=$TERMUX_PKG_MASSAGEDIR"}"
		else
			: "${TERMUX_PKG_MAKE_INSTALL_TARGET:="install"}"
		fi
		# Some packages have problem with parallell install, and it does not buy much, so use -j 1.
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j 1 ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		else
			make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		fi
	elif test -f Cargo.toml; then
		if $TERMUX_SAFE_BUILD; then
			echo warning  safe rust build is not tested
			SAFE_ROOT=$TERMUX_PKG_MASSAGEDIR
		else
			SAFE_ROOT=
		fi
		if [[ -z "$(command -v cargo)" ]]; then
			termux_error_exit "cargo command is not found! Please add termux_setup_rust in package's build.sh!"
		fi
		cargo install \
			--jobs $TERMUX_PKG_MAKE_PROCESSES \
			--path . \
			--force \
			--locked \
			--no-track \
			--target $CARGO_TARGET_NAME \
			--root $SAFE_ROOT$TERMUX_PREFIX \
			$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	fi
}

termux_step_make_install_multilib() {
	termux_step_make_install
}
