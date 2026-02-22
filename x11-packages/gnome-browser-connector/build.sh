TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-browser-connector
TERMUX_PKG_DESCRIPTION="GNOME Shell browser connector"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="42.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-browser-connector/${TERMUX_PKG_VERSION%%.*}/gnome-browser-connector-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=bd9702ce1c163606ca32b8c13d1f3ba6e82b247cf87aac60610b411df1556212
TERMUX_PKG_DEPENDS="python, pygobject"
TERMUX_PKG_SUGGESTS="firefox"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_meson

	# Fix incorrect install path by overriding py.get_install_dir()
	sed -i \
		"s|py.get_install_dir()|join_paths(get_option('prefix'), 'lib', 'python${TERMUX_PYTHON_VERSION}', 'site-packages')|" \
		"$TERMUX_PKG_SRCDIR/meson.build"
}

termux_step_create_debscripts() {
	# Post-install script
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		set -e

		# Set up Firefox native messaging host
		mkdir -p "\$HOME/.mozilla/native-messaging-hosts"
		cp "$TERMUX_PREFIX/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json" "\$HOME/.mozilla/native-messaging-hosts/"

		# Set up Chromium native messaging host
		mkdir -p "\$HOME/.config/chromium/NativeMessagingHosts"
		cp "$TERMUX_PREFIX/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json" "\$HOME/.config/chromium/NativeMessagingHosts/"

		exit 0
	EOF

	# Pre-remove script
	cat <<-EOF >./prerm
		#!$TERMUX_PREFIX/bin/sh
		set -e

		# Clean up Firefox native messaging host
		rm -f "\$HOME/.mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json"

		# Clean up Chromium native messaging host
		rm -f "\$HOME/.config/chromium/NativeMessagingHosts/org.gnome.chrome_gnome_shell.json"

		exit 0
	EOF

	chmod 0755 ./postinst ./prerm
}
