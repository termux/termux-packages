TERMUX_PKG_HOMEPAGE=https://github.com/skylot/jadx
TERMUX_PKG_DESCRIPTION="Dex to Java decompiler"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.7"
TERMUX_PKG_SRCURL=https://github.com/skylot/jadx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4afdd130f7ec60e88996b73d7c84c51b402cc36b4bf117bdc6289254027726cf
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
        export JADX_VERSION="$TERMUX_PKG_VERSION"
        ./gradlew clean dist

        sed -i "s#CLASSPATH=\$APP_HOME/share/jadx-$TERMUX_PKG_VERSION-all.jar#CLASSPATH=$TERMUX_PREFIX/share/java/jadx-$TERMUX_PKG_VERSION-all.jar#g" "$TERMUX_PKG_SRCDIR"/build/jadx/bin/jadx
}
termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin build/jadx/bin/jadx

        rm -rf $TERMUX_PREFIX/share/java/
        mkdir -p $TERMUX_PREFIX/share/java/
        install -Dm700 -t $TERMUX_PREFIX/share/java build/jadx/lib/*
}
