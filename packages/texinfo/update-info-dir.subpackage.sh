TERMUX_SUBPKG_DESCRIPTION="Update or create index file from all installed info files in directory"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_INCLUDE="
bin/update-info-dir
share/man/man8/update-info-dir.8.gz
"

termux_step_create_subpkg_debscripts() {
	local INFODIR=$TERMUX_PREFIX/share/info

	cat <<- EOF > ./triggers
	interest-noawait $INFODIR
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ -d $INFODIR ]; then
	$TERMUX_PREFIX/bin/update-info-dir
	fi
	exit
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -rf $INFODIR/dir
	exit
	EOF
}
