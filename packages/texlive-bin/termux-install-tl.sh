
TL_VERSION=2017
TL_ROOT=$PREFIX/opt/texlive

export TMPDIR=$PREFIX/tmp/ 
mkdir -p $TMPDIR/termux-tl-installer
cd $TMPDIR/termux-tl-installer

wget ftp://ftp.tug.org/texlive/historic/$TL_VERSION/install-tl-unx.tar.gz -O install-tl-unx.tar.gz
tar xzfv install-tl-unx.tar.gz > flist

cd $(head -1 flist) 

#patch install-tl
sed -E -i "s@\`/bin/sh@\`$PREFIX/bin/sh@g" tlpkg/TeXLive/TLUtils.pm 

cat > texlive_inst.profile << XXHEREXX
selected_scheme scheme-basic
TEXDIR $TL_ROOT/$TL_VERSION
TEXMFCONFIG ~/.texlive$TL_VERSION/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL $TL_ROOT/texmf-local
TEXMFSYSCONFIG $TL_ROOT/$TL_VERSION/texmf-config
TEXMFSYSVAR $TL_ROOT/$TL_VERSION/texmf-var
TEXMFVAR ~/.texlive$TL_VERSION/texmf-var
collection-basic 1
collection-latex 1
collection-luatex 1
instopt_adjustpath 0
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 0
tlpdbopt_file_assocs 0
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin $PREFIX/bin
tlpdbopt_sys_info $PREFIX/share/info
tlpdbopt_sys_man $PREFIX/share/man
tlpdbopt_w32_multi_user 0
XXHEREXX

#start installer with a profile and premade binaries
perl ./install-tl --custom-bin=$TL_ROOT/${TL_VERSION}/bin/pkg --profile texlive_inst.profile 

#fix tlpkg
sed -E -i "s@\`/bin/sh@\`$PREFIX/bin/sh@g" ${TL_ROOT}/${TL_VERSION}/tlpkg/TeXLive/TLUtils.pm

#fix shebangs
sed -i -E "1 s@^#\!(.*)/[sx]?bin/(.*)@#\!$PREFIX/bin/\2@" ${TL_ROOT}/${TL_VERSION}/texmf-dist/web2c/*
sed -i -E "1 s@^#\!(.*)/[sx]?bin/(.*)@#\!$PREFIX/bin/\2@" ${TL_ROOT}/${TL_VERSION}/bin/custom/*

#source the environment
. $PREFIX/etc/profile.d/texlive.sh 

#setup links
texlinks

rm -rf $TMPDIR/termux-tl-installer
