TERMUX_PKG_HOMEPAGE=http://sourceforge.net/projects/hunspell/files/Spelling%20dictionaries/en_US/
TERMUX_PKG_DESCRIPTION="American english dictionary for hunspell"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_DEPENDS="hunspell"

termux_step_make_install () {
	curl -L http://downloads.sourceforge.net/project/hunspell/Spelling%20dictionaries/en_US/en_US.zip > en_US.zip
	unzip en_US.zip
	rm -Rf $TERMUX_PREFIX/share/hunspell/en_US.{aff,dic}
	mkdir -p $TERMUX_PREFIX/share/hunspell/
	mv en_US.{aff,dic} $TERMUX_PREFIX/share/hunspell/
}
