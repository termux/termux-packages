TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/aa-project/
TERMUX_PKG_DESCRIPTION="A portable ASCII art graphic library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4rc5
TERMUX_PKG_REVISION=12
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/aa-project/aalib-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fbddda9230cf6ee2a4f5706b4b11e2190ae45f5eda1f0409dc4f99b35e0a70ee
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	local _bin=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p $_bin
	local _cc=$(basename $CC)
	cat <<-EOF > $_bin/$_cc
		#!$(command -v sh)
		_shared=
		for f in "\$@"; do
			case "\$f" in
				-shared ) _shared=1 ;;
			esac
		done
		exec "$(command -v $_cc)" "\$@" \${_shared:+-Wl,-rpath=$TERMUX_PREFIX/lib}
	EOF
	chmod 0700 $_bin/$_cc
	export PATH=$_bin:$PATH
}
