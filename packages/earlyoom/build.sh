TERMUX_PKG_HOMEPAGE=https://github.com/rfjakob/earlyoom
# are line breaks respected?
TERMUX_PKG_DESCRIPTION='
out of memory OOM safety net that prevent freezes and closing termux from memory overrun. replacement for  lmk that termux lack  permission to utilise for its programmes  . another alternative is activating the kernel oom_kill.c by increasing the badness from

~/.bashrc
choom -n 500 -p $$

refer to termux-services for service management . default limit 30 percentage is adapted for 4 gig phone. change it in

$SVDIR/earlyoom/run

print status info from

logcat -d|ack oom

 if a build process is killed by earlyoom  disable parallel building and try again 

~/.gradle/gradle.properties
org.gradle.parallel=false
org.gradle.daemon=false
org.gradle.jvmargs=-Xmx256m

$HOME/.cargo/config.toml
[build]
jobs = 1

export MAKEFLAGS=-j1
'
# echo "$TERMUX_PKG_DESCRIPTION";exit
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=$(date +"%y%m%d")
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/john-peterson/earlyoom 
TERMUX_PKG_GIT_BRANCH=termux
TERMUX_PKG_DEPENDS="  "
TERMUX_PKG_SUGGESTS=" termux-services"
TERMUX_PKG_BUILD_DEPENDS=" make clang "
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="

"
TERMUX_PKG_EXTRA_MAKE_ARGS="V=1"
if $TERMUX_ON_DEVICE_BUILD; then TERMUX_PKG_MAKE_PROCESSES=1;fi
TERMUX_PKG_SERVICE_SCRIPT=("earlyoom" 'exec earlyoom -r 0 -m 30,15 -s 30,15 --sort-by-rss --ignore termux -N $PREFIX/bin/earlyoom-wall --syslog')

if !$TERMUX_ON_DEVICE_BUILD; then
echo " untested off device might fail "
#read
fi

termux_step_post_get_source() {

}


termux_step_pre_configure() {

}

termux_step_post_configure(){
	export CFLAGS+=" -w -Wno-error -Wfatal-errors"
}

termux_step_post_make_install() {
  install -Dm755 "$TERMUX_PKG_BUILDER_DIR/earlyoom-wall" -t "$TERMUX_PREFIX/bin"
}
