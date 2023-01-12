TERMUX_PKG_VERSION=22.3.1
TERMUX_PKG_HOMEPAGE=https://pip.pypa.io/
TERMUX_PKG_DESCRIPTION="The PyPA recommended tool for installing Python packages"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/pypa/pip/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8d9f7cd8ad0d6f0c70e71704fd3f0f6538d70930454f1f21bbc2f8e94f6964ee
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, docutils, myst_parser, sphinx_copybutton, sphinx_inline_tabs, sphinxcontrib.towncrier, completion"

termux_step_post_make_install() {
	( # creating pip documentation
		cd docs/
		python pip_sphinxext.py
		sphinx-build -b man -d build/doctrees/man man build/man -c html
	)

	install -vDm 644 LICENSE.txt -t "$TERMUX_PREFIX/share/licenses/python-pip/"
	install -vDm 644 docs/build/man/*.1 -t "$TERMUX_PREFIX/share/man/man1/"
	install -vDm 644 {NEWS,README}.rst -t "$TERMUX_PREFIX/share/doc/python-pip/"

	"$TERMUX_PREFIX"/bin/pip completion --bash | install -vDm 644 /dev/stdin "$TERMUX_PREFIX"/share/bash-completion/completions/pip
	"$TERMUX_PREFIX"/bin/pip completion --fish | install -vDm 644 /dev/stdin "$TERMUX_PREFIX"/share/fish/vendor_completions.d/pip.fish
}

termux_step_create_debscripts() {
	# disable pip update notification
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	echo "pip setup..."
	pip config set global.disable-pip-version-check true
	exit 0
	POSTINST_EOF
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi

	# deleting conf of pip while removing it
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/bash
	if [ -d ~/.config/pip ]; then
		echo "Removing the pip setting..."
		rm -fr ~/.config/pip
	fi
	exit 0
	PRERM_EOF

	chmod 0755 postinst prerm
}
