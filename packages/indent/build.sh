TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/indent
TERMUX_PKG_DESCRIPTION="C language source code formatting program"
TERMUX_PKG_VERSION=2.2.11
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/i/indent/indent_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=aaff60ce4d255efb985f0eb78cca4d1ad766c6e051666073050656b6753a0893
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_HOSTBUILD=true
termux_step_post_extract_package() {
    # this should detect if we are running inside termux docker image 
    if  [ $HOME = "/home/builder" ] && [ "grep docker /proc/1/cgroup > /dev/null" ]; then
	sudo apt update
	sudo apt install texi2html
    fi
}
