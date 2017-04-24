
TL_VERSION=2016
TL_ROOT=$PREFIX/opt/texlive

export TMPDIR=$PREFIX/tmp/ 
mkdir -p $TMPDIR/termux-tl-installer
cd $TMPDIR/termux-tl-installer

wget http://mirror.ctan.org/systems/texlive/Source/install-tl-unx.tar.gz -O install-tl-unx.tar.gz
tar xzfv install-tl-unx.tar.gz > flist

cd $(head -1 flist) 

#patch install-tl
sed -E -i "s@/bin/sh@$PREFIX/bin/sh@" tlpkg/TeXLive/TLUtils.pm 

cat > texlive_inst.profile << XXHEREXX

selected_scheme scheme-custom
TEXDIR ${TL_ROOT}/${TL_VERSION}
TEXMFCONFIG ~/.texlive${TL_VERSION}/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL ${TL_ROOT}/texmf-local
TEXMFSYSCONFIG ${TL_ROOT}/${TL_VERSION}/texmf-config
TEXMFSYSVAR ${TL_ROOT}/${TL_VERSION}/texmf-var
TEXMFVAR ~/.texlive${TL_VERSION}/texmf-var
collection-basic 1
collection-latex 1
collection-luatex 1
in_place 0
option_adjustrepo 1
option_autobackup 1
option_backupdir tlpkg/backups
option_desktop_integration 0
option_doc 0
option_file_assocs 0
option_fmt 1
option_letter 0
option_menu_integration 1
option_path 0
option_post_code 1
option_src 0
option_sys_bin $PREFIX/bin
option_sys_info $PREFIX/local/share/info
option_sys_man $PREFIX/local/share/man
option_w32_multi_user 0
option_write18_restricted 1
portable 0

XXHEREXX

#start installer with a profile and premade binaries
perl ./install-tl --custom-bin=$TL_ROOT/${TL_VERSION}/bin/pkg --profile texlive_inst.profile 

mkdir -p $PREFIX/etc/profile.d/

cat > $PREFIX/etc/profile.d/texlive.sh << XXHEREXX
export PATH=\$PATH:$TL_ROOT/${TL_VERSION}/bin/custom
export TMPDIR=$PREFIX/tmp/
XXHEREXX

#fix tlpkg
sed -E -i "s@/bin/sh@$PREFIX/bin/sh@" ${TL_ROOT}/${TL_VERSION}/tlpkg/TeXLive/TLUtils.pm

#fix shebangs
sed -i -E "1 s@^#\!(.*)/[sx]?bin/(.*)@#\!$PREFIX/bin/\2@" ${TL_ROOT}/${TL_VERSION}/texmf-dist/web2c/*
sed -i -E "1 s@^#\!(.*)/[sx]?bin/(.*)@#\!$PREFIX/bin/\2@" ${TL_ROOT}/${TL_VERSION}/bin/custom/*

#source the environment
. $PREFIX/etc/profile.d/texlive.sh 

#setup links
texlinks

rm -rf $TMPDIR/termux-tl-installer
