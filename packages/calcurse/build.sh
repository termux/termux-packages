TERMUX_PKG_HOMEPAGE=http://calcurse.org/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://calcurse.org/files/calcurse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
    export ac_cv_lib_pthread_pthread_create=yes
}

termux_step_pre_make() {
    # https://github.com/cSploit/android.native/blob/master/bionic_workarounds.md
    cd $TERMUX_PKG_SRCDIR/src

    sed -i -e 's/pthread_cancel(io_t_psave)/pthread_kill(io_t_psave, 0)/g' io.c
    sed -i -e 's/pthread_cancel(notify_t_main)/pthread_kill(notify_t_main, 0)/g' notify.c
    sed -i -e 's/pthread_cancel(ui_calendar_t_date)/pthread_kill(ui_calendar_t_date, 0)/g' ui-calendar.c
}