#include <stdlib.h>

#include "dictdplugin.h"

int dictdb_close (void *dict_data);
int dictdb_open (
   const dictPluginData *init_data,
   int init_data_size,
   int *version,
   void ** dict_data);
const char *dictdb_error (void *dict_data);
int dictdb_free (void * dict_data);
int dictdb_search (
   void * dict_data,
   const char * word, int word_size,
   int search_strategy,
   int *ret,
   const dictPluginData **result_extra, int *result_extra_size,
   const char * const* *result,
   const int **result_sizes,
   int *result_count);

int dictdb_open (
    const dictPluginData * init_data,
    int init_data_size,
    int *version,
    void ** dict_data)
{
   if (version)
      *version = 0;

   if (dict_data)
      *dict_data = NULL;

   return 0;
}

const char *dictdb_error (void * dict_data)
{
   return NULL;
}

int dictdb_close (void * dict_data)
{
   return 0;
}

int dictdb_free (void * dict_data)
{
   return 0;
}

int dictdb_search (
   void * dict_data,
   const char * word, int word_size,
   int search_strategy,
   int *ret,
   const dictPluginData **result_extra, int *result_extra_size,
   const char * const* *result,
   const int **result_sizes,
   int *result_count)
{
   if (result)
      *result = NULL;
   if (result_sizes)
      *result_sizes = NULL;
   if (result_count)
      *result_count = 0;

   if (result_extra)
      *result_extra = NULL;
   if (result_extra_size)
      *result_extra_size = 0;

   if (ret)
      *ret = DICT_PLUGIN_RESULT_EXIT;

   return 0;
}
