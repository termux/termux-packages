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

		# Workaround some bad server behaviour
		# error: Server does not allow request for unadvertised object commit_no
		# fatal: Fetched in submodule 'submodule_path', but it did not contain commit_no. Direct fetching of that commit failed.
		if ! git submodule update --init --recursive --depth=1; then
			local depth=10
			local maxdepth=100
			sleep 1
			while :; do
				echo "WARN: Retrying with max depth $depth"
				if git submodule update --init --recursive --depth=$depth; then
					break
				fi
				if [[ "$depth" -gt "$maxdepth" ]]; then
					termux_error_exit "Failed to clone submodule"
				fi
				depth=$((depth+10))
				sleep 1
			done
		fi

		popd

		echo "$TERMUX_PKG_VERSION" > $TMP_CHECKOUT_VERSION
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $TMP_CHECKOUT $TERMUX_PKG_SRCDIR
}
