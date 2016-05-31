TERMUX_PKG_HOMEPAGE=https://github.com/tesseract-ocr/tesseract
TERMUX_PKG_DESCRIPTION="Tesseract is probably the most accurate open source OCR engine available"
TERMUX_PKG_VERSION=3.04.01
TERMUX_PKG_DEPENDS="libtool, libuuid, leptonica"
TERMUX_PKG_SRCURL=https://github.com/tesseract-ocr/tesseract/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=tesseract-${TERMUX_PKG_VERSION}

termux_step_pre_configure() {
	# http://blog.matt-swain.com/post/26419042500/installing-tesseract-ocr-on-mac-os-x-lion
	export LIBLEPT_HEADERSDIR=${TERMUX_PREFIX}/include/leptonica

	cd $TERMUX_PKG_SRCDIR
	perl -p -i -e 's|ADD_RT, true|ADD_RT, false|g' configure.ac
	./autogen.sh
}

termux_step_post_make_install() {
	# download english trained data
	cd "${TERMUX_PREFIX}/share/tessdata"
	rm -f eng.*
	for f in cube.{bigrams,fold,lm,nn,params,size,word-freq} tesseract_cube.nn traineddata; do
		f=eng.$f
		termux_download https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/$f $f
	done
}
