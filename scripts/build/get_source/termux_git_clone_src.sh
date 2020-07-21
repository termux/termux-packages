termux_git_clone_src() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_TMPDIR/checkout-$TERMUX_PKG_VERSION
	local TMP_CHECKOUT=$TERMUX_PKG_CACHEDIR/tmp-checkout

	# If user aborts git clone step here the folder needs to be removed
	# manually. IMO this is better than git cloning the src everytime
	if [ ! -d $CHECKED_OUT_FOLDER ] && [ ! -d $TMP_CHECKOUT ]; then
		if [ "$TERMUX_PKG_GIT_BRANCH" == "" ]; then
			TERMUX_PKG_GIT_BRANCH=v$TERMUX_PKG_VERSION
		fi
		git clone --depth 1 \
			--branch $TERMUX_PKG_GIT_BRANCH \
			$TERMUX_PKG_SRCURL \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT

		git submodule update --init --recursive
		cd ..
	fi

	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		cp -Rf $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER $TERMUX_PKG_SRCDIR
}
