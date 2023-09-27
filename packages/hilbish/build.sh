TERMUX_PKG_HOMEPAGE=https://rosettea.github.io/Hilbish/
TERMUX_PKG_DESCRIPTION="The Moon-powered shell! A comfy and extensible shell for Lua fans!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=caff604d953064c4678b0fbcdc18b808ff52cd43
TERMUX_PKG_VERSION="2023.07.10"
TERMUX_PKG_SRCURL=git+https://github.com/Rosettea/Hilbish
TERMUX_PKG_SHA256=cc57ece44c213194785fab5bfd3fc291e910937cbcdc19409bf4168435ad1dd2
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
