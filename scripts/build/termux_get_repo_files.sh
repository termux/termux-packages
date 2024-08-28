termux_get_repo_files() {
	# Not needed for on-device builds or when building
	# dependencies.
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] || [ "$TERMUX_INSTALL_DEPS" = "false" ]; then
		return
	fi

	local i
	local TERMUX_REPO_DIR
	local TERMUX_REPO_URL
	local TERMUX_REPO_URL_ID
	for i in "${!TERMUX_REPO__CHANNEL_URLS[@]}"; do
		TERMUX_REPO_DIR="${TERMUX_REPO__CHANNEL_DIRS["$i"]}"
		TERMUX_REPO_URL="${TERMUX_REPO__CHANNEL_URLS["$i"]}"
		if [ -z "$TERMUX_REPO_URL" ]; then
			echo "Ignoring to download '${TERMUX_REPO__CHANNEL_NAMES["$i"]}' repo files as its url is not set"
			continue
		fi

		if [ -z "${TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS["$TERMUX_REPO_DIR"]:-}" ]; then
			termux_error_exit "The signing key names and fingerprints not set for the '$TERMUX_REPO_DIR' repo channel directory"
		fi

		TERMUX_REPO_URL_ID=$(echo "$TERMUX_REPO_URL" | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		if [ "$TERMUX_REPO__PKG_FORMAT" = "debian" ]; then
			local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_URL_ID}-${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}-Release
			local repo_base="${TERMUX_REPO__CHANNEL_URLS["$i"]}/dists/${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}"
			local dl_prefix="${TERMUX_REPO_URL_ID}-${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}-${TERMUX_REPO__CHANNEL_COMPONENTS["$i"]}"
		elif [ "$TERMUX_REPO__PKG_FORMAT" = "pacman" ]; then
			local JSON_FILE="${TERMUX_COMMON_CACHEDIR}-${TERMUX_ARCH}/${TERMUX_REPO_URL_ID}-json"
			local repo_base="${TERMUX_REPO__CHANNEL_URLS["$i"]}/${TERMUX_ARCH}"
		fi

		local download_attempts=6
		while ((download_attempts > 0)); do
			if [ "$TERMUX_REPO__PKG_FORMAT" = "debian" ]; then
				if termux_download "${repo_base}/Release" "$RELEASE_FILE" SKIP_CHECKSUM && \
						termux_download "${repo_base}/Release.gpg" "${RELEASE_FILE}.gpg" SKIP_CHECKSUM; then
					termux_repository__verify_repo_gpg_signing_key "'${TERMUX_REPO__CHANNEL_NAMES["$i"]}' repo" \
						"${TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS["$TERMUX_REPO_DIR"]}" "${RELEASE_FILE}.gpg" "$RELEASE_FILE"

					local failed=false
					for arch in all $TERMUX_ARCH; do
						local PACKAGES_HASH=$(./scripts/get_hash_from_file.py ${RELEASE_FILE} $arch ${TERMUX_REPO__CHANNEL_COMPONENTS["$i"]})

						# If packages_hash = "" then the repo probably doesn't contain debs for $arch
						if [ -n "$PACKAGES_HASH" ]; then
							if ! termux_download "${repo_base}/${TERMUX_REPO__CHANNEL_COMPONENTS["$i"]}/binary-$arch/Packages" \
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
			elif [ "$TERMUX_REPO__PKG_FORMAT" = "pacman" ]; then
				if termux_download "${repo_base}/${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}.json" "$JSON_FILE" SKIP_CHECKSUM && \
						termux_download "${repo_base}/${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}.json.sig" "${JSON_FILE}.sig" SKIP_CHECKSUM; then
					termux_repository__verify_repo_gpg_signing_key "'${TERMUX_REPO__CHANNEL_NAMES["$i"]}' repo" \
						"${TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS["$TERMUX_REPO_DIR"]}" "${JSON_FILE}.sig" "$JSON_FILE"

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
