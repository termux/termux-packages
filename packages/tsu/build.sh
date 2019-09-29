TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=3.0.6
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_create_debscripts() {	
    rm postinst
    cat <<'EOF' >> postinst
#!$TERMUX_PREFIX/bin/sh
	if [ -z \"x\$2\" ]; then
             pip install tsu
         else
              pip install --upgrade tsu
         fi
EOF
    chmod 0755 postinst
}
