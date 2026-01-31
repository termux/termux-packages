TERMUX_PKG_HOMEPAGE=https://pip.pypa.io/
TERMUX_PKG_DESCRIPTION="The PyPA recommended tool for installing Python packages"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/pypa/pip/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d50d2b52693ce377496752d30c7b5736364dbe16e9c924521df740fad108d31d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+(?:\.\d+){1,2}(?!b)' # matches '25.3', '25.3.1' but not '26.0b1'
TERMUX_PKG_DEPENDS="python (>= 3.11.1-1)"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_BREAKS="python (<< 3.11.1-1)"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="docutils, myst_parser, sphinx_copybutton, sphinx_inline_tabs, sphinxcontrib.towncrier, completion"

termux_step_post_make_install() {
	if [ ! -e "$TERMUX_PYTHON_HOME/site-packages/pip-$TERMUX_PKG_VERSION.dist-info" ]; then
		termux_error_exit "Package ${TERMUX_PKG_NAME} doesn't build properly."
	fi
	( # creating pip documentation
		cd docs/
		python pip_sphinxext.py
		sphinx-build -b man -d build/doctrees/man man build/man -c html --tag man
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
	pip config set --global global.disable-pip-version-check true
	exit 0
	POSTINST_EOF
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi

	# deleting conf of pip while removing it
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/bash
	if [ -d $TERMUX_PREFIX/etc/pip.conf ]; then
		echo "Removing the pip setting..."
		rm -fr $TERMUX_PREFIX/etc/pip.conf
	fi
	exit 0
	PRERM_EOF

	chmod 0755 postinst prerm
}
