#!@TERMUX_PREFIX@/bin/sh
set -e

export PATH=$PATH:/system/xbin:/system/bin

if ! mountpoint -q /sys/fs/cgroup; then
	mount -t tmpfs -o mode=755,nodev,noexec,nosuid tmpfs /sys/fs/cgroup
fi

for cg in blkio cpu cpuacct cpuset devices freezer memory; do
	if [ ! -d "/sys/fs/cgroup/${cg}" ]; then
		mkdir -p "/sys/fs/cgroup/${cg}"
	fi

	if ! mountpoint -q "/sys/fs/cgroup/${cg}"; then
		mount -t cgroup -o "${cg}" cgroup "/sys/fs/cgroup/${cg}" || true
	fi
done
