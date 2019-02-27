termux_step_compare_debs() {
	if [ "${TERMUX_INSTALL_DEPS}" = true ]; then
		cd ${TERMUX_SCRIPTDIR}

		for DEB in $TERMUX_PKG_NAME $(basename $TERMUX_PKG_BUILDER_DIR/*.subpackage.sh | sed 's%\.subpackage\.sh%%g') $(basename $TERMUX_PKG_TMPDIR/*.subpackage.sh | sed 's%\.subpackage\.sh%%g'); do
			read DEB_ARCH DEB_VERSION <<< $(termux_extract_dep_info "$DEB")
			termux_download_deb $DEB $DEB_ARCH $DEB_VERSION \
			    &&	(
				DEB_FILE=${DEB}_${DEB_VERSION}_${DEB_ARCH}.deb

				# `|| true` to prevent debdiff's exit code from stopping build
				debdiff $TERMUX_DEBDIR/$DEB_FILE $TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH/$DEB_FILE || true
				) || echo "Download of ${DEB}@${DEB_VERSION} failed, not comparing debs"
			echo ""
		done
	fi
}
