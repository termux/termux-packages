TERMUX_PKG_HOMEPAGE=https://github.com/tesseract-ocr/tesseract
TERMUX_PKG_DESCRIPTION="Tesseract is probably the most accurate open source OCR engine available"
TERMUX_PKG_VERSION=3.05.01
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="libtool, libuuid, leptonica"
TERMUX_PKG_SRCURL=https://github.com/tesseract-ocr/tesseract/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05898f93c5d057fada49b9a116fc86ad9310ff1726a0f499c3e5211b3af47ec1

termux_step_pre_configure() {
	# http://blog.matt-swain.com/post/26419042500/installing-tesseract-ocr-on-mac-os-x-lion
	export LIBLEPT_HEADERSDIR=${TERMUX_PREFIX}/include/leptonica

	perl -p -i -e 's|ADD_RT], true|ADD_RT], false|g' configure.ac
	./autogen.sh
}

termux_step_post_make_install() {
	# download english trained data
	cd "${TERMUX_PREFIX}/share/tessdata"
	rm -f eng.*
	for f in cube.{bigrams,fold,lm,nn,params,size,word-freq} tesseract_cube.nn traineddata; do
		f=eng.$f
		# From the tessdata README: "These language data files only work with
		# Tesseract 4. They are based on the sources in tesseract-ocr/langdata on GitHub.
		# Get language data files for Tesseract 3.04 or 3.05 from the 3.04 tree."
		termux_download \
			https://raw.githubusercontent.com/tesseract-ocr/tessdata/3.04.00/$f \
			$f
	done
}
