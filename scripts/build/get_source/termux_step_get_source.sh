termux_step_get_source() {
	if [ "${TERMUX_PKG_SRCURL: -4}" == ".git" ]; then
		termux_git_clone_src
	else
		mkdir -p $TERMUX_PKG_SRCDIR            
		termux_download_src_archive
		cd $TERMUX_PKG_TMPDIR
		termux_extract_src_archive
	fi
}
