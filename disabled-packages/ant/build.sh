TERMUX_PKG_HOMEPAGE=http://ant.apache.org/
TERMUX_PKG_DESCRIPTION="Java based build tool like make"
TERMUX_PKG_VERSION=1.9.6
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net//ant/binaries/apache-ant-${TERMUX_PKG_VERSION}-bin.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/ant/lib

	for jar in ant ant-launcher; do
		$TERMUX_DX \
			--dex \
			--output=$TERMUX_PREFIX/share/ant/lib/${jar}.jar \
			lib/${jar}.jar
	done

	install $TERMUX_PKG_BUILDER_DIR/ant $TERMUX_PREFIX/bin/ant
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ant
}
