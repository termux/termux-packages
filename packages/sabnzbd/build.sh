TERMUX_PKG_HOMEPAGE=https://sabnzbd.org/
TERMUX_PKG_DESCRIPTION="Fully automated Usenet Binary Downloader"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, GPL2.txt, GPL3.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/sabnzbd/sabnzbd/releases/download/${TERMUX_PKG_VERSION}/SABnzbd-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=c9902c212df3e6b7208c850e6ceab244afc4b3e173459c425db9be4df902bd44
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-cryptography, python-sabyenc3, termux-tools, par2, unrar, p7zip, unzip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=("sabnzbd" 'exec sabnzbd -d 2>&1')

termux_step_post_get_source() {
	export TERMUX_PKG_PYTHON_TARGET_DEPS=""
	while IFS="" read -r dep
	do
		# only install main requirements
		if [ -z "$dep" ]; then
			break
		fi
		dep="${dep/[# ]*}"
		# https://github.com/termux/termux-packages/issues/20229
		if [ -z "$dep" ] || [ -z "${dep/sabctools*}" ]; then
			continue
		fi
		TERMUX_PKG_PYTHON_TARGET_DEPS+="'$dep', "
	done < $TERMUX_PKG_SRCDIR/requirements.txt
}

termux_step_make_install() {
	local sabnzbd="${TERMUX_PREFIX}/share/sabnzbd"
	mkdir -p "${sabnzbd}"
	cp -r email icons interfaces locale po sabnzbd scripts tools "${sabnzbd}"
	find "${sabnzbd}" -type d -exec chmod 700 {} \;
	find "${sabnzbd}" -type f -exec chmod 600 {} \;
	install -Dm700 SABnzbd.py "${TERMUX_PREFIX}/bin/sabnzbd"
	install -Dm600 linux/sabnzbd.bash-completion "${TERMUX_PREFIX}/share/bash-completion/completions/sabnzbd"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
