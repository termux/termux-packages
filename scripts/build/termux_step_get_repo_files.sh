termux_step_get_repo_files() {
	# Ensure folders present (but not $TERMUX_PKG_SRCDIR, it will be created in build)
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH" \
		 "$TERMUX_COMMON_CACHEDIR-all" \
		 "$TERMUX_DEBDIR" \
		 "$TERMUX_PKG_BUILDDIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR" \
		 $TERMUX_PREFIX/{bin,etc,lib,libexec,share,tmp,include}
	if [ "$TERMUX_INSTALL_DEPS" = true ]; then
		if [ "$TERMUX_NO_CLEAN" = false ]; then
			# Remove all previously extracted/built files from $TERMUX_PREFIX:
			rm -rf $TERMUX_PREFIX
			rm -f /data/data/.built-packages/*
			# Setup bootstrap
			if [ $TERMUX_ARCH == aarch64 ]; then
				local bootstrap_sha256=2944ad699814329007d1f9c056e7c8323243c8b4a257cbd05904216f89fc3746
			elif [ $TERMUX_ARCH == i686 ]; then
				local bootstrap_sha256=8f4dee0b1e161689b60f330ac0cc813b56ab479f2cd789eb8459165a3be13bdb
			elif [ $TERMUX_ARCH == arm ]; then
				local bootstrap_sha256=f471c0af326677d87ca4926d54860d10d751dd4f8d615d5b1de902841601b41e
			elif [ $TERMUX_ARCH == x86_64 ]; then
				local bootstrap_sha256=93384f0343c13f604dbacd069276291bd7042fc6d42c6d7514c7e573d968c614
			fi
			termux_download https://termux.net/bootstrap/bootstrap-${TERMUX_ARCH}.zip \
					${TERMUX_COMMON_CACHEDIR}/bootstrap-${TERMUX_ARCH}.zip \
					$bootstrap_sha256
			unzip -qo ${TERMUX_COMMON_CACHEDIR}/bootstrap-${TERMUX_ARCH}.zip -d $TERMUX_PREFIX
			(
				cd $TERMUX_PREFIX
				while read link; do
					ln -sf ${link/←/ }
				done<SYMLINKS.txt
				rm SYMLINKS.txt
			)
		fi
		# Import signing keys from files
		gpg --import ${TERMUX_REPO_SIGNING_KEYS}

		for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
			local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
			curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/InRelease" \
			    -o ${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-InRelease \
			    || curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/Release.gpg" \
				    -o ${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-Release.gpg \
			    && curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/Release" \
				    -o ${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-Release \
			    || termux_error_exit "Download of InRelease and Release.gpg from ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]} failed"

			if [ -f ${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-InRelease ]; then
				local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-InRelease
				gpg --verify $RELEASE_FILE
			else
				local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-Release
				gpg --verify ${RELEASE_FILE}.gpg $RELEASE_FILE
			fi

			for arch in all $TERMUX_ARCH; do
				local packages_hash=$(./scripts/get_hash_from_file.py ${RELEASE_FILE} $arch ${TERMUX_REPO_COMPONENT[$idx-1]})
				# If packages_hash = "" then the repo probably doesn't contain debs for $arch
				if ! [ "$packages_hash" = "" ]; then
					termux_download "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/${TERMUX_REPO_COMPONENT[$idx-1]}/binary-$arch/Packages" \
							"${TERMUX_COMMON_CACHEDIR}-$arch/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}-Packages" \
							$packages_hash
				fi
			done
		done
	fi
}
