#ifndef FASTPOOL_H
#define FASTPOOL_H

#include <stddef.h>

typedef struct {
    int data;
    unsigned long last_used;
    int used;
} FPNode;

typedef struct {
    FPNode *pool;
    size_t capacity;
    size_t size;
    unsigned long tick;
} FastPool;

// init
void fp_init(FastPool *fp, size_t initial_size);

// alloc (index 반환)
int fp_alloc(FastPool *fp, int data);

// get
FPNode* fp_get(FastPool *fp, int index);

// touch (사용 갱신)
void fp_touch(FastPool *fp, int index);

// free (논리 삭제)
void fp_free(FastPool *fp, int index);

// cleanup
void fp_destroy(FastPool *fp);

#endif
