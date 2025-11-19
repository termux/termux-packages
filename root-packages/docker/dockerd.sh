#!@TERMUX_PREFIX@/bin/bash

export PATH="${PATH}:/system/xbin:/system/bin"
opts='rw,nosuid,nodev,noexec,relatime'
cgroups='blkio cpu cpuacct cpuset devices freezer memory pids schedtune'

# try to mount cgroup root dir and exit in case of failure
if ! mountpoint -q /sys/fs/cgroup 2>/dev/null; then
  mkdir -p /sys/fs/cgroup
  mount -t tmpfs -o "${opts}" cgroup_root /sys/fs/cgroup || exit 1
fi

# try to mount cgroup2
if ! mountpoint -q /sys/fs/cgroup/cg2_bpf 2>/dev/null; then
  mkdir -p /sys/fs/cgroup/cg2_bpf
  mount -t cgroup2 -o "${opts}" cgroup2_root /sys/fs/cgroup/cg2_bpf
fi

# try to mount differents cgroups
for cg in ${cgroups}; do
  if ! mountpoint -q "/sys/fs/cgroup/${cg}" 2>/dev/null; then
    mkdir -p "/sys/fs/cgroup/${cg}"
    mount -t cgroup -o "${opts},${cg}" "${cg}" "/sys/fs/cgroup/${cg}" \
    || rmdir "/sys/fs/cgroup/${cg}"
  fi
done

# start the docker daemon
"@TERMUX_PREFIX@/libexec/dockerd" $@
