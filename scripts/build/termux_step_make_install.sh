termux_step_make_install() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES install
	elif test -f setup.py || test -f pyproject.toml || test -f setup.cfg; then
		pip install --no-deps . --prefix $TERMUX_PREFIX
	elif ls ./*.cabal &>/dev/null; then
		termux-ghc-setup copy
		if [ "${TERMUX_PKG_IS_HASKELL_LIB}" = true ]; then
			termux-ghc-setup register --gen-script
			termux-ghc-setup unregister --gen-script

			install -Dm744 register.sh "${TERMUX_PREFIX}"/share/haskell/register/"${TERMUX_PKG_NAME}".sh
			install -Dm744 unregister.sh "${TERMUX_PREFIX}"/share/haskell/unregister/"${TERMUX_PKG_NAME}".sh

			sed -i -r -e "s|$(command -v termux-ghc-pkg)|${TERMUX_PREFIX}/bin/ghc-pkg|g" \
				-e "s|ghc-pkg.*update[^ ]* |&'--force' |" \
				-e "s|export PATH=.*||g" \
				"${TERMUX_PREFIX}"/share/haskell/register/"${TERMUX_PKG_NAME}".sh

			sed -i -r -e "s|$(command -v termux-ghc-pkg)|${TERMUX_PREFIX}/bin/ghc-pkg|g" \
				-e "s|export PATH=.*||g" \
				-e "s|ghc-pkg.*unregister[^ ]* |&'--force' |" \
				"${TERMUX_PREFIX}"/share/haskell/unregister/"${TERMUX_PKG_NAME}".sh
		fi

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
