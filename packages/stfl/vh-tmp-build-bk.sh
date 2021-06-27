TERMUX_PKG_HOMEPAGE=http://www.clifford.at/stfl
TERMUX_PKG_DESCRIPTION="Structured Terminal Forms Language/Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.clifford.at/stfl/stfl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, ruby, perl"
TERMUX_PKG_BREAKS="stfl-dev"
TERMUX_PKG_REPLACES="stfl-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cat /data/data/*/files/usr/lib/ruby/*/*-linux-android-android/rbconfig.rb \
		| sed 's/raise "/"/g' \
		> "$TERMUX_PKG_SRCDIR/ruby/override_rbconfig.rb"
	sed -i '1 i require "./override_rbconfig"; ' "$TERMUX_PKG_SRCDIR/ruby/extconf.rb"

	cat <<- 'CONTENT' >> "$TERMUX_PKG_SRCDIR/perl5/hook_makefile.sh"
#!/bin/bash

TERMUX_PERL_INC="${TERMUX_PREFIX}/include/perl"

sed -iE \
	-e "1 i INC = -I${TERMUX_PREFIX}/include" \
	-e "s/^FULL_AR = .*/FULL_AR = ${SCRIPT_FULL_AR//\//\\\/}/g" \
	-e "s/^AR = .*/AR = ${SCRIPT_AR//\//\\\/}/g" \
	-e "s/^LD = .*/LD = ${SCRIPT_LD//\//\\\/}/g" \
	-e "s/^LDDLFLAGS = .*/LD = ${SCRIPT_LDDLFLAGS//\//\\\/}/g" \
	-e "s/^LDFLAGS = .*/LD = ${SCRIPT_LDFLAGS//\//\\\/}/g" \
	-e "s/^PERL_INC = .*/PERL_INC = ${TERMUX_PERL_INC//\//\\\/}/g" \
	-e "s/^CC = .*/CC = ${SCRIPT_CC//\//\\\/}/g" ./Makefile
CONTENT
	sed -i "2 i export SCRIPT_AR='$AR'" "$TERMUX_PKG_SRCDIR/perl5/hook_makefile.sh"
	sed -i "2 i export SCRIPT_CC='$CC'" "$TERMUX_PKG_SRCDIR/perl5/hook_makefile.sh"
	sed -i '4 i export SCRIPT_FULL_AR=$(which $SCRIPT_AR)' "$TERMUX_PKG_SRCDIR/perl5/hook_makefile.sh"
	sed -i '2 i export TERMUX_PREFIX="'"$(echo $TERMUX_PREFIX)"'"' "$TERMUX_PKG_SRCDIR/perl5/hook_makefile.sh"
	echo 'system("/bin/bash ./hook_makefile.sh");' >> "$TERMUX_PKG_SRCDIR/perl5/Makefile.PL"
}

termux_step_configure() {
	CC+=" $CPPFLAGS"
	export LDLIBS="-liconv"
}
