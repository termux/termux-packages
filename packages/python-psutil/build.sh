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
	# on a Samsung Galaxy A70 SM-A705FN with Android 13,
	# a Samsung Galaxy S III SPH-L710 with Android 7,
	# two Android 15 devices, one of which is Samsung Galaxy S8+ SM-G955F,
	# and a 64-bit Android-x86 PC.
	# makes the command
	# 'python -c "import psutil; print(psutil.disk_partitions())"'
	# work successfully without root on Termux.
	mkdir -p "$TERMUX_PREFIX/etc/psutil"
	cat > "$TERMUX_PREFIX/etc/psutil/filesystems" << EOF
	btrfs
	cramfs
	erofs
	exfat
	ext2
	ext3
	ext4
	f2fs
	fuseblk
	msdos
	sdfat
	vfat
	xfs
nodev	anon_inodefs
nodev	autofs
nodev	bdev
nodev	binder
nodev	binfmt_misc
nodev	bpf
nodev	cgroup
nodev	cgroup2
nodev	cifs
nodev	configfs
nodev	cpuset
nodev	dax
nodev	debugfs
nodev	devpts
nodev	devtmpfs
nodev	ecryptfs
nodev	efivarfs
nodev	functionfs
nodev	fuse
nodev	fusectl
nodev	hugetlbfs
nodev	incremental-fs
nodev	mqueue
nodev	nfs
nodev	nfs4
nodev	overlay
nodev	pipefs
nodev	proc
nodev	pstore
nodev	ramfs
nodev	resctrl
nodev	rootfs
nodev	rpc_pipefs
nodev	sdcardfs
nodev	securityfs
nodev	selinuxfs
nodev	sockfs
nodev	sysfs
nodev	tmpfs
nodev	tracefs
nodev	virtiofs
EOF
}
