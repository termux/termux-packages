termux_git_clone_src() {
	local TMP_CHECKOUT=$TERMUX_PKG_CACHEDIR/tmp-checkout
	local TMP_CHECKOUT_VERSION=$TERMUX_PKG_CACHEDIR/tmp-checkout-version
	local termux_pkg_srcurl="${TERMUX_PKG_SRCURL:4}"
	local termux_pkg_local_srcpath=""
	local termux_pkg_branch_flags=""

	if [[ "$termux_pkg_srcurl" =~ ^file://(/[^/]+)+$ ]]; then
		termux_pkg_local_srcpath="${termux_pkg_srcurl:7}" # Remove `file://` prefix

		if [ ! -d "$termux_pkg_local_srcpath" ]; then
			echo "No source directory found at path of TERMUX_PKG_SRCURL '$TERMUX_PKG_SRCURL' of package '$TERMUX_PKG_NAME'"
			return 1
		elif [ ! -d "$termux_pkg_local_srcpath/.git" ]; then
			echo "The source directory at path of TERMUX_PKG_SRCURL '$TERMUX_PKG_SRCURL' of package '$TERMUX_PKG_NAME' does not a contain a '.git' sub directory"
			return 1
		fi
	fi

	if [ ! -f $TMP_CHECKOUT_VERSION ] || [ "$(cat $TMP_CHECKOUT_VERSION)" != "$TERMUX_PKG_VERSION" ]; then
		if [[ -n "$termux_pkg_local_srcpath" ]]; then
			if [ "$TERMUX_PKG_GIT_BRANCH" != "" ]; then
				# The local git repository that needs to be cloned may
				# not have a branch created that is tracking its remote
				# branch, so we create it if it doesn't exist without
				# checking it out, otherwise when we clone below,
				# git will fail to find the branch in its own origin
				# i.e the local git repository, as it will not look
				# into the origin of the local git repository recursively.
				(cd "$termux_pkg_local_srcpath" && git fetch origin $TERMUX_PKG_GIT_BRANCH:$TERMUX_PKG_GIT_BRANCH)
				termux_pkg_branch_flags="--branch $TERMUX_PKG_GIT_BRANCH"
			fi
		else
			if [ "$TERMUX_PKG_GIT_BRANCH" == "" ]; then
				termux_pkg_branch_flags="--branch v${TERMUX_PKG_VERSION#*:}"
			else
				termux_pkg_branch_flags="--branch $TERMUX_PKG_GIT_BRANCH"
			fi
		fi

		echo "Downloading git source $([[ "$termux_pkg_branch_flags" != "" ]] && echo "with branch '${termux_pkg_branch_flags:9}' ")from '$termux_pkg_srcurl'"
		rm -rf "$TMP_CHECKOUT"

		local git_archive="$(basename ${termux_pkg_srcurl})_${TERMUX_PKG_GIT_BRANCH:-v${TERMUX_PKG_VERSION#*:}}.tar.xz"
		if termux_download_source_mirror "${TERMUX_PKG_NAME}" \
				"${TERMUX_PKG_GIT_BRANCH:-v${TERMUX_PKG_VERSION#*:}}.tar.xz" \
				"$TERMUX_PKG_CACHEDIR/$git_archive"; then
			mkdir -p "$TMP_CHECKOUT"
			tar -x --xz -C "$TMP_CHECKOUT" -f "$TERMUX_PKG_CACHEDIR/$git_archive" || return 1
		else
			git clone \
				--depth 1 \
				$termux_pkg_branch_flags \
				"$termux_pkg_srcurl" \
				"$TMP_CHECKOUT"

			pushd "$TMP_CHECKOUT"

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

			if [ "$TERMUX_COPY_TO_SOURCE_MIRROR" = "true" ]; then
				if [ "${TERMUX_PKG_NAME}" = "aapt" ]; then
					echo "aapt git archive is bigger than 2 gigabytes and cannot be uploaded to Github source mirror"
				else
					mkdir -p "$TERMUX_OUTPUT_DIR/source"
					tar -c -C "$TMP_CHECKOUT" . | xz -T0 > "${TERMUX_OUTPUT_DIR}/source/$git_archive" || exit 1
				fi
			fi
		fi
		echo "$TERMUX_PKG_VERSION" > "$TMP_CHECKOUT_VERSION"
	else
		echo "Skipped downloading of git source from '$termux_pkg_srcurl'"
	fi

	rm -rf "$TERMUX_PKG_SRCDIR"
	cp -Rf "$TMP_CHECKOUT" "$TERMUX_PKG_SRCDIR"
}
