// SPDX-License-Identifier: MIT

#define _GNU_SOURCE
#include <stdint.h>
#include <sys/stat.h>

struct ncdu_stat {
    uint64_t dev, ino, nlink, blocks;
    int64_t size, mtime;
    uint32_t mode, uid, gid;
};

int ncdu_fstatat(int dirfd, const char *path, int flags, struct ncdu_stat *out) {
    struct stat st;
    if (fstatat(dirfd, path, &st, flags) != 0) return -1;
    out->dev = st.st_dev;
    out->ino = st.st_ino;
    out->nlink = st.st_nlink;
    out->blocks = st.st_blocks;
    out->size = st.st_size;
    out->mtime = st.st_mtim.tv_sec;
    out->mode = st.st_mode;
    out->uid = st.st_uid;
    out->gid = st.st_gid;
    return 0;
}
