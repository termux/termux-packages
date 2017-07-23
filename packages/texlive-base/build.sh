TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=20170524
_MINOR_VERSION=
TERMUX_PKG_VERSION=${_MAJOR_VERSION}${_MINOR_VERSION}
TERMUX_PKG_SRCURL=("ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-$_MAJOR_VERSION-texmf.tar.xz" 
"ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-$_MAJOR_VERSION-extra.tar.xz"
"ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/install-tl-unx.tar.gz"
)
TERMUX_PKG_SHA256=("3f63708b77f8615ec6f2f7c93259c5f584d1b89dd335a28f2362aef9e6f0c9ec"
"afe49758c26fb51c2fae2e958d3f0c447b5cc22342ba4a4278119d39f5176d7f"
"d4e07ed15dace1ea7fabe6d225ca45ba51f1cb7783e17850bc9fe3b890239d6d"
)
TERMUX_PKG_DEPENDS="wget, perl, xz-utils, gnupg2, texlive-bin"
TERMUX_PKG_FOLDERNAME=("texlive-$_MAJOR_VERSION-texmf" 
"texlive-$_MAJOR_VERSION-extra"
"install-tl-$_MAJOR_VERSION" 
)
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

TL_ROOT=$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}
TL_BINDIR=$TL_ROOT/bin/custom

termux_step_extract_package() {
	if [ -z "${TERMUX_PKG_SRCURL:=""}" ]; then
		mkdir -p "$TERMUX_PKG_SRCDIR"
		return
	fi
	########
	# TEXMF:
	########
	cd "$TERMUX_PKG_TMPDIR"
	local filename
	filename=$(basename "${TERMUX_PKG_SRCURL[0]}")
	local file="$TERMUX_PKG_CACHEDIR/$filename"
	termux_download "${TERMUX_PKG_SRCURL[0]}" "$file" "${TERMUX_PKG_SHA256[0]}"
	
	folder=${TERMUX_PKG_FOLDERNAME[0]}

	rm -Rf $folder
	echo "Extracting texmf-dist tar:"
	tar xf "$file" --checkpoint=.50000 $(paste -d'\0' <(for i in $(seq 1 $( wc -l < $TERMUX_PKG_BUILDER_DIR/texmf.list )); do echo texlive-$_MAJOR_VERSION-texmf/; done ) $TERMUX_PKG_BUILDER_DIR/texmf.list )
	echo ""
	cp -r $folder "$TERMUX_PKG_SRCDIR"

	########
	# EXTRA:
	########
	cd "$TERMUX_PKG_TMPDIR"
	local filename
	filename=$(basename "${TERMUX_PKG_SRCURL[1]}")
	local file="$TERMUX_PKG_CACHEDIR/$filename"
	termux_download "${TERMUX_PKG_SRCURL[1]}" "$file" "${TERMUX_PKG_SHA256[1]}"
	
	folder=${TERMUX_PKG_FOLDERNAME[1]}

	rm -Rf $folder
	tar xf "$file" $(paste -d'\0' <(for i in $(seq 1 $( wc -l < $TERMUX_PKG_BUILDER_DIR/extra.list )); do echo texlive-$_MAJOR_VERSION-extra/; done ) $TERMUX_PKG_BUILDER_DIR/extra.list )
	cp -r $folder "$TERMUX_PKG_SRCDIR"

	#############
	# INSTALL-TL:
	#############
	local filename
	filename=$(basename "${TERMUX_PKG_SRCURL[2]}")
	local file="$TERMUX_PKG_CACHEDIR/$filename"
	termux_download "${TERMUX_PKG_SRCURL[2]}" "$file" "${TERMUX_PKG_SHA256[2]}"
	
	folder=${TERMUX_PKG_FOLDERNAME[2]}

	rm -Rf $folder
	tar xf "$file" --wildcards install-tl-${_MAJOR_VERSION}/tlpkg/{installer/config.guess,gpg/*}
	cp -r $folder "$TERMUX_PKG_SRCDIR"
}

termux_step_configure () {
	return 0
}

termux_step_make() {	
	cp -r $TERMUX_PKG_SRCDIR/texmf-dist $TL_ROOT/
	cp -r $TERMUX_PKG_SRCDIR/texlive-$_MAJOR_VERSION-extra/* $TL_ROOT/
	cp -r $TERMUX_PKG_SRCDIR/install-tl-$_MAJOR_VERSION/* $TL_ROOT/

	mkdir -p $TL_ROOT/{tlpkg/{backups,tlpobj},texmf-var/web2c}
	cp $TERMUX_PKG_BUILDER_DIR/texlive.tlpdb $TL_ROOT/tlpkg/

	perl -I$TL_ROOT/tlpkg/ $TL_ROOT/texmf-dist/scripts/texlive/mktexlsr.pl $TL_ROOT/texmf-dist

	return 0
}

termux_step_post_make_install () {
	return 0
}

termux_step_create_debscripts () {
	echo "mkdir -p $TL_ROOT/{tlpkg/{backups,tlpobj},texmf-var/{web2c,tex/generic/config}}" > postinst
	echo "echo Updating tlmgr" >> postinst
	echo "$TL_BINDIR/tlmgr update --self" >> postinst
	echo "echo Generating formats and setting up links" >> postinst
	echo "$TL_BINDIR/tlmgr generate language" >> postinst
	echo "$TL_BINDIR/mktexlsr $TL_ROOT/texmf-var" >> postinst
	echo "$TL_BINDIR/fmtutil-sys --byhyphen $TL_ROOT/texmf-var/tex/generic/config/language.dat" >> postinst
	echo "$TL_BINDIR/texlinks" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst

	# Remove all files installed through tlmgr on removal
	echo 'if [ $1 != "remove" ]; then exit 0; fi' > prerm
	#echo "tlmgr remove --dry-run "
	echo "echo Running texlinks --unlink" >> prerm
	echo "texlinks --unlink" >> prerm
	echo "echo Removing texmf-dist" >> prerm
	echo "rm -rf $TL_ROOT/texmf-dist" >> prerm
	echo "echo Removing texmf-var and tlpkg" >> prerm
	echo "rm -rf $TL_ROOT/{texmf-var,tlpkg/{texlive.tlpdb.*,tlpobj,backups}}" >> prerm
	echo "exit 0" >> prerm
	chmod 0755 prerm
}
