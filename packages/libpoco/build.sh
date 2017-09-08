TERMUX_PKG_HOMEPAGE=https://github.com/pocoproject/poco
TERMUX_PKG_DESCRIPTION="C++ Portable Components (POCO)"
TERMUX_PKG_VERSION=pre-cpp11
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/pre-cpp11.tar.gz
TERMUX_PKG_SHA256=552ce21ad5fbbc22b288fedcd1bb7e1b73362c66a02ea7ea6e680603fac433ca
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_DEPENDS="openssl"
# we have to use pre version because current is not compatable with libc++ in android we use. 
TERMUX_PKG_FOLDERNAME=poco-pre-cpp11
