TERMUX_PKG_HOMEPAGE=https://github.com
TERMUX_PKG_DESCRIPTION="A minimal terminal IDE built with Python and curses"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="turboanswer"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=git+https://github.com
TERMUX_PKG_PLATFORM_INDEPENDENT=true
termux_step_make_install() {
    # Create the system directory for your application files
    mkdir -p "$TERMUX_PREFIX/share/lite-ide"
    cp -r "$TERMUX_PKG_SRCDIR/packages/lite-ide/"* "$TERMUX_PREFIX/share/lite-ide/"

    # Create an executable launcher script in the system path
    mkdir -p "$TERMUX_PREFIX/bin"
    cat <<- EOF > "$TERMUX_PREFIX/bin/lite-ide"
		#!/data/data/com.termux/files/usr/bin/python3
		import sys
		import os
		sys.path.insert(0, "$TERMUX_PREFIX/share/lite-ide")
		import main
		if __name__ == "__main__":
		    main.main()
	EOF
    chmod +x "$TERMUX_PREFIX/bin/lite-ide"
}
