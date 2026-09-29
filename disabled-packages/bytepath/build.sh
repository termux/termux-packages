# x11-packages
TERMUX_PKG_HOMEPAGE=https://github.com/a327ex/BYTEPATH
TERMUX_PKG_DESCRIPTION="A replayable arcade shooter with a focus on build theorycrafting"
# License: MIT (assets have their own licenses)
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, objects/modules/CreditsModule.lua"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=51ee3086ae3369a2c80e4e47d4b62d480af4fe89
TERMUX_PKG_VERSION=2020.08.14
TERMUX_PKG_SRCURL=git+https://github.com/a327ex/BYTEPATH
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="love10"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_make_install() {
	local _share_dir="$TERMUX_PREFIX/share/bytepath"
	mkdir -p "${_share_dir}"
	find . -mindepth 1 -maxdepth 1 ! -name .git -a ! -name love \
		-exec cp -r \{\} "${_share_dir}/" \;
	local _exe="$TERMUX_PREFIX/bin/bytepath"
	rm -rf "${_exe}"
	mkdir -p "$(dirname "${_exe}")"
	cat <<-EOF > "${_exe}"
		#!$TERMUX_PREFIX/bin/sh
		exec $TERMUX_PREFIX/bin/love "${_share_dir}"
	EOF
	chmod 0700 "${_exe}"
}
