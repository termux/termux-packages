/* defs.h -- 
 * Created: Sat Mar 15 17:27:23 2003 by Aleksey Cheusov <vle@gmx.net>
 * Copyright 1994-2003 Rickard E. Faith (faith@dict.org)
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 1, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef _DEFS_H_
#define _DEFS_H_

#include "dictP.h"
#include "dictdplugin.h"

#include <zlib.h>
#include <maa.h>

				/* Configurable things */

#define DICT_DEFAULT_SERVICE     "2628"	/* Also in dict.h */
#define DICTD_CONFIG_NAME        "dictd.conf"
#define DICT_QUEUE_DEPTH         10
#define DICT_DAEMON_LIMIT_CHILDS   100 /* maximum simultaneous daemons */
#define DICT_DAEMON_LIMIT_MATCHES  2000 /* maximum number of matches */
#define DICT_DAEMON_LIMIT_DEFS     200  /* maximum number of definitions */
#define DICT_DAEMON_LIMIT_TIME     600  /* maximum seconds per client */
#define DICT_DAEMON_LIMIT_QUERIES  2000 /* maximum queries per client */

#define DICT_DEFAULT_DELAY         0 /* 'limit_time' in work by default */
#define DICT_PERSISTENT_PRESTART 3 /* not implemented */
#define DICT_PERSISTENT_LIMIT    5 /* not implemented */

#define DICT_ENTRY_PREFIX        "00-database"
#define DICT_ENTRY_PREFIX_LEN    sizeof(DICT_ENTRY_PREFIX)-1
#define DICT_SHORT_ENTRY_NAME    DICT_ENTRY_PREFIX"-short"
#define DICT_LONG_ENTRY_NAME     DICT_ENTRY_PREFIX"-long"
#define DICT_INFO_ENTRY_NAME     DICT_ENTRY_PREFIX"-info"

#define DICT_FLAG_UTF8           DICT_ENTRY_PREFIX"-utf8"
#define DICT_FLAG_8BIT_NEW       DICT_ENTRY_PREFIX"-8bit-new"
#define DICT_FLAG_8BIT_OLD       DICT_ENTRY_PREFIX"-8bit"
#define DICT_FLAG_ALLCHARS       DICT_ENTRY_PREFIX"-allchars"
#define DICT_FLAG_CASESENSITIVE  DICT_ENTRY_PREFIX"-case-sensitive"
#define DICT_FLAG_VIRTUAL        DICT_ENTRY_PREFIX"-virtual"
#define DICT_FLAG_ALPHABET       DICT_ENTRY_PREFIX"-alphabet"
#define DICT_FLAG_DEFAULT_STRAT  DICT_ENTRY_PREFIX"-default-strategy"
#define DICT_FLAG_MIME_HEADER    DICT_ENTRY_PREFIX"-mime-header"

#define DICT_ENTRY_PLUGIN        DICT_ENTRY_PREFIX"-plugin"
#define DICT_ENTRY_PLUGIN_DATA   DICT_ENTRY_PREFIX"-plugin-data"

#define DICT_PLUGINFUN_OPEN      "dictdb_open"
#define DICT_PLUGINFUN_ERROR     "dictdb_error"
#define DICT_PLUGINFUN_FREE      "dictdb_free"
#define DICT_PLUGINFUN_SEARCH    "dictdb_search"
#define DICT_PLUGINFUN_CLOSE     "dictdb_close"
#define DICT_PLUGINFUN_SET       "dictdb_set"

				/* End of configurable things */

#define BUFFERSIZE 10240

#define DBG_VERBOSE     (0<<30|1<< 0) /* Verbose                            */
#define DBG_ZIP         (0<<30|1<< 1) /* Zip                                */
#define DBG_UNZIP       (0<<30|1<< 2) /* Unzip                              */
#define DBG_SEARCH      (0<<30|1<< 3) /* Search                             */
#define DBG_SCAN        (0<<30|1<< 4) /* Config file scan                   */
#define DBG_PARSE       (0<<30|1<< 5) /* Config file parse                  */
#define DBG_INIT        (0<<30|1<< 6) /* Database initialization            */
#define DBG_PORT        (0<<30|1<< 7) /* Log port number for connections    */
#define DBG_LEV         (0<<30|1<< 8) /* Levenshtein matching               */
#define DBG_AUTH        (0<<30|1<< 9) /* Debug authentication               */
#define DBG_NODETACH    (0<<30|1<<10) /* Don't detach as a background proc. */
#define DBG_NOFORK      (0<<30|1<<11) /* Don't fork (single threaded)       */
#define DBG_ALT         (0<<30|1<<12) /* altcompare()                      */

#define LOG_SERVER      (0<<30|1<< 0) /* Log server diagnostics             */
#define LOG_CONNECT     (0<<30|1<< 1) /* Log connection information         */
#define LOG_STATS       (0<<30|1<< 2) /* Log termination information        */
#define LOG_COMMAND     (0<<30|1<< 3) /* Log commands                       */
#define LOG_FOUND       (0<<30|1<< 4) /* Log words found                    */
#define LOG_NOTFOUND    (0<<30|1<< 5) /* Log words not found                */
#define LOG_CLIENT      (0<<30|1<< 6) /* Log client                         */
#define LOG_HOST        (0<<30|1<< 7) /* Log remote host name               */
#define LOG_TIMESTAMP   (0<<30|1<< 8) /* Log with timestamps                */
#define LOG_MIN         (0<<30|1<< 9) /* Log a few minimal things           */
#define LOG_AUTH        (0<<30|1<<10) /* Log authentication denials         */

#define DICT_LOG_TERM    0
#define DICT_LOG_DEFINE  1
#define DICT_LOG_MATCH   2
#define DICT_LOG_NOMATCH 3
#define DICT_LOG_CLIENT  4
#define DICT_LOG_TRACE   5
#define DICT_LOG_COMMAND 6
#define DICT_LOG_AUTH    7
#define DICT_LOG_CONNECT 8

#define DICT_UNKNOWN    0
#define DICT_TEXT       1
#define DICT_GZIP       2
#define DICT_DZIP       3

#define DICT_CACHE_SIZE 5

typedef struct dictCache {
   int           chunk;
   char          *inBuffer;
   int           stamp;
   int           count;
} dictCache;

typedef struct dictData {
   int           fd;		/* file descriptor */
   const char    *start;	/* start of mmap'd area */
   const char    *end;		/* end of mmap'd area */
   unsigned long size;		/* size of mmap */
   
   int           type;
   const char    *filename;
   z_stream      zStream;
   int           initialized;

   int           headerLength;
   int           method;
   int           flags;
   time_t        mtime;
   int           extraFlags;
   int           os;
   int           version;
   int           chunkLength;
   int           chunkCount;
   int           *chunks;
   unsigned long *offsets;	/* Sum-scan of chunks. */
   const char    *origFilename;
   const char    *comment;
   unsigned long crc;
   unsigned long length;
   unsigned long compressedLength;
   dictCache     cache[DICT_CACHE_SIZE];
} dictData;

typedef struct dictPlugin {
   void *      data;

#ifdef USE_PLUGIN
   lt_dlhandle handle;

   dictdb_open_type   dictdb_open;
   dictdb_set_type    dictdb_set;
   dictdb_search_type dictdb_search;
   dictdb_free_type   dictdb_free;
   dictdb_error_type  dictdb_error;
   dictdb_close_type  dictdb_close;

   char dictdb_free_called; /* 1 after dictdb_free call */
#endif
} dictPlugin;

typedef struct dictIndex {
   int           fd;		 /* file descriptor */
   const char    *start;	 /* start of mmap'd area */
   const char    *end;		 /* end of mmap'd area */
   unsigned long size;		 /* size of mmap */
   const char    *optStart[UCHAR_MAX+2]; /* Optimized starting points */
   unsigned long headwords;	 /* computed number of headwords */

   int    flag_utf8;         /* not zero if it has 00-database-utf8 entry*/
   int    flag_8bit;         /* not zero if it has 00-database-8bit-new entry*/
   int    flag_allchars;     /* not zero if it has 00-database-allchars entry*/
   int    flag_casesensitive;/* not zero if it has 00-database-case-sensitive entry*/

   const int     *isspacealnum;
} dictIndex;

typedef struct dictDatabase {
   const char *databaseName;
   const char *databaseShort;
   const char *databaseInfo;
   const char *dataFilename;
   const char *indexFilename;
   const char *indexsuffixFilename;
   const char *indexwordFilename;
   const char *filter;
   const char *prefilter;
   const char *postfilter;
   lst_List   acl;
   int        available;	/* if user has authenticated for database */

   dictData   *data;
   dictIndex  *index;
   dictIndex  *index_suffix;
   dictIndex  *index_word;

   int        *strategy_disabled; /* disable_strategy keyword*/

   lst_List   *virtual_db_list;

   char *alphabet;

   int invisible;    /* non-zero for invisible databases */

   int exit_db;      /* non-zero for dictionary_exit entry */
   int virtual_db;   /* non-zero for virtual databases */
   int plugin_db;    /* non-zero for plugin entry */
   int normal_db;    /* non-zero for normal database */
   int mime_db;      /* non-zero for MIME database */

   int default_strategy;    /* default search strategy for `.' */

   const char *mime_header; /* MIME header for OPTION MIME command */

   /* database_virtual members */
   const char *database_list;  /* comma-separated list of database names */

   /* database_plugin members */
   const char *pluginFilename;
   const char *plugin_data;    /* data for initializing plugin */
   dictPlugin *plugin;

   /* database_mime members */
   const char *mime_mimeDbname;
   const char *mime_nomimeDbname;

   struct dictDatabase *mime_mimeDB;
   struct dictDatabase *mime_nomimeDB;
} dictDatabase;

#define DICT_DENY     0
#define DICT_ALLOW    1
#define DICT_AUTHONLY 2
#define DICT_USER     3
#define DICT_GROUP    4		/* Not implemented */
#define DICT_MATCH    5         /* For IP matching routines */
#define DICT_NOMATCH  6         /* For IP matching routines */

typedef struct dictAccess {
   int        type;		/* deny, allow, accessonly, user, group */
   const char *spec;
} dictAccess;

typedef struct dictConfig {
   lst_List      acl;		/* type dictAccess */
   lst_List      dbl;		/* type dictDatabase */
   hsh_HashTable usl;		/* username/shared-secret list */
} dictConfig;

typedef struct dictWord {
   const dictDatabase  *database;
   const dictDatabase  *database_visible;

   char    *word;

   unsigned long start;
   unsigned long end;

/* Used by plugins */
   const char    *def;
   int            def_size;
} dictWord;

typedef struct dictToken {
   const char   *string;
   int          integer;
   src_Type     src;
} dictToken;

#endif /* _DEFS_H_ */
