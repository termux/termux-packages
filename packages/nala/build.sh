TERMUX_PKG_HOMEPAGE=https://gitlab.com/volian/nala
TERMUX_PKG_DESCRIPTION="Commandline frontend for the apt package manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.4"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://gitlab.com/volian/nala/-/archive/v${TERMUX_PKG_VERSION}/nala-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a49ecfaf8fa73262807bb3f963ce280856d3cbefd11684da747899d21a4485fe
TERMUX_PKG_DEPENDS="python-apt, python-pip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_PYTHON_COMMON_DEPS="poetry"
TERMUX_PKG_PYTHON_TARGET_DEPS="anyio, httpx, jsbeautifier, pexpect, python-debian, rich, tomli, typer, typing-extensions"

termux_step_pre_configure() {
	rm -rf nala/__init__.py.orig
}

termux_step_post_make_install() {
	# from nala_build.py
	for file in docs/*.rst; do
		pandoc "${file}" --output="${file%.*}" --standalone \
			--variable=header:"Nala User Manual" \
			--variable=footer:"${TERMUX_PKG_VERSION}" \
			--variable=date:"$(date -d @${SOURCE_DATE_EPOCH})" \
			--variable=section:8 \
			--from rst --to man

		install -Dm600 -t "$TERMUX_PREFIX"/share/man/man8/ "${file%.*}"
	done

	install -Dm600 -t $TERMUX_PREFIX/etc/nala debian/nala.conf
	install -Dm600 debian/nala.fish "$TERMUX_PREFIX"/share/fish/vendor_completions.d/nala.fish
	install -Dm600 debian/bash-completion "$TERMUX_PREFIX"/share/bash-completion/completions/nala
	install -Dm600 debian/_nala "$TERMUX_PREFIX"/share/zsh/site-functions/_nala
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/lib/nala
	mkdir -p $TERMUX_PREFIX/var/log/nala
	mkdir -p $TERMUX_PREFIX/var/lock
	echo "Installing dependencies through pip..."
	pip3 install nala python-debian
	EOF
}
