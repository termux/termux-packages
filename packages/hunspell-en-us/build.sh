TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="American english dictionary for hunspell"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20240129
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/hunspell/
	# On checksum mismatch the files may have been updated:
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/en/en_US.aff
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/en/en_US.dic
	# In which case we need to bump version and checksum used.
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff \
			$TERMUX_PREFIX/share/hunspell/en_US.aff \
			e746c882dd6f303c2c46e7452804b9201115a6942cfeb15f18f8edf774d2e24e
	termux_download https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic \
			$TERMUX_PREFIX/share/hunspell/en_US.dic \
			f0b1a234bd178bdd01875b2a392a9647f888b8fe879f79c52aae62c2759b3647
	touch $TERMUX_PREFIX/share/hunspell/en_US.{aff,dic}
}
