TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="Russian dictionary for hunspell"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20210731
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/hunspell/
	# On checksum mismatch the files may have been updated:
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/ru_RU/ru_RU.aff
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/ru_RU/ru_RU.dic
	# In which case we need to bump version and checksum used.
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/ru_RU/ru_RU.aff \
			$TERMUX_PREFIX/share/hunspell/ru_RU.aff \
			38ce7d4af78e211e9bafe4bf7e3d6a2c420591136cb738ec6648f8fdf6524cd7
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/ru_RU/ru_RU.dic \
			$TERMUX_PREFIX/share/hunspell/ru_RU.dic \
			f6047416a0204adbecf3a451b874ec8a97ee37e2cbc714466ef04d8dbcc0d6fc
	touch $TERMUX_PREFIX/share/hunspell/ru_RU.{aff,dic}
}
