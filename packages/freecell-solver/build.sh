TERMUX_PKG_HOMEPAGE="https://fc-solve.shlomifish.org/"
TERMUX_PKG_DESCRIPTION="Freecell Solver is an open source library for automatically solving several variants of Solitaire/Patience card games, including Freecell."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.txt"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="6.16.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://fc-solve.shlomifish.org/downloads/fc-solve/freecell-solver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=71b8882e68f1be62529069018d0c732b75078669077c96348279575849f34313
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="gperf, libgmp, librinutils, perl, python"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMATH_LIB_LIST=m
-DFCS_WITH_TEST_SUITE=OFF
-DBUILD_STATIC_LIBRARY=OFF
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi
	# Need Perl modules Sub::Quote, Moo, Template, and Path::Tiny
	local -a ubuntu_packages=(
		"libsub-quote-perl"
		"libmoo-perl"
		"libtemplate-perl"
		"libpath-tiny-perl"
	)
	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	# Need Python modules pysol_cards, six
	local hostbuild_venv_dir="${TERMUX_PKG_HOSTBUILD_DIR}/venv-dir"
	python3 -m venv --system-site-packages "$hostbuild_venv_dir"
	. "$hostbuild_venv_dir/bin/activate"
	python3 -m pip install --no-input --disable-pip-version-check pysol-cards six
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then

		# The Template.pm path needs the version number, let's get it
		local upkg="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr"
		local perl_version="$(basename "$(find "$upkg/lib/x86_64-linux-gnu/perl5" \
			| grep -P "\d+\.\d+(.\d+)?$" | head -n1)")"
		echo "Detected Perl version: $perl_version"
		export PERL5LIB="$upkg/share/perl5:$upkg/lib/x86_64-linux-gnu/perl5/$perl_version"

		# need to preserve termux's toolchain environment in PATH
		# while activating the venv removes it
		local SAVED_PATH="$PATH"
		local hostbuild_venv_dir="${TERMUX_PKG_HOSTBUILD_DIR}/venv-dir"
		. "$hostbuild_venv_dir/bin/activate"
		export PATH="$PATH:$SAVED_PATH"
	fi
}
