/* This file is a port of posix named semaphore for Termux Android, 
   based on musl-libc which is licensed under the standard MIT license. 
   The ported files are listed as following.

   File(s): src/thread/sem_open.c
            src/thread/sem_unlink.c

   Copyright © 2005-2020 Rich Felker, et al.

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <semaphore.h> // sem_t, sem_init()
#include <sys/mman.h>  // mmap(), munmap()
#include <limits.h>    // SEM_NSEMS_MAX, NAME_MAX, INT_MAX
#include <fcntl.h>     // open()
#include <unistd.h>    // write(), close(), unlink()
#include <string.h>    // strlen(), memcpy()
#include <stdarg.h>    // va_arg
#include <errno.h>     // errno
#include <sys/stat.h>  // fstat()
#include <stdlib.h>    // calloc()
#include <pthread.h>   // mutex
#include <paths.h>     // _PATH_TMP

#ifndef SEM_NSEMS_MAX
#define SEM_NSEMS_MAX 256
#endif // !SEM_NSEMS_MAX

#define SEM_PREFIX _PATH_TMP "sem."

static __inline__ char *__strchrnul(const char *s, int c)
{
    c = (unsigned char)c;
    if (!c) return (char *)s + strlen(s);
    for (; *s && *(unsigned char *)s != c; s++);
    return (char *)s;
}

typedef struct {
    ino_t ino;
    sem_t *sem;
    int refcnt;
} semtab_type;

static semtab_type *semtab;
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

#define LOCK(l) (pthread_mutex_lock(&l))
#define UNLOCK(l) (pthread_mutex_unlock(&l))

#define FLAGS (O_RDWR|O_NOFOLLOW|O_CLOEXEC|O_NONBLOCK)

static char *__sem_mapname(const char *name, char *buf)
{
    char *p;
    while (*name == '/') name++;
    if (*(p = __strchrnul(name, '/')) || p==name ||
        (p-name <= 2 && name[0]=='.' && p[-1]=='.')) {
        errno = EINVAL;
        return 0;
    }
    if (p-name > NAME_MAX-4) {
        errno = ENAMETOOLONG;
        return 0;
    }
    memcpy(buf, SEM_PREFIX, strlen(SEM_PREFIX));
    memcpy(buf+strlen(SEM_PREFIX), name, p-name+1);
    return buf;
}

sem_t *sem_open(const char *name, int flags, ...)
{
    va_list ap;
    mode_t mode;
    unsigned value;
    int fd, i, slot, cnt;
    sem_t newsem;
    void *map;
    struct stat st;
    char buf[NAME_MAX+strlen(SEM_PREFIX)+1];

    if (!(name = __sem_mapname(name, buf)))
        return SEM_FAILED;

    LOCK(lock);
    /* Allocate table if we don't have one yet */
    if (!semtab && !(semtab = (semtab_type *)(calloc(SEM_NSEMS_MAX, sizeof *semtab)))) {
        UNLOCK(lock);
        return SEM_FAILED;
    }

    /* Reserve a slot in case this semaphore is not mapped yet;
     * this is necessary because there is no way to handle
     * failures after creation of the file. */
    slot = -1;
    for (cnt=i=0; i<SEM_NSEMS_MAX; i++) {
        cnt += semtab[i].refcnt;
        if (!semtab[i].sem && slot < 0) slot = i;
    }
    /* Avoid possibility of overflow later */
    if (cnt == INT_MAX || slot < 0) {
        errno = EMFILE;
        UNLOCK(lock);
        return SEM_FAILED;
    }

    /* Dummy pointer to make a reservation */
    semtab[slot].sem = (sem_t *)-1;
    UNLOCK(lock);
    
    /* Only O_CREAT and O_EXCL are useful */
    flags &= (O_CREAT|O_EXCL);

    /* Get a file descriptor. */
    switch (flags) {
    case 0:
        /* There is no flag specified in oflag. Just open the existing semaphore.  
         * If a semaphore with the given name doesn't exist, return an error. */
        {
            if ((fd = open(name, FLAGS)) < 0) {
                goto fail;
            }
        }
        break;
    case O_CREAT:
        /* If only O_CREAT is specified in oflag, then the semaphore is 
         * created if it does not already exist. If a semaphore with the
         * given name already exists, then mode and value are ignored. */
        {
            /* Try to access and open this file. */
            if (access(name, F_OK) == 0) {
                if ((fd = open(name, FLAGS)) < 0) {
                    goto fail;
                }
                break;
            }
            /* Fall back to creation. */
        }
    case O_CREAT|O_EXCL:
        /* If both O_CREAT and O_EXCL are specified in oflag, then an error
         * is returned if a semaphore with the given name already exists. */
        {
            /* Initialize a semaphore. */
            va_start(ap, flags);
            mode = va_arg(ap, mode_t) & 0666;
            value = va_arg(ap, unsigned);
            va_end(ap);
            if (sem_init(&newsem, 1, value) < 0) goto fail;
            /* Create a new file. */
            fd = open(name, (O_CREAT|O_EXCL)|FLAGS, mode);
            if (fd < 0) goto fail;
            /* Write the semaphore to the file. */
            if (write(fd, &newsem, sizeof newsem) != sizeof newsem) {
                close(fd);
                unlink(name);
                goto fail;
            }
        }
        break;
    case O_EXCL:
        /* In general, the behavior of O_EXCL is undefined if it is
         * used without O_CREAT. So just make it an error. */
    default:
        // Should never get here.
        errno = EINVAL;
        goto fail;
    }
    
    /* Do fstat and mmap. */
    if (fstat(fd, &st) < 0 || (map = mmap(0, sizeof(sem_t), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0)) == MAP_FAILED) {
        close(fd);
        unlink(name);
        goto fail;
    }

    /* Close the file descriptor. */
    close(fd);

    /* See if the newly mapped semaphore is already mapped. If
     * so, unmap the new mapping and use the existing one. Otherwise,
     * add it to the table of mapped semaphores. */
    LOCK(lock);
    for (i=0; i<SEM_NSEMS_MAX && semtab[i].ino != st.st_ino; i++);
    if (i<SEM_NSEMS_MAX) {
        munmap(map, sizeof(sem_t));
        semtab[slot].sem = 0;
        slot = i;
        map = semtab[i].sem;
    }
    semtab[slot].refcnt++;
    semtab[slot].sem = (sem_t *)(map);
    semtab[slot].ino = st.st_ino;
    UNLOCK(lock);
    return (sem_t *)(map);

fail:
    LOCK(lock);
    /* Recovery the unused reservation. */
    semtab[slot].sem = 0;
    UNLOCK(lock);
    return SEM_FAILED;
}

int sem_close(sem_t *sem)
{
    if (sem == NULL || semtab == NULL) {
        errno = EINVAL;
        return -1;
    }
    int i;
    LOCK(lock);
    for (i=0; i<SEM_NSEMS_MAX && semtab[i].sem != sem; i++);
    if (i == SEM_NSEMS_MAX) {
        UNLOCK(lock);
        errno = EINVAL;
        return -1;
    }
    if (--semtab[i].refcnt) {
        UNLOCK(lock);
        return 0;
    }
    semtab[i].sem = 0;
    semtab[i].ino = 0;
    UNLOCK(lock);
    munmap(sem, sizeof *sem);
    return 0;
}

int sem_unlink(const char *name)
{
    char buf[NAME_MAX+strlen(SEM_PREFIX)+1];
    if (!(name = __sem_mapname(name, buf))) return -1;
    return unlink(name);
}

/* Make alias for use with e.g. dlopen() */
#undef sem_open
sem_t *sem_open(const char *name, int flags, ...) __attribute__((alias("libandroid_sem_open")));
#undef sem_close
int sem_close(sem_t *sem) __attribute__((alias("libandroid_sem_close")));
#undef sem_unlink
int sem_unlink(const char *name) __attribute__((alias("libandroid_sem_unlink")));
