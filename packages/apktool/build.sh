TERMUX_PKG_HOMEPAGE=https://ibotpeaches.github.io/Apktool/
TERMUX_PKG_DESCRIPTION="A tool for reverse engineering 3rd party, closed, binary Android apps"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_SRCURL=https://github.com/iBotPeaches/Apktool/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=74739cdb1434ca35ec34e51ca7272ad3f378ae3ed0a2d5805d9a2fab5016037f
TERMUX_PKG_DEPENDS="aapt, openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	local prebuilt_dir="brut.apktool/apktool-lib/src/main/resources/prebuilt"
	rm -rf $prebuilt_dir/{linux,macosx,windows}
	mkdir -p $prebuilt_dir/linux
	local exe_suffix=
	if [ $TERMUX_ARCH_BITS == 64 ]; then
		exe_suffix=_64
	fi
	for exe_name in aapt aapt2; do
		local exe_path=$prebuilt_dir/linux/${exe_name}${exe_suffix}
		$CC $CFLAGS $CPPFLAGS aapt-wrapper/${exe_name}-wrapper.c \
			-o ${exe_path} $LDFLAGS
		$STRIP --strip-unneeded ${exe_path}
	done
}

termux_step_make() {
	sh gradlew build shadowJar -x test
}

termux_step_make_install() {
	install -Dm600 brut.apktool/apktool-cli/build/libs/apktool-cli-all.jar \
		$TERMUX_PREFIX/share/java/apktool.jar
	cat <<- EOF > $TERMUX_PREFIX/bin/apktool
	#!${TERMUX_PREFIX}/bin/sh
	exec java -jar $TERMUX_PREFIX/share/java/apktool.jar "\$@"
	EOF
	chmod 700 $TERMUX_PREFIX/bin/apktool
}
