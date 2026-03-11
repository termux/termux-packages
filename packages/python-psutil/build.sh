TERMUX_PKG_HOMEPAGE=https://github.com/giampaolo/psutil
TERMUX_PKG_DESCRIPTION="Cross-platform process and system utilities module for Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.2.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/giampaolo/psutil/archive/refs/tags/release-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=38f406bf21acc67e45f414b7980463b2e6e6270ba3616ffd41995d997078cbe6
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_post_make_install() {
	# extracted from 'sudo cat /proc/filesystems'
	# on Samsung Galaxy A70 SM-A705FN with Android 13
	# makes the command
	# 'python -c "import psutil; print(psutil.disk_partitions())"'
	# work successfully without root on Termux.
	mkdir -p "$TERMUX_PREFIX/etc/psutil"
	cat > "$TERMUX_PREFIX/etc/psutil/filesystems" << EOF
nodev	sysfs
nodev	rootfs
nodev	ramfs
nodev	bdev
nodev	proc
nodev	cpuset
nodev	cgroup
nodev	cgroup2
nodev	tmpfs
nodev	configfs
nodev	debugfs
nodev	tracefs
nodev	sockfs
nodev	dax
nodev	bpf
nodev	pipefs
nodev	devpts
	ext3
	ext2
	ext4
	vfat
	msdos
	sdfat
	exfat
nodev	ecryptfs
nodev	sdcardfs
	fuseblk
nodev	fuse
nodev	fusectl
	f2fs
nodev	pstore
nodev	selinuxfs
nodev	functionfs
EOF
}
