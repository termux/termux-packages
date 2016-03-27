TERMUX_PKG_HOMEPAGE=https://github.com/tesseract-ocr/tesseract
TERMUX_PKG_DESCRIPTION="Tesseract is probably the most accurate open source OCR engine available"
TERMUX_PKG_VERSION=3.04.01
TERMUX_PKG_BUILD_REVISION=1
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
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.bigrams
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.fold
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.lm
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.nn
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.params
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.size
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.cube.word-freq
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.tesseract_cube.nn
	wget https://raw.githubusercontent.com/tesseract-ocr/tessdata/master/eng.traineddata
}
