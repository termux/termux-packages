TERMUX_PKG_HOMEPAGE=http://magyarispell.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Hungarian dictionary for hunspell"
TERMUX_PKG_LICENSE="MPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2018.05.22
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_get_source() {
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/hu_HU/README_hu_HU.txt \
			$TERMUX_PKG_SRCDIR/README_hu_HU.txt \
			ea35822fee80da0a34168a67960c8687fb232484cc5c090bce56d7d9902e856f
}

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/
	# On checksum mismatch the files may have been updated:
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/hu_HU/hu_HU.aff
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/hu_HU/hu_HU.dic
	# In which case we need to bump version and checksum used.
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/hu_HU/hu_HU.aff \
			$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/hu_HU.aff \
			75edc7adb7699af43374aa2ecab7bb739a78388cf9873e8475f680c9cfe1f7c2
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/hu_HU/hu_HU.dic \
			$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/hu_HU.dic \
			361558fe19023da48867493daf741ed72a57f61ff59648c83550422c1770eb8b
	touch $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/hunspell/hu_HU.{aff,dic}

	install -Dm600 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_SRCDIR/README_hu_HU.txt
}
