TERMUX_PKG_HOMEPAGE=https://git.yzena.com/Yzena/Yc
TERMUX_PKG_DESCRIPTION="Monopackage with Rig, Yao, and Yvm"
TERMUX_PKG_LICENSE="LicenseRef-LICENSE.YNL.md AND SSPL-1.0"
TERMUX_PKG_MAINTAINER="Gavin D. Howard <gavin@yzena.com>"
TERMUX_PKG_VERSION=24.04.04
TERMUX_PKG_SRCURL=https://git.yzena.com/Yzena/Yc/releases/download/${TERMUX_PKG_VERSION}/${TERMUX_PKG_NAME}-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5e0ca7e087048da37192c51ea9e6873b69c68dbd2668ac7682250e8498315fed
TERMUX_PKG_HOSTBUILD=true

# Yc has its own build system, so it needs to bootstrap on the host first.
termux_step_host_build() {

	cd "$TERMUX_PKG_BUILDDIR"

	# The source needs to be in the build directory for bootstrap.
	cp -r "$TERMUX_PKG_SRCDIR" ./bootstrap
	cd ./bootstrap

	# Yc has a C program that does the bootstrap.
	gcc -o bootstrap/bootstrap bootstrap/bootstrap.c
	./bootstrap/bootstrap gcc
}

termux_step_configure() {
	cd "$TERMUX_PKG_BUILDDIR"
	# It's just easier to have the source in the build directory for the build.
	cp -r "$TERMUX_PKG_SRCDIR" ./yc
}

termux_step_make() {
	cd "$TERMUX_PKG_BUILDDIR/yc"
	# Yc's build likes to stomp on $PATH, so we need to stop that. It also needs
	# to know that it is being built for Android, as well as what compiler to
	# use. Finally, the build automatically defines _BSD_SOURCE, which doesn't
	# work on Android.
	../bootstrap/release/yc rigr --preserve-path --os=Android --compiler=gcc \
		--compiler-flag=-U_BSD_SOURCE
}

termux_step_make_install() {
	cd "$TERMUX_PKG_BUILDDIR/yc"
	install -Dm700 -T release/yc $TERMUX_PREFIX/bin/yc
	# The executable is a multicall binary, so we link all of the possible
	# programs to it.
	ln -sf ./yc $TERMUX_PREFIX/bin/rig
	ln -sf ./yc $TERMUX_PREFIX/bin/rigr
	ln -sf ./yc $TERMUX_PREFIX/bin/rigc
	ln -sf ./yc $TERMUX_PREFIX/bin/yao
	chmod 700 $TERMUX_PREFIX/bin/rig{r,c,} $TERMUX_PREFIX/bin/yao
}

termux_step_install_license() {
	# Yc is under two licenses, and both must be followed.
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/ yc/LICENSE.md
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/ \
		yc/LICENSE.SSPL.txt
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/ \
		yc/LICENSE.YNL.md
}
