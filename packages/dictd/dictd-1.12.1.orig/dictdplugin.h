#ifndef _DICTDPLUGIN_H_
#define _DICTDPLUGIN_H_

#undef __BEGIN_DECLS 
#undef __END_DECLS 

#ifdef __cplusplus 
# define __BEGIN_DECLS extern "C" { 
# define __END_DECLS } 
#else 
# define __BEGIN_DECLS
# define __END_DECLS
#endif 


__BEGIN_DECLS

/*
  The following mask is added to the search strategy
  and passed to plugin
  if search type is 'match'
 */
#define DICT_MATCH_MASK 0x8000

/*
  EACH FUNCTION RETURNS ZERO IF SUCCESS
*/

typedef struct dictPluginData {
   int id;           /* DICT_PLUGIN_INITDATA_XXX constant */
   int size;
   const void *data;
} dictPluginData;

typedef struct dictPluginData_strategy {
   int number;
   char name [20];
} dictPluginData_strategy;

/*
  Initializes dictionary and returns zero if success.
 */
typedef int (*dictdb_open_type)
   (
      const dictPluginData *init_data, /* in: data for initializing dictionary */
      int init_data_size, /* in: a number of dictPluginData strctures */
      int *version,       /* out: version of plugin's interface*/
      void ** dict_data   /* out: plugin's global data */
      );

enum {
   DICT_PLUGIN_INITDATA_DICT,     /* data from .dict or configuration file */
   DICT_PLUGIN_INITDATA_DBNAME,   /* database name */
   DICT_PLUGIN_INITDATA_STRATEGY, /* search strategy */
   DICT_PLUGIN_INITDATA_DEFDBDIR, /* default directory for databases */
   DICT_PLUGIN_INITDATA_ALPHABET_8BIT,  /* alphanumeric and space characters for 8bit charset*/
   DICT_PLUGIN_INITDATA_ALPHABET_ASCII, /* alphanumeric and space characters for ASCII*/

   /* this list can be enlarged*/
};

enum {
   DICT_PLUGIN_SETDATA_MATCHESCOUNT,

   /* this list can be enlarged*/
};

/*
 * Returns error message or NULL if last operation returned success.
 */
typedef const char *(*dictdb_error_type) (
   void * dict_data       /* in: plugin's global data */
   );

/*
 * Deinitializes dictionary and returns zero if success.
 * This function MUST ALWAYS BE called after dictdb_init.
 */
typedef int (*dictdb_close_type) (
   void * dict_data       /* in: plugin's global data */
   );

enum {
   /* the requested word has not been found */
   DICT_PLUGIN_RESULT_NOTFOUND,

   /* definitions/matches have been found */
   DICT_PLUGIN_RESULT_FOUND,

   /* don't search any other databases */
   DICT_PLUGIN_RESULT_EXIT,

   /*
     requested word has been preprocessed and the result should be
     used for search in the following databases
   */
   DICT_PLUGIN_RESULT_PREPROCESS,

   /* this list can be enlarged */
};

/*
 * Frees data allocated by dictdb_search
 */
typedef int (*dictdb_free_type) (
   void * dict_data       /* in: plugin's global data */
   );

/*
 *
 */
typedef int (*dictdb_set_type) (
   void * dict_data,      /* in: plugin's global data */
   const dictPluginData *data,
   int data_size
   );

/*
 *
 *
 */
typedef int (*dictdb_search_type) (
   void *dict_data,         /* in: plugin's global data */
   const char *word,        /* in: word */
   int word_size,           /* in: wordsize or -1 for 0-terminated string */
   int search_strategy,     /* in: search strategy */
   int *ret,                /* out: result type - DICT_PLUGIN_RESULT_XXX */
   const dictPluginData **result_extra, /* out: extra information */
   int *result_extra_size,              /* out: extra information size */
   const char * const* *definitions,/* out: definitions */
   const int * *definitions_sizes,  /* out: sizes of definitions */
   int *definitions_count);         /* out: a number of found definitions */

__END_DECLS

#endif /* _DICTDPLUGIN_H_ */
