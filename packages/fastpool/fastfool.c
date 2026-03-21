#include "fastpool.h"
#include <stdlib.h>
#include <string.h>

static void fp_grow(FastPool *fp) {
    size_t new_cap = fp->capacity * 2;
    FPNode *new_pool = realloc(fp->pool, new_cap * sizeof(FPNode));

    if (!new_pool) return;

    fp->pool = new_pool;
    fp->capacity = new_cap;
}

void fp_init(FastPool *fp, size_t initial_size) {
    fp->pool = calloc(initial_size, sizeof(FPNode));
    fp->capacity = initial_size;
    fp->size = 0;
    fp->tick = 0;
}

static int find_lru(FastPool *fp) {
    unsigned long min = (unsigned long)-1;
    int idx = -1;

    for (size_t i = 0; i < fp->capacity; i++) {
        if (fp->pool[i].used && fp->pool[i].last_used < min) {
            min = fp->pool[i].last_used;
            idx = i;
        }
    }

    return idx;
}

int fp_alloc(FastPool *fp, int data) {
    fp->tick++;

    // 1. 빈 공간 찾기
    for (size_t i = 0; i < fp->capacity; i++) {
        if (!fp->pool[i].used) {
            fp->pool[i].used = 1;
            fp->pool[i].data = data;
            fp->pool[i].last_used = fp->tick;
            return (int)i;
        }
    }

    // 2. full → LRU eviction
    int lru = find_lru(fp);

    if (lru == -1) {
        fp_grow(fp);
        return fp_alloc(fp, data);
    }

    fp->pool[lru].data = data;
    fp->pool[lru].last_used = fp->tick;
    return lru;
}

FPNode* fp_get(FastPool *fp, int index) {
    if (index < 0 || (size_t)index >= fp->capacity) return NULL;
    if (!fp->pool[index].used) return NULL;

    return &fp->pool[index];
}

void fp_touch(FastPool *fp, int index) {
    if (index < 0 || (size_t)index >= fp->capacity) return;
    fp->pool[index].last_used = ++fp->tick;
}

void fp_free(FastPool *fp, int index) {
    if (index < 0 || (size_t)index >= fp->capacity) return;
    fp->pool[index].used = 0;
}

void fp_destroy(FastPool *fp) {
    free(fp->pool);
    fp->pool = NULL;
    fp->capacity = 0;
    fp->size = 0;
}
