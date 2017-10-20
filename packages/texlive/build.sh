TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=20170524
_MINOR_VERSION=
TERMUX_PKG_VERSION=${_MAJOR_VERSION}${_MINOR_VERSION}
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=("ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/"\
{"texlive-$_MAJOR_VERSION-texmf.tar.xz",\
"texlive-$_MAJOR_VERSION-extra.tar.xz",\
"install-tl-unx.tar.gz"})
TERMUX_PKG_SHA256=("3f63708b77f8615ec6f2f7c93259c5f584d1b89dd335a28f2362aef9e6f0c9ec"
"afe49758c26fb51c2fae2e958d3f0c447b5cc22342ba4a4278119d39f5176d7f"
"d4e07ed15dace1ea7fabe6d225ca45ba51f1cb7783e17850bc9fe3b890239d6d")
TERMUX_PKG_DEPENDS="wget, perl, xz-utils, gnupg2, texlive-bin (>= 20170524)"
TERMUX_PKG_FOLDERNAME=("texlive-$_MAJOR_VERSION-texmf"
"texlive-$_MAJOR_VERSION-extra"
"install-tl-$_MAJOR_VERSION")
TL_FILE_LISTS=("texlive-texmf.list"
"texlive-extra.list"
"install-tl.list")
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

TL_ROOT=$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}
TL_BINDIR=$TL_ROOT/bin/custom

termux_step_extract_package() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	
	cd "$TERMUX_PKG_TMPDIR"
	for index in $(seq 0 2); do
		local filename
		filename=$(basename "${TERMUX_PKG_SRCURL[$index]}")
		local file="$TERMUX_PKG_CACHEDIR/$filename"
		termux_download "${TERMUX_PKG_SRCURL[$index]}" "$file" "${TERMUX_PKG_SHA256[$index]}"
		
		folder=${TERMUX_PKG_FOLDERNAME[$index]}
		
		rm -Rf $folder
		echo "Extracting files listed in ${TL_FILE_LISTS[$index]} from $folder"
		tar xf "$file" $(paste -d'\0' <(for i in $(seq 1 $( wc -l < $TERMUX_PKG_BUILDER_DIR/${TL_FILE_LISTS[$index]} )); do echo ${TERMUX_PKG_FOLDERNAME[$index]}/; done ) $TERMUX_PKG_BUILDER_DIR/${TL_FILE_LISTS[$index]} )
	done
	cp -r ${TERMUX_PKG_FOLDERNAME[@]} "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	for index in $( seq 0 2 ); do
		cp -r $TERMUX_PKG_SRCDIR/${TERMUX_PKG_FOLDERNAME[$index]}/* $TL_ROOT/
	done

	mkdir -p $TL_ROOT/{tlpkg/{backups,tlpobj},texmf-var/web2c}
	cp $TERMUX_PKG_BUILDER_DIR/texlive.tlpdb $TL_ROOT/tlpkg/

	perl -I$TL_ROOT/tlpkg/ $TL_ROOT/texmf-dist/scripts/texlive/mktexlsr.pl $TL_ROOT/texmf-dist
}

termux_step_create_debscripts () {
	# Clean texlive's folder if needed (run on upgrade)
	echo "#!$TERMUX_PREFIX/bin/bash" > preinst
	echo "if [ ! -f $TERMUX_PREFIX/opt/texlive/2016/install-tl -a ! -f $TERMUX_PREFIX/opt/texlive/2017/install-tl ]; then exit 0; else echo 'Removing residual files from old version of TeX Live for Termux'; fi" >> preinst
	echo "rm -rf $TERMUX_PREFIX/etc/profile.d/texlive.sh" >> preinst
	echo "rm -rf $TERMUX_PREFIX/opt/texlive/2016" >> preinst
	# Let's not delete the previous texmf-dist so that people who have installed a full distribution won't need to download everything again
	echo "shopt -s extglob" >> preinst # !(texmf-dist) is an extended glob which is turned off in scripts
	echo "rm -rf $TERMUX_PREFIX/opt/texlive/2017/!(texmf-dist)" >> preinst
	echo "shopt -u extglob" >> preinst # disable extglob again just in case
	echo "exit 0" >> preinst
	chmod 0755 preinst
	
	echo "#!$TERMUX_PREFIX/bin/bash" > postinst
	echo "mkdir -p $TL_ROOT/{tlpkg/{backups,tlpobj},texmf-var/{web2c,tex/generic/config}}" >> postinst
	echo "export PATH=\$PATH:$TL_BINDIR" >> postinst
	echo "export TMPDIR=$TERMUX_PREFIX/tmp" >> postinst
	echo "echo Updating tlmgr" >> postinst
	echo "tlmgr update --self" >> postinst
	echo "echo Generating language files and setting up symlinks" >> postinst
	echo "tlmgr -q generate language" >> postinst
	echo "mktexlsr $TL_ROOT/texmf-var" >> postinst
	echo "texlinks" >> postinst
	echo "echo ''" >> postinst
	echo "echo Welcome to TeX Live!" >> postinst
	echo "echo ''" >> postinst
	echo "echo 'TeX Live is a joint project of the TeX user groups around the world;'" >> postinst
	echo "echo 'please consider supporting it by joining the group best for you.'" >> postinst
	echo "echo 'The list of groups is available on the web at http://tug.org/usergroups.html.'" >> postinst
	echo "echo ''" >> postinst
	echo "echo 'Please run \"source $PREFIX/etc/profile.d/texlive.sh\" to add texlive'\''s binaries to your current shell'\''s PATH.'" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst

	# Remove all files installed through tlmgr on removal
	echo "#!$TERMUX_PREFIX/bin/bash" > prerm
	echo 'if [ $1 != "remove" ]; then exit 0; fi' >> prerm
	echo "echo Running texlinks --unlink" >> prerm
	echo "texlinks --unlink" >> prerm
	echo "echo Removing texmf-dist" >> prerm
	echo "rm -rf $TL_ROOT/texmf-dist" >> prerm
	echo "echo Removing texmf-var and tlpkg" >> prerm
	echo "rm -rf $TL_ROOT/{texmf-var,tlpkg/{texlive.tlpdb.*,tlpobj,backups}}" >> prerm
	echo "exit 0" >> prerm
	chmod 0755 prerm
}
