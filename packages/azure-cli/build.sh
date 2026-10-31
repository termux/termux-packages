TERMUX_PKG_HOMEPAGE="https://learn.microsoft.com/en-us/cli/azure/"
TERMUX_PKG_DESCRIPTION="Microsoft's command-line tool for managing Azure cloud resources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.91.0"
TERMUX_PKG_SRCURL="https://github.com/Azure/azure-cli/archive/refs/tags/azure-cli-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7584dc798f43729463fbdbebedccbafd9fb77e4e3dc64f19f2d6945d4eee5fa8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="python, python-pip, python-cryptography, python-psutil, python-bcrypt, python-pynacl"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="azure-cli, azure-cli-core, azure-cli-telemetry, argcomplete"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, wheel, argcomplete"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	local _src="$TERMUX_PKG_SRCDIR/src"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli-telemetry"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli-core"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli"
}

termux_step_post_make_install() {
	rm -f "$TERMUX_PREFIX"/bin/{az.bat,az.completion.sh,azps.ps1}

	local _completion_dir="$TERMUX_PREFIX/share/bash-completion/completions"
	mkdir -p "$_completion_dir"
	cp "$TERMUX_PKG_SRCDIR/az.completion" "$_completion_dir/az"

	local _register="$(command -v register-python-argcomplete)"

	mkdir -p "$TERMUX_PREFIX/share/zsh/site-functions"
	"$_register" az --shell zsh > "$TERMUX_PREFIX/share/zsh/site-functions/_az"

	mkdir -p "$TERMUX_PREFIX/share/fish/vendor_completions.d"
	"$_register" az --shell fish > "$TERMUX_PREFIX/share/fish/vendor_completions.d/az.fish"
}
