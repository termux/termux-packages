TERMUX_SUBPKG_DESCRIPTION="Utilities for handling block device attributes"
TERMUX_SUBPKG_DEPENDS="libblkid, libmount, libsmartcols, libuuid"
TERMUX_SUBPKG_BREAKS="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_REPLACES="util-linux (<< 2.38.1-1)"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
bin/blkdiscard
bin/blkid
bin/blkzone
bin/findfs
bin/fsck
bin/lsblk
bin/mkswap
bin/partx
bin/swaplabel
bin/wipefs
share/bash-completion/completions/blkdiscard
share/bash-completion/completions/blkid
share/bash-completion/completions/blkzone
share/bash-completion/completions/findfs
share/bash-completion/completions/fsck
share/bash-completion/completions/lsblk
share/bash-completion/completions/mkswap
share/bash-completion/completions/partx
share/bash-completion/completions/swaplabel
share/bash-completion/completions/wipefs
share/man/man8/blkdiscard.8.gz
share/man/man8/blkid.8.gz
share/man/man8/blkzone.8.gz
share/man/man8/findfs.8.gz
share/man/man8/fsck.8.gz
share/man/man8/lsblk.8.gz
share/man/man8/mkswap.8.gz
share/man/man8/partx.8.gz
share/man/man8/swaplabel.8.gz
share/man/man8/wipefs.8.gz
"
