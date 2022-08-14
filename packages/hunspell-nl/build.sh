TERMUX_PKG_HOMEPAGE=https://www.opentaal.org/
TERMUX_PKG_DESCRIPTION="Dutch dictionary for hunspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license_en_EN.txt, licentie_nl_NL.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2013.07.22
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_get_source() {
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/nl_NL/README_NL.txt \
			$TERMUX_PKG_SRCDIR/README_NL.txt \
			5e080b0d6fad4d61b3403694bdc9ab40c725ed5523942170dc2a956c294ba91b
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/nl_NL/license_en_EN.txt \
			$TERMUX_PKG_SRCDIR/license_en_EN.txt \
			1d3243be74045a177b0c8a9a4b4166053f5c8966cb01a559a3b427762425490d
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/nl_NL/licentie_nl_NL.txt \
			$TERMUX_PKG_SRCDIR/licentie_nl_NL.txt \
			77f2de67a8110509d2d1db8bc3793e79a08451870f7da9071113094c728f4440
}

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/
	# On checksum mismatch the files may have been updated:
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/nl_NL/nl_NL.aff
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/nl_NL/nl_NL.dic
	# In which case we need to bump version and checksum used.
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/nl_NL/nl_NL.aff \
			$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/nl_NL.aff \
			0ee9233fe1c5785f9a803a05ac882e8363ac785c06fbd455af88ce0c0a57324b
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/nl_NL/nl_NL.dic \
			$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/nl_NL.dic \
			24782020d0d0bd465270027f51443b752f8ddaecf7c612a225e8668e1746aa24
	touch $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/nl_NL.{aff,dic}

	install -Dm600 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_SRCDIR/README_NL.txt
}
