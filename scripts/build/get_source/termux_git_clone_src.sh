termux_git_clone_src() {
	local TMP_CHECKOUT=$TERMUX_PKG_CACHEDIR/tmp-checkout
	local TMP_CHECKOUT_VERSION=$TERMUX_PKG_CACHEDIR/tmp-checkout-version

	if [ ! -f $TMP_CHECKOUT_VERSION ] || [ "$(cat $TMP_CHECKOUT_VERSION)" != "$TERMUX_PKG_VERSION" ]; then
		if [ "$TERMUX_PKG_GIT_BRANCH" == "" ]; then
			TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION#*:}
		fi

		rm -rf $TMP_CHECKOUT
		git clone --depth 1 \
			--branch $TERMUX_PKG_GIT_BRANCH \
			${TERMUX_PKG_SRCURL:4} \
			$TMP_CHECKOUT

		pushd $TMP_CHECKOUT
		git submodule update --init --recursive --depth=1
		popd

		ACTUAL_CHECKSUM=$(git -c core.abbrev=no -C "$TMP_CHECKOUT" archive --format tar "$TERMUX_PKG_GIT_BRANCH" | sha256sum 2>&1)
		if [ "$TERMUX_PKG_SHA256" != "${ACTUAL_CHECKSUM%% *}" ]; then
			>&2 printf "Wrong checksum for %s\nExpected: %s\nActual:   %s\n" \
				"${TERMUX_PKG_SRCURL:4}" "$TERMUX_PKG_SHA256" "$ACTUAL_CHECKSUM"
			return 1
		fi

		echo "$TERMUX_PKG_VERSION" > $TMP_CHECKOUT_VERSION
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $TMP_CHECKOUT $TERMUX_PKG_SRCDIR
}
