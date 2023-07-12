TERMUX_PKG_HOMEPAGE=https://www.qsl.net/kd2bd/predict.html
TERMUX_PKG_DESCRIPTION="Track and predict passes of satellites in Earth orbit"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.3
TERMUX_PKG_SRCURL=https://ftp-osl.osuosl.org/pub/gentoo/distfiles/predict_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=47b7c185f1cf4d318b6b31a22a533c03c4a3f57394839df036367c7cdf2dd7ff
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_download \
		"https://ftp-osl.osuosl.org/pub/gentoo/distfiles/predict_2.2.3-3.1.diff.gz" \
		$TERMUX_PKG_CACHEDIR/predict_2.2.3-3.1.diff.gz \
		60c00a542c399e69dba154cc0827ea15f33dae61547f3604b8c232e9d26d06df
	zcat $TERMUX_PKG_CACHEDIR/predict_2.2.3-3.1.diff.gz | patch --silent -p1
	cat debian/patches/*.diff | patch --silent -p1

	ln -sfT fodtrack-0.1 utils/fodtrack
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}

termux_step_configure() {
	:
}

termux_step_make() {
	local p
	for p in predict{,-g1yyh}; do
		${CC} ${CFLAGS} ${CPPFLAGS} ${p}.c -o ${p} ${LDFLAGS} \
			-lncursesw -lmenu
	done
	local d
	for d in clients/kep_reload utils/{fodtrack,geosat,moontracker}; do
		p=$(basename ${d})
		pushd ${d}
		${CC} ${CFLAGS} ${CPPFLAGS} ${p}.c -o ${p} ${LDFLAGS}
		popd
	done
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin predict{,-g1yyh}
	local d
	for d in clients/kep_reload utils/{fodtrack,geosat,moontracker}; do
		local p=$(basename ${d})
		install -Dm700 -t $TERMUX_PREFIX/bin ${d}/${p}
	done
	install -Dm600 -t $TERMUX_PREFIX/etc utils/fodtrack/fodtrack.conf
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		docs/man/predict.1 \
		debian/{kep_reload,moontracker}.1
	local p
	for p in geosat predict-g1yyh; do
		install -Dm600 -T debian/${p}.man \
			$TERMUX_PREFIX/share/man/man1/${p}.1
	done
	install -Dm600 -t $TERMUX_PREFIX/share/man/man5 \
		utils/fodtrack/fodtrack.conf.5
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 \
		utils/fodtrack/fodtrack.8
	install -Dm600 -t $TERMUX_PREFIX/share/predict/default default/*
}
