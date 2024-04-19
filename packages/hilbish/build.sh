TERMUX_PKG_HOMEPAGE=https://rosettea.github.io/Hilbish/
TERMUX_PKG_DESCRIPTION="The Moon-powered shell! A comfy and extensible shell for Lua fans!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=40c3cecabb38a68064727368b5882196a59d34d9 # v2.2.2
TERMUX_PKG_VERSION="2024.04.16"
TERMUX_PKG_SRCURL=git+https://github.com/Rosettea/Hilbish
TERMUX_PKG_SHA256=626c9c2dce70c54aeb98ce58566744c411398dd71990a72039bfc1b43a6e0382
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
	git submodule update --init --recursive

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_make() {
	termux_setup_golang
	sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

	sed -i 's/rvalue/$TERMUX_PKG_VERSION/g' Taskfile.yaml
	GOOS=android ./bin/task
}

termux_step_make_install() {
	./bin/task install
}
