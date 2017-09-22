TERMUX_PKG_HOMEPAGE=http://md5deep.sourceforge.net/
TERMUX_PKG_DESCRIPTION="a set of programs to compute MD5, SHA-1, SHA-256, Tiger, or Whirlpool message digests on an arbitrary number of files"
TERMUX_PKG_VERSION=4.4
TERMUX_PKG_SRCURL=https://github.com/jessek/hashdeep/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad78d42142f9a74fe8ec0c61bc78d6588a528cbb9aede9440f50b6ff477f3a7f
TERMUX_PKG_FOLDERNAME=hashdeep-$TERMUX_PKG_VERSION

termux_step_pre_configure () {
  sh bootstrap.sh
}
