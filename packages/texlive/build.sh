TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20190410
TERMUX_PKG_SRCURL=ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-texmf.tar.xz
TERMUX_PKG_SHA256=c2ec974abc98b91995969e7871a0b56dbc80dd8508113ffcff6923e912c4c402
TERMUX_PKG_DEPENDS="perl, texlive-bin (>= 20190410)"
TERMUX_PKG_CONFLICTS="texlive (<< 20170524-5), texlive-bin (<< 20190410), texlive-tlmgr (<< 20190410)"
TERMUX_PKG_REPLACES="texlive-bin (<< 20190410), texlive-tlmgr (<< 20190410)"
TERMUX_PKG_RECOMMENDS="texlive-tlmgr"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_HAS_DEBUG=no
TERMUX_PKG_BUILD_IN_SRC=yes

TL_ROOT=$TERMUX_PREFIX/share/texlive
TL_BINDIR=$TERMUX_PREFIX/bin

termux_step_post_extract_package() {
	cd $TERMUX_PKG_CACHEDIR
	termux_download ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/install-tl-unx.tar.gz \
			install-tl-unx.tar.gz \
			44aa41b5783e345b7021387f19ac9637ff1ce5406a59754230c666642dfe7750
	tar -xf install-tl-unx.tar.gz
	mv install-tl-*/install-tl \
	   install-tl-*/LICENSE.CTAN \
	   install-tl-*/LICENSE.TL \
	   install-tl-*/release-texlive.txt \
	   install-tl-*/tlpkg \
	   $TERMUX_PKG_SRCDIR/

	# Download texlive.tlpdb, parse to get file lists and include in texlive-full.
	termux_download ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-tlpdb-full.tar.gz \
			texlive-${TERMUX_PKG_VERSION}-tlpdb-full.tar.gz \
			4c93a5c7d28df63c6dd7f767822e5dacf9290a0dff4990663e283b6e2d8d1918

	tar xf texlive-${TERMUX_PKG_VERSION}-tlpdb-full.tar.gz
	mv texlive.tlpdb $TERMUX_PKG_TMPDIR
}

termux_step_make() {
	sed -i "s% RELOC/% texmf-dist/%g" $TERMUX_PKG_TMPDIR/texlive.tlpdb
	cp -r $TERMUX_PKG_BUILDDIR/* $TL_ROOT/
	perl -I$TL_ROOT/tlpkg/ $TL_ROOT/texmf-dist/scripts/texlive/mktexlsr.pl $TL_ROOT/texmf-dist
	mkdir -p $TL_ROOT/tlpkg
	cp $TERMUX_PKG_TMPDIR/texlive.tlpdb $TL_ROOT/tlpkg/
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/bash" > postinst
	echo "mktexlsr $TL_ROOT/texmf-var" >> postinst
	echo "texlinks" >> postinst
	echo "echo ''" >> postinst
	echo "echo Welcome to TeX Live!" >> postinst
	echo "echo ''" >> postinst
	echo "echo 'TeX Live is a joint project of the TeX user groups around the world;'" >> postinst
	echo "echo 'please consider supporting it by joining the group best for you.'" >> postinst
	echo "echo 'The list of groups is available on the web at http://tug.org/usergroups.html.'" >> postinst
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

TERMUX_PKG_RM_AFTER_INSTALL="
share/texlive/install-tl
share/texlive/texmf-dist/scripts/texlive/uninstall-win32.pl
share/texlive/texmf-dist/scripts/texlive/uninstq.vbs
share/texlive/texmf-dist/scripts/texlive/tlmgr.pl
share/texlive/texmf-dist/scripts/texlive/tlmgrgui.pl
share/texlive/tlpkg/gpg
share/texlive/tlpkg/installer
share/texlive/tlpkg/tltcl
share/texlive/tlpkg/translations
share/texlive/texmf-dist/doc
share/texlive/texmf-dist/source
"

# Here are all the files in collection-wintools: (single quotes due to share/texlive/tlpkg/dviout/UTILITY/dvi$pdf.bat)
TERMUX_PKG_RM_AFTER_INSTALL+='
share/texlive/tlpkg/dviout/GRAPHIC/PDL/pdldoc.tex
share/texlive/tlpkg/dviout/DOC/cmode1.png
share/texlive/texmf-dist/doc/support/wintools/pdfseparate.pdf
share/texlive/texmf-dist/doc/support/wintools/fc-query.pdf
share/texlive/texmf-dist/doc/support/tlaunch/figures/tlaunch_rug.png
share/texlive/tlpkg/dviout/GRAPHIC/TPIC/tpicdoc.tex
share/texlive/tlpkg/dviout/dviout.cnt
share/texlive/tlpkg/dviout/par/p4to1e.pgm
share/texlive/tlpkg/dviout/DOC/niko.bmp
share/texlive/tlpkg/dviout/GRAPHIC/COLOR/color.tex
share/texlive/bin/win32/luajitlatex.exe
share/texlive/tlpkg/dviout/DOC/dviouttipse.html
share/texlive/tlpkg/dviout/SAMPLE/slisamp2.tex
share/texlive/tlpkg/dviout/DOC/cmode2.png
share/texlive/tlpkg/dviout/DOC/seru.bmp
share/texlive/bin/win32/type1afm.exe
share/texlive/tlpkg/dviout/bmc.exe
share/texlive/tlpkg/dviout/GRAPHIC/PS/sample1.ps
share/texlive/tlpkg/dviout/par/HG-GyouSho.par
share/texlive/tlpkg/dviout/DOC/cmode.html
share/texlive/texmf-dist/doc/support/wintools/pdftoppm.pdf
share/texlive/texmf-dist/doc/support/wintools/fc-pattern.pdf
share/texlive/tlpkg/dviout/GRAPHIC/PS/starbrst.ps
share/texlive/texmf-dist/doc/support/wintools/pdfdetach.pdf
share/texlive/bin/win32/png22pnm.exe
share/texlive/tlpkg/dviout/GRAPHIC/PDL/lasersys.lp3
share/texlive/tlpkg/dviout/DOC/cmode6.png
share/texlive/tlpkg/dviout/CreateBB.exe
share/texlive/tlpkg/dviout/par/p4to1.pgm
share/texlive/texmf-dist/scripts/tlaunch/tlaunchmode.pl
share/texlive/texmf-dist/doc/support/tlaunch/figures/tlaunch_window.png
share/texlive/tlpkg/dviout/FONT/winttf.zip
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/dviout.dtx
share/texlive/tlpkg/dviout/GRAPHIC/PBM/pbmf.sty
share/texlive/texmf-dist/doc/support/wintools/zip.pdf
share/texlive/tlpkg/dviout/convedit.exe
share/texlive/tlpkg/dviout/par/TTfont.par
share/texlive/tlpkg/dviout/SAMPLE/slisamp4.tex
share/texlive/bin/win32/tiff2png.exe
share/texlive/tlpkg/dviout/DOC/lminus.bmp
share/texlive/bin/win32/pdftotext.exe
share/texlive/tlpkg/dviout/SPECIAL/demo.tex
share/texlive/tlpkg/dviout/SPECIAL/src.mac
share/texlive/tlpkg/dviout/par/dvipskdl.par
share/texlive/tlpkg/dviout/par/p12wait.pgm
share/texlive/bin/win32/tif22pnm.exe
share/texlive/tlpkg/dviout/par/Hidemaru.par
share/texlive/tlpkg/dviout/UTILITY/test_b5.tex
share/texlive/tlpkg/dviout/par/DF-GyouSho.par
share/texlive/bin/win32/gzip.exe
share/texlive/bin/win32/tomac.exe
share/texlive/texmf-dist/doc/support/wintools/pdftohtml.pdf
share/texlive/tlpkg/dviout/par/PKfont.par
share/texlive/tlpkg/dviout/GRAPHIC/PDL/file241b.p98
share/texlive/texmf-dist/doc/support/wintools/fc-cache.pdf
share/texlive/tlpkg/dviout/DOC/fpage.bmp
share/texlive/tlpkg/dviout/par/p4to1e0.pgm
share/texlive/texmf-dist/doc/support/wintools/fc-match.pdf
share/texlive/bin/win32/tlaunch.exe
share/texlive/tlpkg/dviout/DOC/dviouttips.html
share/texlive/tlpkg/dviout/UTILITY/test_b5e.tex
share/texlive/texmf-dist/doc/support/wintools/pdfimages.pdf
share/texlive/tlpkg/dviout/GRAPHIC/TPIC/linetest.tex
share/texlive/tlpkg/dviout/UTILITY/dvioute.vfn
share/texlive/tlpkg/dviout/DOC/dvioutQA.html
share/texlive/bin/win32/bitmap2eps.exe
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/dviout.ins
share/texlive/texmf-dist/doc/support/wintools/fc-scan.pdf
share/texlive/tlpkg/dviout/UTILITY/template
share/texlive/bin/win32/pdffonts.exe
share/texlive/tlpkg/dviout/par/p4n0.pgm
share/texlive/tlpkg/dviout/install.par
share/texlive/texmf-dist/scripts/bitmap2eps/bitmap2eps.vbs
share/texlive/texmf-dist/doc/support/wintools/pdftops.pdf
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/color.cfg
share/texlive/tlpkg/dviout/map/morisawa.map
share/texlive/tlpkg/dviout/GRAPHIC/PDL/spec.lp3
share/texlive/tlpkg/dviout/SAMPLE/slisampl.tex
share/texlive/bin/win32/bmeps.exe
share/texlive/tlpkg/dviout/DOC/tex_instchk.html
share/texlive/tlpkg/dviout/GRAPHIC/PS/gssub.exe
share/texlive/tlpkg/dviout/SPECIAL/srctex.cfg
share/texlive/texmf-dist/doc/support/wintools/pdftocairo.pdf
share/texlive/tlpkg/dviout/DOC/hyper.bmp
share/texlive/tlpkg/dviout/par/HG-KaiSho-PRO.par
share/texlive/tlpkg/dviout/DOC/present.html
share/texlive/tlpkg/dviout/GRAPHIC/PS/epsfdoc.tex
share/texlive/tlpkg/dviout/DOC/testtex.bat
share/texlive/tlpkg/dviout/par/p4to10.pgm
share/texlive/texmf-dist/web2c/tlaunch.ini
share/texlive/tlpkg/dviout/GRAPHIC/bmc/bmc.txt
share/texlive/tlpkg/dviout/SAMPLE/sample.txt
share/texlive/texmf-dist/doc/support/tlaunch/Changes
share/texlive/bin/win32/pdfseparate.exe
share/texlive/bin/win32/pdfimages.exe
share/texlive/tlpkg/dviout/readme.txt
share/texlive/bin/win32/pdfsig.exe
share/texlive/tlpkg/dviout/HYPERTEX/input9.tex
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/readme
share/texlive/tlpkg/dviout/DOC/mspmin.png
share/texlive/tlpkg/dviout/GRAPHIC/PDL/picbox.tex
share/texlive/tlpkg/dviout/history.txt
share/texlive/tlpkg/dviout/DOC/kappa.bmp
share/texlive/tlpkg/dviout/UTILITY/template.pks
share/texlive/tlpkg/dviout/SPECIAL/presen.sty
share/texlive/tlpkg/dviout/rawprt.exe
share/texlive/bin/win32/pdftops.exe
share/texlive/tlpkg/dviout/GRAPHIC/bmc/createbb.pdf
share/texlive/tlpkg/dviout/map/gtfonts.map
share/texlive/texmf-dist/doc/support/tlaunch/README
share/texlive/tlpkg/dviout/DOC/le.bmp
share/texlive/tlpkg/dviout/CFG/prtsrc.zip
share/texlive/tlpkg/dviout/00readme.txt
share/texlive/bin/win32/todos.exe
share/texlive/tlpkg/dviout/GRAPHIC/bmc/ifbmc.spi
share/texlive/tlpkg/dviout/UTILITY/test_org.tex
share/texlive/tlpkg/dviout/UTILITY/dviout1.vfn
share/texlive/tlpkg/dviout/map/mojikyo.map
share/texlive/bin/win32/aftopl.exe
share/texlive/bin/win32/png2bmp.exe
share/texlive/bin/win32/unzip.exe
share/texlive/tlpkg/dviout/dvispce.txt
share/texlive/tlpkg/dviout/par/WinShell.par
share/texlive/tlpkg/dviout/HYPERTEX/hyperdvi.tex
share/texlive/bin/win32/zip.exe
share/texlive/tlpkg/dviout/GRAPHIC/PDL/lips3.gpd
share/texlive/tlpkg/dviout/GRAPHIC/PS/pssample.tex
share/texlive/tlpkg/dviout/UTILITY/template.pk0
share/texlive/tlpkg/dviout/par/dvicut.par
share/texlive/tlpkg/dviout/par/dvipdfmr.par
share/texlive/tlpkg/dviout/propw.exe
share/texlive/bin/win32/djpeg.exe
share/texlive/texmf-dist/doc/support/wintools/fc-list.pdf
share/texlive/tlpkg/dviout/par/EJ-Embed.par
share/texlive/tlpkg/dviout/par/J-Embed.par
share/texlive/tlpkg/dviout/install.txt
share/texlive/tlpkg/dviout/par/fontpath.par
share/texlive/tlpkg/dviout/FONT/exjfonts.zip
share/texlive/tlpkg/dviout/SPECIAL/srcspecial.mac
share/texlive/tlpkg/dviout/par/E-noTT.par
share/texlive/tlpkg/dviout/DOC/dvi2.bmp
share/texlive/tlpkg/dviout/CFG/prtcfg.zip
share/texlive/tlpkg/dviout/dvispc.txt
share/texlive/texmf-dist/doc/support/wintools/pdfinfo.pdf
share/texlive/bin/win32/dviout.exe
share/texlive/tlpkg/dviout/map/ttfexp.map
share/texlive/bin/win32/gunzip.exe
share/texlive/tlpkg/dviout/par/dvipdfmxv.par
share/texlive/tlpkg/dviout/DOC/bpage.bmp
share/texlive/tlpkg/dviout/DOC/lplus.bmp
share/texlive/tlpkg/dviout/HYPERTEX/input8.tex
share/texlive/texmf-dist/doc/support/wintools/unzip.pdf
share/texlive/tlpkg/dviout/DOC/tex_dvioutw.html
share/texlive/bin/win32/tlaunchmode.exe
share/texlive/tlpkg/dviout/FONT/ReadMe.txt
share/texlive/tlpkg/dviout/GRAPHIC/PS/sample2.ps
share/texlive/tlpkg/dviout/GRAPHIC/bmc/exbmc.xpi
share/texlive/tlpkg/dviout/par/Macro0.par
share/texlive/tlpkg/dviout/par/hiragino.par
share/texlive/tlpkg/dviout/par/default.par
share/texlive/bin/win32/pdfunite.exe
share/texlive/tlpkg/dviout/par/E-TT.par
share/texlive/tlpkg/dviout/CFG/newcfg.txt
share/texlive/tlpkg/dviout/par/p4to1o0.pgm
share/texlive/tlpkg/dviout/optcfg.exe
share/texlive/tlpkg/dviout/DOC/hung.png
share/texlive/tlpkg/dviout/srctex.exe
share/texlive/tlpkg/dviout/DOC/option.bmp
share/texlive/tlpkg/dviout/dviadd.exe
share/texlive/texmf-dist/doc/support/tlaunch/tlaunch.pdf
share/texlive/tlpkg/dviout/par/jvar.par
share/texlive/tlpkg/dviout/par/wintex.par
share/texlive/tlpkg/dviout/par/bakoma.par
share/texlive/tlpkg/dviout/GRAPHIC/PS/sample3.ps
share/texlive/tlpkg/dviout/HYPERTEX/inputxy.tex
share/texlive/tlpkg/dviout/SPECIAL/dviout.sty
share/texlive/tlpkg/dviout/etfdump.exe
share/texlive/texmf-dist/doc/support/tlaunch/figures/custom_ed.png
share/texlive/tlpkg/dviout/par/E-Embed.par
share/texlive/tlpkg/dviout/par/dvispcat.par
share/texlive/bin/win32/bmp2png.exe
share/texlive/tlpkg/dviout/DOC/search.bmp
share/texlive/tlpkg/dviout/GRAPHIC/PS/sample0.ps
share/texlive/tlpkg/dviout/SAMPLE/slisamp3.tex
share/texlive/tlpkg/dviout/dvioute.chm
share/texlive/tlpkg/dviout/map/pttfonts.map
share/texlive/tlpkg/dviout/GRAPHIC/TPIC/tpic_ext.doc
share/texlive/tlpkg/dviout/par/WinJFont.par
share/texlive/tlpkg/dviout/DOC/newmin.png
share/texlive/tlpkg/dviout/par/p4to1v.pgm
share/texlive/tlpkg/dviout/par/dvipskdis.par
share/texlive/tlpkg/dviout/dviout.chm
share/texlive/tlpkg/dviout/dvioute.cnt
share/texlive/tlpkg/dviout/map/japanese.map
share/texlive/tlpkg/dviout/GRAPHIC/TPIC/rtexampl.tex
share/texlive/tlpkg/dviout/DOC/dvi.html
share/texlive/tlpkg/dviout/HYPERTEX/myhyper.sty
share/texlive/tlpkg/dviout/dviout.exe
share/texlive/tlpkg/dviout/rawprt.txt
share/texlive/texmf-dist/doc/support/wintools/pdfunite.pdf
share/texlive/tlpkg/dviout/GRAPHIC/PDL/lasersys.tex
share/texlive/bin/win32/jbig2.exe
share/texlive/tlpkg/dviout/PTEX/naochan!.tex
share/texlive/tlpkg/dviout/par/dvipskpdf.par
share/texlive/texmf-dist/doc/support/tlaunch/rug.zip
share/texlive/tlpkg/dviout/par/p24wait.pgm
share/texlive/bin/win32/cjpeg.exe
share/texlive/tlpkg/dviout/par/p4to1o.pgm
share/texlive/tlpkg/dviout/par/dvipsk.par
share/texlive/texmf-dist/doc/support/tlaunch/COPYING
share/texlive/tlpkg/dviout/DOC/print.bmp
share/texlive/tlpkg/dviout/par/p4n.pgm
share/texlive/tlpkg/dviout/par/dvipdfm.par
share/texlive/tlpkg/dviout/par/quitpresen.par
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/graphics.cfg
share/texlive/texmf-dist/doc/support/wintools/fc-validate.pdf
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/readme.eng
share/texlive/tlpkg/dviout/GRAPHIC/bmc/ifbmc.txt
share/texlive/bin/win32/tounix.exe
share/texlive/tlpkg/dviout/GRAPHIC/PDL/spec.tex
share/texlive/tlpkg/dviout/HYPERTEX/input7.tex
share/texlive/texmf-dist/doc/support/wintools/pdffonts.pdf
share/texlive/tlpkg/dviout/DOC/serd.bmp
share/texlive/texmf-dist/doc/support/wintools/fc-cat.pdf
share/texlive/tlpkg/dviout/HYPERTEX/keyin.sty
share/texlive/tlpkg/dviout/chkfont.txt
share/texlive/tlpkg/dviout/map/ttfonts.map
share/texlive/bin/win32/pdftoppm.exe
share/texlive/tlpkg/dviout/GRAPHIC/LATEX2E/dviout.def
share/texlive/tlpkg/dviout/par/quit.par
share/texlive/tlpkg/dviout/gen_pk
share/texlive/tlpkg/dviout/files.txt
share/texlive/tlpkg/dviout/dvispc.exe
share/texlive/bin/win32/pdfinfo.exe
share/texlive/tlpkg/dviout/par/dvispcal.par
share/texlive/tlpkg/dviout/par/texhelp.par
share/texlive/texmf-dist/doc/support/wintools/pdftotext.pdf
share/texlive/texmf-dist/doc/support/wintools/gzip.pdf
share/texlive/texmf-dist/doc/support/wintools/pdfsig.pdf
share/texlive/tlpkg/dviout/HYPERTEX/hyper2.tex
share/texlive/bin/win32/pdftocairo.exe
share/texlive/tlpkg/dviout/SAMPLE/sample.tex
share/texlive/tlpkg/dviout/par/dvipskprn.par
share/texlive/tlpkg/dviout/UTILITY/dviout0.par
share/texlive/tlpkg/dviout/SPECIAL/ophook.sty
share/texlive/tlpkg/dviout/par/dvispcap.par
share/texlive/tlpkg/dviout/SPECIAL/presen.txt
share/texlive/bin/win32/pdfdetach.exe
share/texlive/tlpkg/dviout/par/presen.par
share/texlive/tlpkg/dviout/par/dvispcs.par
share/texlive/tlpkg/dviout/UTILITY/test_a4.tex
share/texlive/tlpkg/dviout/DOC/cmode3.png
share/texlive/tlpkg/dviout/par/dvipskeps.par
share/texlive/tlpkg/dviout/HYPERTEX/input.tex
share/texlive/tlpkg/dviout/chkfont.exe
share/texlive/tlpkg/dviout/ttindex.exe
share/texlive/tlpkg/dviout/GRAPHIC/PBM/pbmf.doc
share/texlive/tlpkg/dviout/UTILITY/null.vfn
share/texlive/texmf-dist/doc/support/tlaunch/tlaunch.tex
share/texlive/bin/win32/pdftohtml.exe
share/texlive/tlpkg/dviout/par/dvipdfms.par
share/texlive/tlpkg/dviout/UTILITY/dvi$pdf.bat
share/texlive/bin/win32/texview.exe
share/texlive/tlpkg/dviout/UTILITY/dviout0.vfn
share/texlive/bin/win32/sam2p.exe
share/texlive/tlpkg/dviout/propw0.txt'
