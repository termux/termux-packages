TERMUX_SUBPKG_DESCRIPTION="Texlive-full, meta package that depends on all texlive-collections"
TERMUX_SUBPKG_CONFLICTS="texlive-tlmgr"
TERMUX_SUBPKG_DEPENDS="texlive-bibtexextra, texlive-binextra, texlive-context, texlive-fontsextra, texlive-fontsrecommended, texlive-fontutils, texlive-formatsextra, texlive-games, texlive-humanities, texlive-langarabic, texlive-langchinese, texlive-langcjk, texlive-langcyrillic, texlive-langczechslovak, texlive-langenglish, texlive-langeuropean, texlive-langfrench, texlive-langgerman, texlive-langgreek, texlive-langitalian, texlive-langjapanese, texlive-langkorean, texlive-langother, texlive-langpolish, texlive-langportuguese, texlive-langspanish, texlive-latexextra, texlive-latexrecommended, texlive-luatex, texlive-mathscience, texlive-metapost, texlive-music, texlive-pictures, texlive-plaingeneric, texlive-pstricks, texlive-publishers, texlive-xetex"
TERMUX_SUBPKG_INCLUDE="share/texlive/tlpkg/texlive.tlpdb"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo 'PATH=$PATH:$PREFIX/bin/texlive mktexlsr' >> postinst
	echo "echo 'Now source \$PREFIX/etc/profile.d/texlive.sh or open a new shell to add the'" >> postinst
	echo "echo 'texlive binaries to \$PATH'" >> postinst

}
