TERMUX_PKG_HOMEPAGE=http://jamvm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="JamVM is an open-source Java Virtual Machine that aims to support the latest version of the JVM specification, while at the same time being compact and easy to understand."
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_BUILD_REVISION=1
#TERMUX_PKG_SRCURL=http://www.smallpotato000.cn/jamvm-${TERMUX_PKG_VERSION}-fix.tar.gz
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%20${TERMUX_PKG_VERSION}/jamvm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-classpath-install-dir=$TERMUX_PREFIX"

