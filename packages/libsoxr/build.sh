TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/soxr/
TERMUX_PKG_DESCRIPTION="High quality, one-dimensional sample-rate conversion library"
TERMUX_PKG_VERSION=0.1.2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/soxr/files/soxr-$TERMUX_PKG_VERSION-Source.tar.xz
TERMUX_PKG_SHA256=54e6f434f1c491388cd92f0e3c47f1ade082cc24327bdc43762f7d1eefe0c275
TERMUX_PKG_BUILD_IN_SRC=yes


termux_step_configure() {
return 0;
}
termux_step_make() {
	termux_setup_cmake
	./go
}
