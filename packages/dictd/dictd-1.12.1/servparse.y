/* servparse.y -- Parser for dictd server configuration file
 * Created: Fri Feb 28 08:31:38 1997 by faith@cs.unc.edu
 * Copyright 1997 Rickard E. Faith (faith@cs.unc.edu)
 * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
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

%{
#include "dictd.h"
#include "strategy.h"
#include "index.h"
#include "data.h"
#include "maa.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE

static dictDatabase *db;

static int string2bool (const char *str)
{
   if (
      !strcasecmp ("1", str)
      || !strcasecmp ("true", str)
      || !strcasecmp ("yes", str))
   {
      return 1;
   }else{
      return 0;
   }
}

#define SET(field,s,t) do {                                   \
   if (db->field)                                             \
      src_parse_error( stderr, s.src, #field "already set" ); \
   db->field = t.string;                                      \
} while(0);
%}

%union {
   dictToken     token;
   dictDatabase  *db;
   dictAccess    *access;
   lst_List      list;
   hsh_HashTable hash;
}

				/* Terminals */

%token <token.integer> TOKEN_NUMBER
%token <token> '{' '}' TOKEN_ACCESS TOKEN_ALLOW TOKEN_DENY 
%token <token> TOKEN_GROUP TOKEN_DATABASE TOKEN_DATA
%token <token> TOKEN_INDEX TOKEN_INDEX_SUFFIX TOKEN_INDEX_WORD
%token <token> TOKEN_FILTER TOKEN_PREFILTER TOKEN_POSTFILTER TOKEN_NAME TOKEN_INFO
%token <token> TOKEN_USER TOKEN_AUTHONLY TOKEN_DATABASE_EXIT

%token <token> TOKEN_SITE TOKEN_SITE_NO_BANNER TOKEN_SITE_NO_UPTIME
%token <token> TOKEN_SITE_NO_DBLIST

%token <token> TOKEN_STRING
%token <token> TOKEN_INVISIBLE TOKEN_DISABLE_STRAT
%token <token> TOKEN_DATABASE_VIRTUAL TOKEN_DATABASE_LIST
%token <token> TOKEN_DATABASE_PLUGIN TOKEN_PLUGIN
%token <token> TOKEN_DATABASE_MIME
%token <token> TOKEN_DEFAULT_STRAT
%token <token> TOKEN_GLOBAL
%token <token> TOKEN_PORT
%token <token> TOKEN_DELAY
%token <token> TOKEN_DEPTH

%token <token> TOKEN_TIMESTAMP
%token <token> TOKEN_LOG_OPTION
%token <token> TOKEN_DEBUG_OPTION
%token <token> TOKEN_LOCALE
%token <token> TOKEN_ADD_STRAT
%token <token> TOKEN_LISTEN_TO
%token <token> TOKEN_SYSLOG
%token <token> TOKEN_SYSLOG_FACILITY
%token <token> TOKEN_LOG_FILE
%token <token> TOKEN_PID_FILE
%token <token> TOKEN_FAST_START
%token <token> TOKEN_WITHOUT_MMAP

%token <token> TOKEN_LIMIT_CHILDS
%token <token> TOKEN_LIMIT_MATCHES
%token <token> TOKEN_LIMIT_DEFS
%token <token> TOKEN_LIMIT_TIME
%token <token> TOKEN_LIMIT_QUERIES

%token <token> TOKEN_MIME_DBNAME
%token <token> TOKEN_NOMIME_DBNAME

%type  <token>  Site
%type  <access> AccessSpec
%type  <db>     Database
%type  <list>   DatabaseList Access AccessSpecList
%type  <hash>   UserList
%type  <token>  Global

%%

Program : Global DatabaseList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    DictConfig->dbl = $2;
	  }
        | Global Access DatabaseList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    DictConfig->acl = $2;
	    DictConfig->dbl = $3;
	  }
        | Global DatabaseList UserList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    DictConfig->dbl = $2;
	    DictConfig->usl = $3;
	  }
        | Global Access DatabaseList UserList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    DictConfig->acl = $2;
	    DictConfig->dbl = $3;
	    DictConfig->usl = $4;
	  }
        | Global Site DatabaseList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    site_info        = $2.string;
	    DictConfig->dbl  = $3;
	  }
        | Global Site Access DatabaseList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    site_info        = $2.string;
	    DictConfig->acl  = $3;
	    DictConfig->dbl  = $4;
	  }
        | Global Site DatabaseList UserList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    site_info        = $2.string;
	    DictConfig->dbl  = $3;
	    DictConfig->usl  = $4;
	  }
        | Global Site Access DatabaseList UserList
          { DictConfig = xmalloc(sizeof(struct dictConfig));
	    memset( DictConfig, 0, sizeof(struct dictConfig) );
	    site_info        = $2.string;
	    DictConfig->acl  = $3;
	    DictConfig->dbl  = $4;
	    DictConfig->usl  = $5;
	  }
        ;


Global : {}
       | TOKEN_GLOBAL '{' GlobalSpecList '}' {}
       ;

GlobalSpecList :
             | GlobalSpecList GlobalSpec
             ;

GlobalSpec : TOKEN_PORT             TOKEN_STRING
     {
	if (!daemon_service_set)
	   daemon_service = str_copy($2.string);
     }
   | TOKEN_SITE             TOKEN_STRING
     {
	if (site_info){
	   /* site is specified twice */
	   xfree ((void *) site_info);
	}

	site_info = $2.string;
     }
   | TOKEN_SITE_NO_BANNER     TOKEN_STRING
     {
	site_info_no_banner = string2bool ($2.string);
	fprintf (stderr, "site_info_no_banner=%d\n", site_info_no_banner);
     }
   | TOKEN_SITE_NO_UPTIME   TOKEN_STRING
     {
	site_info_no_uptime = string2bool ($2.string);
     }
   | TOKEN_SITE_NO_DBLIST  TOKEN_STRING
     {
	site_info_no_dblist = string2bool ($2.string);
     }
   | TOKEN_PORT             TOKEN_NUMBER
     {
	if (!daemon_service_set){
	   char number [40] = "";
	   snprintf (number, sizeof (number), "%d", $2);
	   daemon_service = str_copy (number);
	}
     }
   | TOKEN_DELAY            TOKEN_NUMBER
     {
	if (!client_delay_set)
	   client_delay = $2;

	_dict_daemon_limit_time = 0;
     }
   | TOKEN_DEPTH            TOKEN_NUMBER
     {
	if (!depth_set)
	   depth = $2;
     }
   | TOKEN_LIMIT_CHILDS     TOKEN_NUMBER
     {
	if (!_dict_daemon_limit_childs_set)
	   _dict_daemon_limit_childs = $2;
     }
   | TOKEN_LIMIT_MATCHES    TOKEN_NUMBER
     {
	_dict_daemon_limit_matches = $2;
     }
   | TOKEN_LIMIT_DEFS       TOKEN_NUMBER
     {
	_dict_daemon_limit_defs = $2;
     }
   | TOKEN_LIMIT_TIME       TOKEN_NUMBER
     {
	_dict_daemon_limit_time = $2;
	client_delay            = 0;
     }
   | TOKEN_LIMIT_QUERIES    TOKEN_NUMBER
     {
	_dict_daemon_limit_queries = $2;
     }
   | TOKEN_TIMESTAMP        TOKEN_NUMBER
     {
	if (!_dict_markTime_set)
	   _dict_markTime = 60*$2;
     }
   | TOKEN_LOG_OPTION       TOKEN_STRING
     {
	 ++logOptions;
	 flg_set ($2.string);
	 if (flg_test (LOG_MIN))
	    set_minimal ();
     }
   | TOKEN_DEBUG_OPTION     TOKEN_STRING
     {
	dbg_set ($2.string);
     }
   | TOKEN_LOCALE           TOKEN_STRING
     {
	if (!locale_set)
	   locale = str_copy ($2.string);
     }
   | TOKEN_DEFAULT_STRAT        TOKEN_STRING
     {
	if (!default_strategy_set)
	   default_strategy     = lookup_strategy_ex ($2.string);
     }
   | TOKEN_DISABLE_STRAT    TOKEN_STRING
     {
	dict_disable_strategies ($2.string);
     }
   | TOKEN_ADD_STRAT        TOKEN_STRING TOKEN_STRING
     {
	dict_add_strategy ($2.string, $3.string);
     }
   | TOKEN_LISTEN_TO        TOKEN_STRING
     {
	if (!bind_to_set)
	   bind_to = str_copy ($2.string);
     }
   | TOKEN_SYSLOG
     {
	++useSyslog;
     }
   | TOKEN_SYSLOG_FACILITY  TOKEN_STRING
     {
	++useSyslog;
	if (!syslog_facility_set){
	   log_set_facility ($2.string);
	}
     }
   | TOKEN_LOG_FILE         TOKEN_STRING
     {
	if (!logFile_set){
	   logFile     = str_copy ($2.string);
	}
     }
   | TOKEN_PID_FILE         TOKEN_STRING
     {
	if (!pidFile_set){
	   pidFile     = str_copy ($2.string);
	}
     }
   | TOKEN_FAST_START
     {
	optStart_mode = 0;
     }
   | TOKEN_WITHOUT_MMAP
     {
	mmap_mode = 0;
     }
;

Access : TOKEN_ACCESS '{' AccessSpecList '}' { $$ = $3; }
       ;

DatabaseList : Database { $$ = lst_create(); lst_append($$, $1); }
             | DatabaseList Database { lst_append($1, $2); $$ = $1; }
             ;

AccessSpecList : AccessSpec { $$ = lst_create(); lst_append($$, $1); }
               | AccessSpecList AccessSpec { lst_append($1, $2); $$ = $1; }
               ;

Site : TOKEN_SITE TOKEN_STRING
       {
	  $$ = $2;
	  log_error (NULL, ":E: Move \"site\" directive to section \"global\" of the configuration file!");
       }
     ;

UserList : TOKEN_USER TOKEN_STRING TOKEN_STRING
           { $$ = hsh_create(NULL,NULL);
	     hsh_insert( $$, $2.string, $3.string );
	   }
         | UserList TOKEN_USER TOKEN_STRING TOKEN_STRING
           { hsh_insert( $1, $3.string, $4.string ); $$ = $1; }
         ;

AccessSpec : TOKEN_ALLOW TOKEN_STRING
             {
		dictAccess *a = xmalloc(sizeof(struct dictAccess));
		a->type = DICT_ALLOW;
		a->spec = $2.string;
		$$ = a;
	     }
           | TOKEN_DENY TOKEN_STRING
             {
		dictAccess *a = xmalloc(sizeof(struct dictAccess));
		a->type = DICT_DENY;
		a->spec = $2.string;
		$$ = a;
	     }
           | TOKEN_AUTHONLY TOKEN_STRING
             {
		dictAccess *a = xmalloc(sizeof(struct dictAccess));
		a->type = DICT_AUTHONLY;
		a->spec = $2.string;
		$$ = a;
	     }
           | TOKEN_USER TOKEN_STRING
             {
		dictAccess *a = xmalloc(sizeof(struct dictAccess));
		a->type = DICT_USER;
		a->spec = $2.string;
		$$ = a;
	     }
           ;

Database : TOKEN_DATABASE TOKEN_STRING
           {
	      db = xmalloc(sizeof(struct dictDatabase));
	      memset( db, 0, sizeof(struct dictDatabase));
	      db->databaseName = $2.string;
	      db->normal_db    = 1;
	   }
           '{' SpecList '}' { $$ = db; }
           |
           TOKEN_DATABASE_VIRTUAL TOKEN_STRING
           {
	      db = xmalloc(sizeof(struct dictDatabase));
	      memset( db, 0, sizeof(struct dictDatabase));
	      db->databaseName = $2.string;
	      db->virtual_db   = 1;
	   }
           '{' SpecList_virtual '}' { $$ = db; }
           |
           TOKEN_DATABASE_PLUGIN TOKEN_STRING
           {
	      db = xmalloc(sizeof(struct dictDatabase));
	      memset( db, 0, sizeof(struct dictDatabase));
	      db->databaseName = $2.string;
	      db->plugin_db    = 1;
	   }
           '{' SpecList_plugin '}' { $$ = db; }
           |
           TOKEN_DATABASE_MIME TOKEN_STRING
	   {
	      db = xmalloc (sizeof (struct dictDatabase));
	      memset (db, 0, sizeof (struct dictDatabase));
	      db->databaseName = $2.string;
	      db->mime_db      = 1;
	   }
           '{' SpecList_mime '}' { $$ = db; }
           |
	   TOKEN_DATABASE_EXIT
	   {
	      db = xmalloc(sizeof(struct dictDatabase));
	      memset( db, 0, sizeof(struct dictDatabase));
	      db -> databaseName  = strdup("--exit--");
	      db -> databaseShort = strdup("Stop default search here.");
	      db -> exit_db       = 1;
	      $$ = db;
	   }
         ;

SpecList_virtual : Spec_virtual
         | SpecList_virtual Spec_virtual
         ;

Spec_virtual : Spec__name
     | Spec__info
     | TOKEN_DATABASE_LIST TOKEN_STRING      { SET(database_list,$1,$2);}
     | Spec__invisible
     | Spec__disable_strat
     | Spec__access
     ;

SpecList_plugin : Spec_plugin
         | SpecList_plugin Spec_plugin
         ;

SpecList_mime : Spec_mime
         | SpecList_mime Spec_mime
         ;

Spec_mime : Spec__name
     | Spec__info
     | Spec__dbname_mime
     | Spec__dbname_nomime
     | Spec__invisible
     | Spec__disable_strat
     | Spec__default_strat
     | Spec__access
     ;

Spec_plugin : Spec__name
     | Spec__info
     | TOKEN_PLUGIN TOKEN_STRING      { SET(pluginFilename,$1,$2);}
     | TOKEN_DATA TOKEN_STRING        { SET(plugin_data,$1,$2);}
     | Spec__invisible
     | Spec__disable_strat
     | Spec__default_strat
     | Spec__access
     ;

SpecList : Spec
         | SpecList Spec
         ;

Spec : Spec__data
     | Spec__index
     | Spec__index_suffix
     | Spec__index_word
     | Spec__filter
     | Spec__prefilter
     | Spec__postfilter
     | Spec__name
     | Spec__info
     | Spec__invisible
     | Spec__disable_strat
     | Spec__default_strat
     | Spec__access
     ;

Spec__access : Access
     {  db->acl = $1;  };

Spec__data : TOKEN_DATA TOKEN_STRING
     {	SET(dataFilename,$1,$2);  };

Spec__index : TOKEN_INDEX TOKEN_STRING
     {  SET(indexFilename,$1,$2);  };

Spec__index_suffix : TOKEN_INDEX_SUFFIX TOKEN_STRING
     {  SET(indexsuffixFilename,$1,$2); };

Spec__index_word : TOKEN_INDEX_WORD TOKEN_STRING
     {  SET(indexwordFilename,$1,$2);  };

Spec__filter : TOKEN_FILTER TOKEN_STRING
     {  SET(filter,$1,$2);  };

Spec__prefilter : TOKEN_PREFILTER TOKEN_STRING
     {  SET(prefilter,$1,$2);  };

Spec__postfilter : TOKEN_POSTFILTER TOKEN_STRING
     {  SET(postfilter,$1,$2);  };

Spec__name : TOKEN_NAME TOKEN_STRING
     {  SET(databaseShort,$1,$2);  };

Spec__info : TOKEN_INFO TOKEN_STRING
     {  SET(databaseInfo,$1,$2);  };

Spec__invisible : TOKEN_INVISIBLE 
     {  db->invisible = 1;  };

Spec__disable_strat : TOKEN_DISABLE_STRAT TOKEN_STRING
     {  dict_disable_strat (db, $2.string);  };

Spec__default_strat : TOKEN_DEFAULT_STRAT TOKEN_STRING
     {  db -> default_strategy = lookup_strategy_ex ($2.string);  };

Spec__dbname_mime : TOKEN_MIME_DBNAME TOKEN_STRING
     {  SET(mime_mimeDbname,$1,$2);  };

Spec__dbname_nomime : TOKEN_NOMIME_DBNAME TOKEN_STRING 
     {  SET(mime_nomimeDbname,$1,$2);  };
