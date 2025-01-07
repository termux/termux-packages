TERMUX_PKG_HOMEPAGE=https://rosettea.github.io/Hilbish/
TERMUX_PKG_DESCRIPTION="The Moon-powered shell! A comfy and extensible shell for Lua fans!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=0582fbd30c75e5915108df0183ac05747c69a7d9 # v2.3.2
TERMUX_PKG_VERSION="2024.07.30"
TERMUX_PKG_SRCURL=git+https://github.com/Rosettea/Hilbish
TERMUX_PKG_SHA256=7cbba35c2def313c5b60c1b2d5d16e80c4bcc788c3aad7bc36a56a0d4d22de22
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
	export GOPATH=$TERMUX_PKG_SRCDIR
	GOOS=android CGO_ENABLED=1 go build -ldflags "-checklinkname=0 -s -w -X main.dataDir=${TERMUX_PREFIX}/share/hilbish -X main.gitCommit=$(git ls-remote https://github.com/rosettea/hilbish refs/tags/v$TERMUX_PKG_VERSION) -X main.gitBranch=$TERMUX_PKG_VERSION"
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/share/hilbish"
	install -v -d "$TERMUX_PREFIX/bin" && install -m 0755 -v hilbish "$TERMUX_PREFIX/bin/hilbish"
	cp -r libs docs emmyLuaDocs nature .hilbishrc.lua "$TERMUX_PREFIX/share/hilbish"
	grep -qxF "$TERMUX_PREFIX/bin/hilbish" "$TERMUX_PREFIX/etc/shells" || echo "$TERMUX_PREFIX/bin/hilbish" >> "$TERMUX_PREFIX/etc/shells"
}
