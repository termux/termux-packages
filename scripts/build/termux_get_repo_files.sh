termux_get_repo_files() {
	# Not needed for on-device builds or when building
	# dependencies.
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] || [ "$TERMUX_INSTALL_DEPS" = "false" ]; then
		return
	fi

	for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
		local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-Release
		local repo_base="${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
		local dl_prefix="${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}"

		local download_attempts=6
		while ((download_attempts > 0)); do
			if termux_download "${repo_base}/Release" \
				"$RELEASE_FILE" SKIP_CHECKSUM && \
				termux_download "${repo_base}/Release.gpg" \
				"${RELEASE_FILE}.gpg" SKIP_CHECKSUM; then

				if ! gpg --verify "${RELEASE_FILE}.gpg" "$RELEASE_FILE"; then
					termux_error_exit "failed to verify gpg signature of $RELEASE_FILE"
				fi

				local failed=false
				for arch in all $TERMUX_ARCH; do
					local PACKAGES_HASH=$(./scripts/get_hash_from_file.py ${RELEASE_FILE} $arch ${TERMUX_REPO_COMPONENT[$idx-1]})

					# If packages_hash = "" then the repo probably doesn't contain debs for $arch
					if [ -n "$PACKAGES_HASH" ]; then
						if ! termux_download "${repo_base}/${TERMUX_REPO_COMPONENT[$idx-1]}/binary-$arch/Packages" \
							"${TERMUX_COMMON_CACHEDIR}-$arch/${dl_prefix}-Packages" \
							$PACKAGES_HASH; then
							failed=true
							break
						fi
					fi
				done

				if ! $failed; then
					break
				fi
			fi

			download_attempts=$((download_attempts - 1))
			if ((download_attempts < 1)); then
				termux_error_exit "Failed to download package repository metadata. Try to build without -i/-I option."
			fi

			echo "Retrying download in 30 seconds (${download_attempts} attempts left)..." >&2
			sleep 30
		done

	done
}
