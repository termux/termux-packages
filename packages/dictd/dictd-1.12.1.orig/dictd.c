/* dictd.c -- 
 * Created: Fri Feb 21 20:09:09 1997 by faith@dict.org
 * Copyright 1997-2000, 2002 Rickard E. Faith (faith@dict.org)
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

#include "dictd.h"
#include "str.h"

#include "servparse.h"
#include "strategy.h"
#include "index.h"
#include "data.h"
#include "parse.h"

#ifdef USE_PLUGIN
#include "plugin.h"
#endif

#include <grp.h>                /* initgroups */
#include <pwd.h>                /* getpwuid */
#include <locale.h>             /* setlocale */
#include <ctype.h>
#include <sys/stat.h>
#include <fcntl.h>

#define MAXPROCTITLE 2048       /* Maximum amount of proc title we'll use. */
#undef MIN
#define MIN(a,b) ((a)<(b)?(a):(b))
#ifndef UID_NOBODY
#define UID_NOBODY  65534
#endif
#ifndef GID_NOGROUP
#define GID_NOGROUP 65534
#endif

#ifndef SA_RESTART
/* ... and hope for the best */
#define SA_RESTART 0
#endif



extern int        yy_flex_debug;

static int        _dict_daemon;
static int        _dict_reaps;

static char      *_dict_argvstart;
static int        _dict_argvlen;

       int        _dict_forks;



int default_strategy_set; /* 1 if set by command line option */


int                logOptions   = 0;

const char         *logFile     = NULL;
int logFile_set; /* 1 if set by command line option */

const char *pidFile     = "/var/run/dictd.pid";
int pidFile_set; /* 1 if set by command line option */

const char         *daemon_service     = DICT_DEFAULT_SERVICE;
int daemon_service_set; /* 1 if set by command line option */

int _dict_daemon_limit_childs   = DICT_DAEMON_LIMIT_CHILDS;
int _dict_daemon_limit_childs_set; /* 1 if set by command line option */

int        _dict_daemon_limit_matches  = DICT_DAEMON_LIMIT_MATCHES;
int        _dict_daemon_limit_defs     = DICT_DAEMON_LIMIT_DEFS;
int        _dict_daemon_limit_time     = DICT_DAEMON_LIMIT_TIME;
int        _dict_daemon_limit_queries  = DICT_DAEMON_LIMIT_QUERIES;

int        _dict_markTime = 0;
int _dict_markTime_set; /* 1 if set by command line option */

const char        *locale       = NULL;
int locale_set; /* 1 if set by command line option */

int         client_delay        = DICT_DEFAULT_DELAY;
int client_delay_set; /* 1 if set by command line option */

int                depth        = DICT_QUEUE_DEPTH;
int depth_set; /* 1 if set by command line option */

int                useSyslog    = 0;
int syslog_facility_set; /* 1 if set by command line option */

const char        *preprocessor = NULL;

const char        *bind_to      = NULL;
int bind_to_set; /* 1 if set by command line option */

/* information about dict server, i.e.
   text returned by SHOW SERVER command
*/
const char        *site_info           = NULL;
int                site_info_no_banner = 0;
int                site_info_no_uptime = 0;
int                site_info_no_dblist = 0;




int                inetd        = 0;

int                need_reload_config    = 0;

int                need_unload_databases = 0;
int                databases_unloaded    = 0;

static const char *configFile  = DICT_CONFIG_PATH DICTD_CONFIG_NAME;

static void dict_close_databases (dictConfig *c);
static void sanity (const char *confFile);
static void dict_init_databases (dictConfig *c);
static void dict_config_print (FILE *stream, dictConfig *c);
static void postprocess_filenames (dictConfig *dc);

void dict_initsetproctitle( int argc, char **argv, char **envp )
{
   int i;

   _dict_argvstart = argv[0];
   
   for (i = 0; envp[i]; i++) continue;

   if (i)
      _dict_argvlen = envp[i-1] + strlen(envp[i-1]) - _dict_argvstart;
   else
      _dict_argvlen = argv[argc-1] + strlen(argv[argc-1]) - _dict_argvstart;

   argv[1] = NULL;
}

void dict_setproctitle( const char *format, ... )
{
   va_list ap;
   int     len;
   char    buf[MAXPROCTITLE];

   va_start( ap, format );
   vsnprintf( buf, MAXPROCTITLE, format, ap );
   va_end( ap );

   if ((len = strlen(buf)) > MAXPROCTITLE-1)
      err_fatal( __func__, "buffer overflow (%d)\n", len );

   buf[ MIN(_dict_argvlen,MAXPROCTITLE) - 1 ] = '\0';
   strcpy( _dict_argvstart, buf );
   memset( _dict_argvstart+len, 0, _dict_argvlen-len );
}

const char *dict_format_time( double t )
{
   static int  current = 0;
   static char buf[10][128];	/* Rotate 10 buffers */
   static char *this;
   long int    s, m, h, d;

   this = buf[current];
   if (++current >= 10) current = 0;

   if (t < 600) {
      snprintf( this, sizeof (buf [0]), "%0.3f", t );
   } else {
      s = (long int)t;
      d = s / (3600*24);
      s -= d * 3600 * 24;
      h = s / 3600;
      s -= h * 3600;
      m = s / 60;
      s -= m * 60;

      if (d)
	 snprintf( this, sizeof (buf [0]), "%ld+%02ld:%02ld:%02ld", d, h, m, s );
      else if (h)
	 snprintf( this, sizeof (buf [0]), "%02ld:%02ld:%02ld", h, m, s );
      else
	 snprintf( this, sizeof (buf [0]), "%02ld:%02ld", m, s );
   }

   return this;
}

static int waitpid__exit_status (int status)
{
   if (WIFEXITED(status)){
      return WEXITSTATUS(status);
   }else if (WIFSIGNALED(status)){
      return 128 + WTERMSIG(status);
   }else{
      return -1;
   }
}

static void reaper( int dummy )
{
#if 0
   union wait status;
#else
   int        status;
#endif
   pid_t      pid;

   while ((pid = wait3(&status, WNOHANG, NULL)) > 0) {
      ++_dict_reaps;

      if (flg_test(LOG_SERVER))
         log_info( ":I: Reaped %d%s, exit status %i\n",
                   pid,
                   _dict_daemon ? " IN CHILD": "",
		   waitpid__exit_status (status));
   }
}

static int start_daemon( void )
{
   pid_t pid;
   
   ++_dict_forks;
   switch ((pid = fork())) {
   case 0:
      ++_dict_daemon;
      break;
   case -1:
      log_info( ":E: Unable to fork daemon\n" );
      alarm(10);		/* Can't use sleep() here */
      pause();
      break;
   default:
      if (flg_test(LOG_SERVER)) log_info( ":I: Forked %d\n", pid );
      break;
   }
   return pid;
}

static const char * signal2name (int sig)
{
   static char name [50];

   switch (sig) {
   case SIGHUP:
      return "SIGHUP";
   case SIGINT:
      return "SIGINT";
   case SIGQUIT:
      return "SIGQUIT";
   case SIGILL:
      return "SIGILL";
   case SIGTRAP:
      return "SIGTRAP";
   case SIGTERM:
      return "SIGTERM";
   case SIGPIPE:
      return "SIGPIPE";
   case SIGALRM:
      return "SIGALRM";
   default:
      snprintf (name, sizeof (name), "Signal %d", sig);
      return name;
   }
}

static void log_sig_info (int sig)
{
   log_info (
      ":I: %s: c/f = %d/%d; %sr %su %ss\n",
      signal2name (sig),
      _dict_comparisons,
      _dict_forks,
      dict_format_time (tim_get_real ("dictd")),
      dict_format_time (tim_get_user ("dictd")),
      dict_format_time (tim_get_system ("dictd")));
}

static void unload_databases (void)
{
   dict_close_databases (DictConfig);
   DictConfig = NULL;
}

static void reload_config (void)
{
   dict_close_databases (DictConfig);

   if (!access(configFile,R_OK)){
      prs_file_pp (preprocessor, configFile);
      postprocess_filenames (DictConfig);
   }

   sanity (configFile);

   if (dbg_test (DBG_VERBOSE))
      dict_config_print( NULL, DictConfig );

   dict_init_databases (DictConfig);
}

static void xsigaddset (sigset_t *set, int signo)
{
   if (sigaddset (set, signo)){
      log_error ("", "sigaddset(2) failed: %s\n", strerror (errno));
   }
}

static void xsigprocmask (int how, const sigset_t *set, sigset_t *oset)
{
   if (sigprocmask (how, set, oset)){
      log_error ("", "sigaddset(2) failed: %s\n", strerror (errno));
   }
}

static void block_signals (void)
{
   sigset_t set;

   sigemptyset (&set);
   xsigaddset (&set, SIGALRM);
   xsigaddset (&set, SIGCHLD);

   xsigprocmask (SIG_BLOCK, &set, NULL);
}

static void unblock_signals (void)
{
   sigset_t set;

   sigemptyset (&set);
   xsigaddset (&set, SIGALRM);
   xsigaddset (&set, SIGCHLD);

   xsigprocmask (SIG_UNBLOCK, &set, NULL);
}

static void handler( int sig )
{
   const char *name = NULL;
   time_t     t;

   name = signal2name (sig);

   if (_dict_daemon) {
      daemon_terminate( sig, name );
   } else {
      tim_stop( "dictd" );
      switch (sig){
      case SIGALRM:
	 if (_dict_markTime > 0){
	    time(&t);
	    log_info( ":t: %24.24s; %d/%d %sr %su %ss\n",
		      ctime(&t),
		      _dict_forks - _dict_reaps,
		      _dict_forks,
		      dict_format_time( tim_get_real( "dictd" ) ),
		      dict_format_time( tim_get_user( "dictd" ) ),
		      dict_format_time( tim_get_system( "dictd" ) ) );
	    alarm(_dict_markTime);
	    return;
	 }

	 break;
      }

      log_sig_info (sig);
   }
   if (!dbg_test(DBG_NOFORK) || sig != SIGALRM)
      exit(sig+128);
}

static const char *postprocess_filename (const char *fn, const char *prefix)
{
   char *new_fn;

   if (!fn)
      return NULL;

   if (fn [0] != '/' && fn [0] != '.'){
      new_fn = xmalloc (2 + strlen (prefix) + strlen (fn));
      strcpy (new_fn, prefix);
      strcat (new_fn, fn);

      return new_fn;
   }else{
      return xstrdup (fn);
   }
}

const char *postprocess_plugin_filename (const char *fn)
{
   return postprocess_filename (fn, DICT_PLUGIN_PATH);
}

const char *postprocess_dict_filename (const char *fn)
{
   return postprocess_filename (fn, DICT_DICTIONARY_PATH);
}

static void postprocess_filenames (dictConfig *dc)
{
   lst_Position p;
   dictDatabase *db;

   LST_ITERATE(dc -> dbl, p, db) {
      db -> dataFilename = postprocess_dict_filename (db -> dataFilename);
      db -> indexFilename = postprocess_dict_filename (db -> indexFilename);
      db -> indexsuffixFilename = postprocess_dict_filename (db -> indexsuffixFilename);
      db -> indexwordFilename = postprocess_dict_filename (db -> indexwordFilename);
      db -> pluginFilename = postprocess_plugin_filename (db -> pluginFilename);
   }

   site_info = postprocess_dict_filename (site_info);
}

static void handler_sighup (int sig)
{
   log_sig_info (sig);
   need_reload_config = 1;
}

static void handler_sigusr1 (int sig)
{
   log_sig_info (sig);
   need_unload_databases = 1;
}

static void setsig( int sig, void (*f)(int), int sa_flags )
{
   struct sigaction   sa;

   sa.sa_handler = f;
   sigemptyset(&sa.sa_mask);
   sa.sa_flags = sa_flags;
   sigaction(sig, &sa, NULL);
}

struct access_print_struct {
   FILE *s;
   int  offset;
};

static int access_print( const void *datum, void *arg )
{
   dictAccess                 *a     = (dictAccess *)datum;
   struct access_print_struct *aps   = (struct access_print_struct *)arg;
   FILE                       *s     = aps->s;
   int                        offset = aps->offset;
   int                        i;
   const char                 *desc;

   for (i = 0; i < offset; i++) fputc( ' ', s );
   switch (a->type) {
   case DICT_DENY:     desc = "deny";     break;
   case DICT_ALLOW:    desc = "allow";    break;
   case DICT_AUTHONLY: desc = "authonly"; break;
   case DICT_USER:     desc = "user";     break;
   case DICT_GROUP:    desc = "group";    break; /* Not implemented. */
   default:            desc = "unknown";  break;
   }
   fprintf( s, "%s %s\n", desc, a->spec );
   return 0;
}

static void acl_print( FILE *s, lst_List l, int offset)
{
   struct access_print_struct aps;
   int                        i;

   aps.s      = s;
   aps.offset = offset + 3;
   
   for (i = 0; i < offset; i++) fputc( ' ', s );
   fprintf( s, "access {\n" );
   lst_iterate_arg( l, access_print, &aps );
   for (i = 0; i < offset; i++) fputc( ' ', s );
   fprintf( s, "}\n" );
}

static int user_print( const void *key, const void *datum, void *arg )
{
   const char *username = (const char *)key;
   const char *secret   = (const char *)datum;
   FILE       *s        = (FILE *)arg;

   if (dbg_test(DBG_AUTH))
      fprintf( s, "user %s %s\n", username, secret );
   else
      fprintf( s, "user %s *\n", username );
   return 0;
}

static int config_print( const void *datum, void *arg )
{
   dictDatabase *db = (dictDatabase *)datum;
   FILE         *s  = (FILE *)arg;

   fprintf( s, "database %s {\n", db->databaseName );

   if (db->dataFilename)
      fprintf( s, "   data       %s\n", db->dataFilename );
   if (db->indexFilename)
      fprintf( s, "   index      %s\n", db->indexFilename );
   if (db->indexsuffixFilename)
      fprintf( s, "   index_suffix      %s\n", db->indexsuffixFilename );
   if (db->indexwordFilename)
      fprintf( s, "   index_word      %s\n", db->indexwordFilename );
   if (db->filter)
      fprintf( s, "   filter     %s\n", db->filter );
   if (db->prefilter)
      fprintf( s, "   prefilter  %s\n", db->prefilter );
   if (db->postfilter)
      fprintf( s, "   postfilter %s\n", db->postfilter );
   if (db->databaseShort)
      fprintf( s, "   name       %s\n", db->databaseShort );
   if (db->acl)
      acl_print( s, db->acl, 3 );

   fprintf( s, "}\n" );

   return 0;
}

static void dict_config_print( FILE *stream, dictConfig *c )
{
   FILE *s = stream ? stream : stderr;

   if (c->acl) acl_print( s, c->acl, 0 );
   lst_iterate_arg( c->dbl, config_print, s );
   if (c->usl) hsh_iterate_arg( c->usl, user_print, s );
}

static const char *get_entry_info( dictDatabase *db, const char *entryName )
{
   dictWord *dw;
   lst_List list = lst_create();
   char     *pt, *buf;
   size_t   len;

   if (
      0 >= dict_search (
	 list, entryName, db, DICT_STRAT_EXACT, 0,
	 NULL, NULL, NULL ))
   {
#ifdef USE_PLUGIN
      call_dictdb_free (DictConfig->dbl);
#endif
      lst_destroy( list );
      return NULL;
   }

   dw = lst_nth_get( list, 1 );

   assert (dw -> database);

   buf = pt = dict_data_obtain( dw -> database, dw );

   if (!strncmp (pt, "00database", 10) || !strncmp (pt, "00-database", 11)){
      while (*pt != '\n')
	 ++pt;

      ++pt;
   }

   while (*pt == ' ' || *pt == '\t')
      ++pt;

   len = strlen(pt);
   if (pt [len - 1] == '\n')
      pt [len - 1] = '\0';

#ifdef USE_PLUGIN
   call_dictdb_free (DictConfig->dbl);
#endif
   dict_destroy_list( list );

   pt = xstrdup (pt);

   xfree (buf);

   return pt;
}

static dictDatabase *dbname2database (const char *dbname)
{
   dictDatabase *db    = NULL;
   lst_Position db_pos = lst_init_position (DictConfig->dbl);

   while (db_pos){
      db = lst_get_position (db_pos);

      if (!strcmp (db -> databaseName, dbname)){
	 return db;
      }

      db_pos = lst_next_position (db_pos);
   }

   return NULL;
}

static lst_List string2virtual_db_list (char *s)
{
   int len, i;
   lst_List virtual_db_list;
   char *p;

   dictDatabase *db = NULL;

   p   = s;
   len = strlen (s);

   virtual_db_list = lst_create ();

   for (i = 0; i <= len; ++i){
      if (s [i] == ',' || s [i] == '\n' || s [i] == '\0'){
	 s [i] = '\0';

	 if (*p){
	    db = dbname2database (p);

	    if (db){
	       lst_append (virtual_db_list, db);
	    }else{
	       log_info( ":E: Unknown database '%s'\n", p );
	       PRINTF(DBG_INIT, (":E: Unknown database '%s'\n", p));
	       exit (2);
	    }
	 }

	 p = s + i + 1;
      }
   }

   return virtual_db_list;
}

static int init_virtual_db_list (const void *datum)
{
   lst_List list;
   dictDatabase *db  = (dictDatabase *)datum;
   dictWord *dw;
   char *buf;
   int ret;

   if (db -> database_list){
      buf = xstrdup (db -> database_list);
      db -> virtual_db_list = string2virtual_db_list (buf);
      xfree (buf);
   }else{
      if (!db -> index)
	 return 0;

      list = lst_create();
      ret = dict_search (
	 list, DICT_FLAG_VIRTUAL, db, DICT_STRAT_EXACT, 0,
	 NULL, NULL, NULL);

      switch (ret){
      case 1: case 2:
	 dw  = (dictWord *) lst_pop (list);
	 buf = dict_data_obtain (db, dw);
	 dict_destroy_datum (dw);

	 db -> virtual_db_list = string2virtual_db_list (buf);

	 xfree (buf);
	 break;
      case 0:
	 break;
      default:
	 err_fatal (
	    __func__,
	    "index file contains more than one %s entry",
	    DICT_FLAG_VIRTUAL);
      }

      dict_destroy_list (list);
   }

   return 0;
}

static int init_mime_db_list (const void *datum)
{
   dictDatabase *db  = (dictDatabase *)datum;

   if (!db -> mime_db)
      return 0;

   /* MIME */
   if (db -> mime_mimeDbname){
      db -> mime_mimeDB = dbname2database (db -> mime_mimeDbname);

      if (!db -> mime_mimeDB){
	 err_fatal (
	    __func__,
	    "Incorrect database name '%s'\n",
	    db -> mime_mimeDbname);
      }
   }else{
      err_fatal (
	 __func__,
	 "MIME database '%s' has no mime_dbname keyword\n",
	 db -> databaseName);
   }

   /* NO MIME */
   if (db -> mime_nomimeDbname){
      db -> mime_nomimeDB = dbname2database (db -> mime_nomimeDbname);

      if (!db -> mime_nomimeDB){
	 err_fatal (
	    __func__,
	    "Incorrect database name '%s'\n",
	    db -> mime_nomimeDbname);
      }
   }else{
      err_fatal (
	 __func__,
	 "MIME database '%s' has no nomime_dbname keyword\n",
	 db -> databaseName);
   }

   return 0;
}

static int init_plugin( const void *datum )
{
#ifdef USE_PLUGIN
   dictDatabase *db = (dictDatabase *)datum;
   dict_plugin_init (db);
#endif

   return 0;
}

void dict_disable_strat (dictDatabase *db, const char* strategy)
{
   int strat = -1;
   int array_size = get_max_strategy_num () + 1;

   assert (db);
   assert (strategy);

   if (!db -> strategy_disabled){
      db -> strategy_disabled = xmalloc (array_size * sizeof (int));
      memset (db -> strategy_disabled, 0, array_size * sizeof (int));
   }

   strat = lookup_strategy_ex (strategy);
   assert (strat >= 0);

   db -> strategy_disabled [strat] = 1;
}

static void init_database_alphabet (dictDatabase *db)
{
   int ret;
   lst_List l;
   const dictWord *dw;
   char *data;

   if (!db -> normal_db)
      return;

   l = lst_create ();

   ret = dict_search_database_ (l, DICT_FLAG_ALPHABET, db, DICT_STRAT_EXACT);

   if (ret){
      dw = (const dictWord *) lst_top (l);
      data = dict_data_obtain (db, dw);
      db -> alphabet = data;

      data = strchr (db -> alphabet, '\n');
      if (data)
	 *data = 0;
   }

   dict_destroy_list (l);
}

static void init_database_default_strategy (dictDatabase *db)
{
   int ret;
   lst_List l;
   const dictWord *dw;
   char *data;
   int def_strat = -1;
   char *p;

   if (!db -> normal_db)
      return;

   if (db -> default_strategy > 0){
      /* already set by `default_strategy' directive*/
      return;
   }

   l = lst_create ();

   ret = dict_search_database_ (l, DICT_FLAG_DEFAULT_STRAT, db, DICT_STRAT_EXACT);

   if (ret){
      dw = (const dictWord *) lst_top (l);
      data = dict_data_obtain (db, dw);

      for (p=data; *p && isalpha ((unsigned char) *p); ++p){
      }
      *p = '\0';

      def_strat = lookup_strategy (data);
      if (-1 == def_strat){
	 PRINTF (DBG_INIT, (":I:     `%s' is not supported by dictd\n", data));
      }else{
	 db -> default_strategy = def_strat;
      }

      xfree (data);
   }

   dict_destroy_list (l);
}

static int init_database_mime_header (const void *datum)
{
   dictDatabase *db = (dictDatabase *) datum;
   int ret;
   lst_List l;
   const dictWord *dw;
   char *data;

   if (!db -> normal_db)
      return 0;

   if (db -> mime_header){
      /* already set by `mime_header' directive*/
      return 0;
   }

   l = lst_create ();

   ret = dict_search_database_ (l, DICT_FLAG_MIME_HEADER, db, DICT_STRAT_EXACT);

   if (ret){
      dw = (const dictWord *) lst_top (l);
      data = dict_data_obtain (db, dw);

      db -> mime_header = xstrdup (data);

      xfree (data);
   }

   dict_destroy_list (l);

   return 0;
}

static int init_database( const void *datum )
{
   dictDatabase *db = (dictDatabase *)datum;
   const char *strat_name = NULL;

   PRINTF (DBG_INIT, (":I: Initializing '%s'\n", db->databaseName));

   if (db->indexFilename){
      PRINTF (DBG_INIT, (":I:   Opening indices\n"));
   }

   db->index        = dict_index_open( db->indexFilename, 1, NULL );

   if (db->indexFilename){
      PRINTF (DBG_INIT, (":I:     .index <ok>\n"));
   }

   if (db->index){
      db->index_suffix = dict_index_open(
	 db->indexsuffixFilename,
	 0, db->index);

      db->index_word = dict_index_open(
	 db->indexwordFilename,
	 0, db->index);
   }

   if (db->index_suffix){
      PRINTF (DBG_INIT, (":I:     .indexsuffix <ok>\n"));
      db->index_suffix->flag_8bit     = db->index->flag_8bit;
      db->index_suffix->flag_utf8     = db->index->flag_utf8;
      db->index_suffix->flag_allchars = db->index->flag_allchars;
   }
   if (db->index_word){
      PRINTF (DBG_INIT, (":I:     .indexword <ok>\n"));
      db->index_word->flag_utf8     = db->index->flag_utf8;
      db->index_word->flag_8bit     = db->index->flag_8bit;
      db->index_word->flag_allchars = db->index->flag_allchars;
   }

   if (db->dataFilename){
      PRINTF (DBG_INIT, (":I:   Opening data\n"));
   }

   db->data         = dict_data_open( db->dataFilename, 0 );

   init_database_alphabet (db);
   if (db -> alphabet){
      PRINTF (DBG_INIT, (":I:     alphabet: %s\n", db -> alphabet));
   }else{
      PRINTF (DBG_INIT, (":I:     alphabet: (NULL)\n"));
   }

   if (db -> default_strategy){
      strat_name = get_strategy (db -> default_strategy) -> name;
      PRINTF (DBG_INIT, (":I:     default_strategy (from conf file): %s\n",
			 strat_name));
   }else{
      init_database_default_strategy (db);
      if (db -> default_strategy){
	 strat_name = get_strategy (db -> default_strategy) -> name;
	 PRINTF (DBG_INIT, (":I:     default_strategy (from db): %s\n", strat_name));
      }else{
	 db -> default_strategy = default_strategy;
      }
   }

   if (db->dataFilename){
      PRINTF(DBG_INIT,
	     (":I: '%s' initialized\n", db->databaseName));
   }

   return 0;
}

static int init_database_short (const void *datum)
{
   char *NL;

   dictDatabase *db = (dictDatabase *) datum;

   if (!db->databaseShort){
      db->databaseShort = get_entry_info( db, DICT_SHORT_ENTRY_NAME );
   }else if (*db->databaseShort == '@'){
      db->databaseShort = get_entry_info( db, db->databaseShort + 1 );
   }else{
      db->databaseShort = xstrdup (db->databaseShort);
   }

   if (db->databaseShort){
      NL = strchr (db->databaseShort, '\n');
      if (NL)
	 *NL = 0;
   }

   if (!db->databaseShort)
      db->databaseShort = xstrdup (db->databaseName);

   return 0;
}

static int close_plugin (const void *datum)
{
#ifdef USE_PLUGIN
   dictDatabase  *db = (dictDatabase *)datum;
   dict_plugin_destroy (db);
#endif

   return 0;
}

static int close_database (const void *datum)
{
   dictDatabase  *db = (dictDatabase *)datum;

   dict_index_close (db->index);
   dict_index_close (db->index_suffix);
   dict_index_close (db->index_word);

   dict_data_close (db->data);

   if (db -> databaseShort)
      xfree ((void *) db -> databaseShort);

   if (db -> indexFilename)
      xfree ((void *) db -> indexFilename);
   if (db -> dataFilename)
      xfree ((void *) db -> dataFilename);
   if (db -> indexwordFilename)
      xfree ((void *) db -> indexwordFilename);
   if (db -> indexsuffixFilename)
      xfree ((void *) db -> indexsuffixFilename);
   if (db -> pluginFilename)
      xfree ((void *) db -> pluginFilename);
   if (db -> strategy_disabled)
      xfree ((void *) db -> strategy_disabled);
   if (db -> alphabet)
      xfree ((void *) db -> alphabet);
   if (db -> mime_header)
      xfree ((void *) db -> mime_header);

   return 0;
}

static int log_database_info( const void *datum )
{
   dictDatabase  *db = (dictDatabase *)datum;
   const char    *pt;
   unsigned long headwords = 0;

   if (db->index){
      for (pt = db->index->start; pt < db->index->end; pt++)
	 if (*pt == '\n') ++headwords;
      db->index->headwords = headwords;

      log_info( ":I: %-12.12s %12lu %12lu %12lu %12lu\n",
		db->databaseName, headwords,
		db->index->size, db->data->size, db->data->length );
   }

   return 0;
}

static void dict_ltdl_init ()
{
#if defined(USE_PLUGIN) && !HAVE_DLFCN_H
   if (lt_dlinit ())
      err_fatal( __func__, "Can not initialize 'ltdl' library\n" );
#endif
}

static void dict_ltdl_close ()
{
#if defined(USE_PLUGIN) && !HAVE_DLFCN_H
   if (lt_dlexit ())
      err_fatal( __func__, "Can not deinitialize 'ltdl' library\n" );
#endif
}

/*
  Makes dictionary_exit db invisible if it is the last visible one
 */
static void make_dictexit_invisible (dictConfig *c)
{
   lst_Position p;
   dictDatabase *db;
   dictDatabase *db_exit = NULL;

   LST_ITERATE(c -> dbl, p, db) {
      if (!db -> invisible){
	 if (db_exit)
	    db_exit -> invisible = 0;

	 db_exit = NULL;
      }

      if (db -> exit_db){
	 db_exit = db;
	 db_exit -> invisible = 1;
      }
   }
}

static void dict_init_databases( dictConfig *c )
{
   make_dictexit_invisible (c);

   lst_iterate( c->dbl, init_database );
   lst_iterate( c->dbl, init_plugin );
   lst_iterate( c->dbl, init_virtual_db_list );
   lst_iterate( c->dbl, init_mime_db_list );
   lst_iterate( c->dbl, init_database_short );
   lst_iterate( c->dbl, init_database_mime_header);
   lst_iterate( c->dbl, log_database_info );
}

static void dict_close_databases (dictConfig *c)
{
   dictDatabase *db;
   dictAccess   *acl;

   if (!c)
      return;

   if (c -> dbl){
      while (lst_length (c -> dbl) > 0){
	 db = (dictDatabase *) lst_pop (c -> dbl);

	 if (db -> virtual_db_list)
	    lst_destroy (db -> virtual_db_list);

	 close_plugin (db);
	 close_database (db);
	 xfree (db);
      }
      lst_destroy (c -> dbl);
   }

   if (c -> acl){
      while (lst_length (c -> acl) > 0){
	 acl = (dictAccess *) lst_pop (c->acl);
	 xfree (acl);
      }
      lst_destroy (c -> acl);
   }

   if (site_info)
      xfree ((void *) site_info);

   xfree (c);
}

static const char *id_string (void)
{
   static char buffer [BUFFERSIZE];

   snprintf( buffer, BUFFERSIZE, "%s", DICT_VERSION );

   return buffer;
}

const char *dict_get_banner( int shortFlag )
{
   static char    *shortBuffer = NULL;
   static char    *longBuffer = NULL;
   struct utsname uts;
   
   if (shortFlag && shortBuffer) return shortBuffer;
   if (!shortFlag && longBuffer) return longBuffer;
   
   uname( &uts );

   shortBuffer = xmalloc(256);
   snprintf(
      shortBuffer, 256,
      "%s %s", err_program_name(), id_string () );

   longBuffer = xmalloc(256);
   snprintf(
      longBuffer, 256,
      "%s %s/rf on %s %s", err_program_name(), id_string (),
      uts.sysname,
      uts.release );

   if (shortFlag)
      return shortBuffer;

   return longBuffer;
}

static void banner( void )
{
   printf( "%s\n", dict_get_banner(0) );
   printf( "Copyright 1997-2002 Rickard E. Faith (faith@dict.org)\n" );
   printf( "Copyright 2002-2007 Aleksey Cheusov (vle@gmx.net)\n" );
   printf( "\n" );
}

static void license( void )
{
   static const char *license_msg[] = {
     "This program is free software; you can redistribute it and/or modify it",
     "under the terms of the GNU General Public License as published by the",
     "Free Software Foundation; either version 1, or (at your option) any",
     "later version.",
     "",
     "This program is distributed in the hope that it will be useful, but",
     "WITHOUT ANY WARRANTY; without even the implied warranty of",
     "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU",
     "General Public License for more details.",
     "",
     "You should have received a copy of the GNU General Public License along",
     "with this program; if not, write to the Free Software Foundation, Inc.,",
     "675 Mass Ave, Cambridge, MA 02139, USA.",
   0 };
   const char        **p = license_msg;
   
   banner();
   while (*p) printf( "   %s\n", *p++ );
}

static void help( void )
{
   static const char *help_msg[] = {
   "Usage: dictd [options]",
   "Start the dictd daemon",
   "",
      "-h --help             give this help",
      "   --license          display software license",
      "-v --verbose          verbose mode",
      "-V --version          display version number",
      "-p --port <port>      port number",
      "   --delay <seconds>  client timeout in seconds",
      "   --depth <length>   TCP/IP queue depth",
      "   --limit <children> maximum simultaneous children",
      "-c --config <file>    configuration file",
      "-l --log <option>     select logging option",
      "-s --syslog           log via syslog(3)",
      "-L --logfile <file>   log via specified file",
      "-m --mark <minutes>   how often should a timestamp be logged",
      "   --facility <fac>   set syslog logging facility",
      "-d --debug <option>   select debug option",
      "-i --inetd            run from inetd",
      "   --pid-file <path>  PID filename",
      "   --pp <prog>        set preprocessor for configuration file",
      "-f --force            force startup even if daemon running",
      "   --locale <locale>  specifies the locale used for searching.\n\
                      if no locale is specified, the \"C\" locale is used.",
"   --default-strategy   set the default search strategy for 'match' queries.\n\
                      the default is 'lev'.",
"   --without-strategy <strategies> disable strategies.\n\
                                   <strategies> is a comma-separated list.",
"   --add-strategy <strat>:<descr>  adds new strategy <strat>\n\
                                   with a description <descr>.",
"   --listen-to                     bind a socket to the specified address",
"\n------------------ options for debugging ---------------------------",
"   --fast-start                 don't create additional (internal) index.",
#ifdef HAVE_MMAP
"   --without-mmap               do not use mmap() function and load files\n\
                                into memory instead.",
#endif
"   --stdin2stdout               copy stdin to stdout (addition to -i option).",
      0 };
   const char        **p = help_msg;

   banner();
   while (*p)
      printf( "%s\n", *p++ );
}

void set_minimal( void )
{
   flg_set(flg_name(LOG_FOUND));
   flg_set(flg_name(LOG_NOTFOUND));
   flg_set(flg_name(LOG_STATS));
   flg_set(flg_name(LOG_CLIENT));
   flg_set(flg_name(LOG_AUTH));
   flg_set("-min");
}

static void release_root_privileges( void )
/* At the spring 1999 Linux Expo in Raleigh, Rik Faith told me that he
 * did not want dictd to be allowed to run as root for any reason.
 * This patch irrevocably releases root privileges.  -- Kirk Hilliard
 *
 * Updated to set the user to `dictd' if that user exists on the
 * system; if user dictd doesn't exist, it sets the user to `nobody'.
 * -- Bob Hilliard
 */
{
   if (geteuid() == 0) {
      struct passwd *pwd;

      if ((pwd = getpwnam("dictd"))) {
         setgid(pwd->pw_gid);
         initgroups("dictd",pwd->pw_gid);
         setuid(pwd->pw_uid);
      } else if ((pwd = getpwnam("nobody"))) {
         setgid(pwd->pw_gid);
         initgroups("nobody",pwd->pw_gid);
         setuid(pwd->pw_uid);
      } else {
         setgid(GID_NOGROUP);
         initgroups("nobody", GID_NOGROUP);
         setuid(UID_NOBODY);
      }
   }
}

/* Perform sanity checks that are often problems for people trying to
 * get dictd running.  Do this early, before we detach from the
 * console. */
static void sanity(const char *confFile)
{
   int           fail = 0;
   int           reading_error = 0;
   struct passwd *pw = NULL;
   struct group  *gr = NULL;

   if (access(confFile,R_OK)) {
      log_info(":E: %s is not readable (config file)\n", confFile);
      ++fail;
   }
   if (DictConfig && !DictConfig->dbl) {
      log_info(":E: no databases have been defined\n");
      log_info(":E: check %s or use -c\n", confFile);
      ++fail;
   }
   if (DictConfig && DictConfig->dbl) {
      lst_Position p;
      dictDatabase *e;
      LST_ITERATE(DictConfig->dbl, p, e) {
	 if (e->indexFilename && access(e->indexFilename, R_OK)) {
	    log_info(":E: %s is not readable (index file)\n",
		     e->indexFilename);
	    ++fail;
	    reading_error = 1;
	 }
	 if (e->indexsuffixFilename && access(e->indexsuffixFilename, R_OK)) {
	    log_info(":E: %s is not readable (index_suffix file)\n",
		     e->indexsuffixFilename);
	    ++fail;
	    reading_error = 1;
	 }
	 if (e->indexwordFilename && access(e->indexwordFilename, R_OK)) {
	    log_info(":E: %s is not readable (index_word file)\n",
		     e->indexwordFilename);
	    ++fail;
	    reading_error = 1;
	 }

	 if (e->dataFilename && access(e->dataFilename, R_OK)) {
	    log_info(":E: %s is not readable (data file)\n",
		     e->dataFilename);
	    ++fail;
	    reading_error = 1;
	 }
	 if (e->virtual_db && !e->database_list){
	    log_info(
	       ":E: database list is not specified for virtual dictionary '%s'\n",
	       e->databaseName);
	    ++fail;
	 }
	 if (e->normal_db && !e->dataFilename){
	    log_info(
	       ":E: data filename is not specified for dictionary '%s'\n",
	       e->databaseName);
	    ++fail;
	 }
	 if (e->normal_db && !e->indexFilename){
	    log_info(
	       ":E: index filename is not specified for dictionary '%s'\n",
	       e->databaseName);
	    ++fail;
	 }
	 if (e->plugin_db && !e->pluginFilename){
	    log_info(
	       ":E: plugin filename is not specified for dictionary '%s'\n",
	       e->databaseName);
	    ++fail;
	 }
#ifndef USE_PLUGIN
	 if (e -> plugin_db){
	    log_info (
	       ":E: plugin support was disabled at compile time\n");
	    ++fail;
	 }
#endif
      }
   }
   if (fail) {
      if (reading_error){
	 pw = getpwuid (geteuid ());
	 gr = getgrgid (getegid ());

	 log_info(":E: for security, this program will not run as root.\n");
	 log_info(":E: if started as root, this program will change"
		  " to \"dictd\" or \"nobody\".\n");
	 log_info(":E: currently running as user %d/%s, group %d/%s\n",
		  geteuid(), pw && pw->pw_name ? pw->pw_name : "?",
		  getegid(), gr && gr->gr_name ? gr->gr_name : "?");
	 log_info(":E: config and db files must be readable by that user\n");
      }
      err_fatal(__func__, ":E: terminating due to errors. See log file\n");
   }
}

static void set_locale_and_flags (const char *loc)
{
   const char *charset = NULL;
   int ascii_mode;

   if (!setlocale(LC_COLLATE, loc) || !setlocale(LC_CTYPE, loc)){
      fprintf (stderr, "invalid locale '%s'\n", locale);
      exit (2);
   }

   charset = nl_langinfo (CODESET);

   utf8_mode = !strcmp (charset, "UTF-8") || !strcmp (charset, "utf-8");

#if !HAVE_UTF8
   if (utf8_mode){
      err_fatal (
	 __func__,
	 "utf-8 support was disabled at compile time\n");
   }
#endif

   ascii_mode = 
      !strcmp (charset, "ANSI_X3.4-1968") ||
      !strcmp (charset, "US-ASCII") ||
      (locale [0] == 'C' && locale [1] == 0);

   bit8_mode = !ascii_mode && !utf8_mode;
}

static void set_umask (void)
{
#if defined(__OPENNT) || defined(__INTERIX)
   umask(002);		/* set safe umask */
#else
   umask(022);		/* set safe umask */
#endif
}

static void init (const char *fn)
{
   maa_init (fn);
   dict_ltdl_init ();
   dict_init_strategies ();
}

static void destroy ()
{
   maa_shutdown ();

   dict_ltdl_close ();
   dict_destroy_strategies ();
}

FILE *pid_fd = NULL;

static void pid_file_create ()
{
   pid_fd = fopen (pidFile, "w");

   if (!pid_fd){
      log_info(":E: cannot open pid file '%s'\n:E:    err msg: %s\n",
	       pidFile, strerror (errno));
      err_fatal(__func__,
		":E: terminating due to errors. See log file\n");
   }
}

static void pid_file_write ()
{
   if (-1 == fprintf (pid_fd, "%lu\n", (unsigned long) getpid ()) ||
       fclose (pid_fd))
   {
      log_info(":E: cannot write to pid file '%s'\n:E:    err msg: %s\n",
	       pidFile, strerror (errno));
      err_fatal(__func__,
		":E: terminating due to errors. See log file\n");
   }
}

static void reopen_012 (void)
{
   int fd = open ("/dev/null", O_RDWR);
   if (fd == -1)
      err_fatal_errno (__func__, ":E: can't open /dev/null");

   close (0);
   close (1);
   close (2);

   dup (fd);
   dup (fd);
   dup (fd);
}

int main (int argc, char **argv, char **envp)
{
   int                childSocket;
   int                masterSocket;
   struct sockaddr_in csin;
   int                c;
   time_t             startTime;
   socklen_t          alen         = sizeof (csin);
   int                detach       = 1;
   int                forceStartup = 0;
   int                i;

   int                errno_accept = 0;

   const char *       default_strategy_arg = "???";

   char *             new_strategy;
   char *             new_strategy_descr;

   struct option      longopts[]   = {
      { "verbose",  0, 0, 'v' },
      { "version",  0, 0, 'V' },
      { "debug",    1, 0, 'd' },
      { "port",     1, 0, 'p' },
      { "config",   1, 0, 'c' },
      { "help",     0, 0, 'h' },
      { "license",  0, 0, 500 },
      { "log",      1, 0, 'l' },
      { "logfile",  1, 0, 'L' },
      { "syslog",   0, 0, 's' },
      { "mark",     1, 0, 'm' },
      { "delay",    1, 0, 502 },
      { "depth",    1, 0, 503 },
      { "limit",    1, 0, 504 },
      { "facility", 1, 0, 505 },
      { "force",    1, 0, 'f' },
      { "inetd",    0, 0, 'i' },
      { "locale",           1, 0, 506 },
#ifdef HAVE_MMAP
      { "no-mmap",          0, 0, 508 },
      { "without-mmap",     0, 0, 508 },
#endif
      { "default-strategy", 1, 0, 511 },
      { "without-strategy", 1, 0, 513 },
      { "add-strategy",     1, 0, 516 },
      { "fast-start",       0, 0, 517 },
      { "pp",               1, 0, 518 },
      { "listen-to",        1, 0, 519 },
      { "pid-file",         1, 0, 521 },
      { "stdin2stdout",     0, 0, 522 },
      { 0,                  0, 0, 0  }
   };

   set_umask ();
   init (argv[0]);

   flg_register( LOG_SERVER,    "server" );
   flg_register( LOG_CONNECT,   "connect" );
   flg_register( LOG_STATS,     "stats" );
   flg_register( LOG_COMMAND,   "command" );
   flg_register( LOG_FOUND,     "found" );
   flg_register( LOG_NOTFOUND,  "notfound" );
   flg_register( LOG_CLIENT,    "client" );
   flg_register( LOG_HOST,      "host" );
   flg_register( LOG_TIMESTAMP, "timestamp" );
   flg_register( LOG_MIN,       "min" );
   flg_register( LOG_AUTH,      "auth" );

   dbg_register( DBG_VERBOSE,  "verbose" );
   dbg_register( DBG_UNZIP,    "unzip" );
   dbg_register( DBG_SCAN,     "scan" );
   dbg_register( DBG_PARSE,    "parse" );
   dbg_register( DBG_SEARCH,   "search" );
   dbg_register( DBG_INIT,     "init" );
   dbg_register( DBG_PORT,     "port" );
   dbg_register( DBG_LEV,      "lev" );
   dbg_register( DBG_AUTH,     "auth" );
   dbg_register( DBG_NODETACH, "nodetach" );
   dbg_register( DBG_NOFORK,   "nofork" );
   dbg_register( DBG_ALT,      "alt" );

   log_stream ("dictd", stderr);

   while ((c = getopt_long( argc, argv,
			    "vVd:p:c:hL:t:l:sm:fi", longopts, NULL )) != EOF)
      switch (c) {
                                /* Remember to copy optarg since we're
                                   going to destroy argv soon... */
      case 'v': dbg_set( "verbose" );                     break;
      case 'V': banner(); exit(1);                        break;
      case 'd': dbg_set( optarg );                        break;
      case 'p':
	 daemon_service     = str_copy(optarg);
	 daemon_service_set = 1;
	 break;
      case 'c': configFile = str_copy(optarg);            break;
      case 'L':
	 logFile     = str_copy(optarg);
	 logFile_set = 1;
	 break;
      case 's': ++useSyslog;                              break;
      case 'm':
	 _dict_markTime     = 60*atoi(optarg);
	 _dict_markTime_set = 1;
	 break;
      case 'f': ++forceStartup;                           break;
      case 'i':
	 inetd         = 1;
	 optStart_mode = 0;
	 break;
      case 'l':
	 ++logOptions;
	 flg_set( optarg );
	 if (flg_test(LOG_MIN)) set_minimal();
	 break;
      case 500: license(); exit(1);                       break;
      case 502:
	 client_delay     = atoi(optarg);
	 client_delay_set = 1;
	 _dict_daemon_limit_time = 0;
	 break;
      case 503:
	 depth     = atoi(optarg);
	 depth_set = 1;
	 break;
      case 504:
	 _dict_daemon_limit_childs = atoi(optarg);
	 _dict_daemon_limit_childs_set = 1;
	 break;
      case 505:
	 ++useSyslog;
	 log_set_facility (optarg);
	 syslog_facility_set = 1;
	 break;
      case 506:
	 locale     = str_copy (optarg);
	 locale_set = 1;
	 break;
      case 508: mmap_mode = 0;                            break;
      case 511:
	 default_strategy_arg = str_copy (optarg);
	 default_strategy     = lookup_strategy_ex (default_strategy_arg);
	 default_strategy_set = 1;
	 break;
      case 513:
	 dict_disable_strategies (optarg);
	 break;
      case 516:
	 new_strategy = optarg;
	 new_strategy_descr = strchr (new_strategy, ':');
	 if (!new_strategy_descr){
	    fprintf (stderr, "missing ':' symbol in --add-strategy option\n");
	    exit (1);
	 }

	 *new_strategy_descr++ = 0;

	 dict_add_strategy (new_strategy, new_strategy_descr);

	 break;
      case 517: optStart_mode = 0;                        break;
      case 518: preprocessor = str_copy (optarg);         break;
      case 519:
	 bind_to     = str_copy (optarg);
	 bind_to_set = 1;
	 break;
      case 521:
	 pidFile     = str_copy(optarg);
	 pidFile_set = 1;
	 break;
      case 522:
	 stdin2stdout_mode = 1;
	 break;
      case 'h':
      default:  help(); exit(0);                          break;
      }

   if (inetd)
      detach = 0;

   if (-1 == default_strategy){
      fprintf (stderr, "%s is not a valid search strategy\n",
	       default_strategy_arg);

      fprintf (stderr, "available ones are:\n");

      for (i = 0; i < get_strategy_count (); ++i){
	  fprintf (
	      stderr, "  %15s : %s\n",
	      get_strategies () [i] -> name, get_strategies () [i] -> description);
      }
      exit (1);
   }

   if (dbg_test(DBG_NOFORK))    dbg_set_flag( DBG_NODETACH);
   if (dbg_test(DBG_NODETACH))  detach = 0;
   if (dbg_test(DBG_PARSE))     prs_set_debug(1);
   if (dbg_test(DBG_SCAN))      yy_flex_debug = 1;
   else                         yy_flex_debug = 0;
   if (flg_test(LOG_TIMESTAMP)) log_option( LOG_OPTION_FULL );
   else                         log_option( LOG_OPTION_NO_FULL );

   if (!access(configFile,R_OK)) {
      prs_file_pp (preprocessor, configFile );
      postprocess_filenames (DictConfig);
   }

   if (detach) pid_file_create (); /* before leaving root priviledges */

   release_root_privileges();

   if (logFile)   log_file ("dictd", logFile);
   log_stream ("dictd", NULL);
   if (useSyslog) log_syslog ("dictd");
   if (! inetd && ! detach)   log_stream ("dictd", stderr);
   if ((logFile || useSyslog || !detach) && !logOptions)
      set_minimal();

   if (detach){
      /* become a daemon */
      daemon (0, 1);
      reopen_012 ();

      /* after fork from daemon(3) */
      pid_file_write ();
   }

   time(&startTime);
   log_info(":I: %d starting %s %24.24s\n",
	    getpid(), dict_get_banner(0), ctime(&startTime));

   tim_start( "dictd" );
   alarm(_dict_markTime);

   if (locale)
      set_locale_and_flags (locale);

   sanity(configFile);

   setsig(SIGCHLD, reaper, SA_RESTART);
   setsig(SIGHUP,   handler_sighup, 0);
   setsig(SIGUSR1,  handler_sigusr1, 0);
   if (!dbg_test(DBG_NOFORK))
      setsig(SIGINT,  handler, 0);
   setsig(SIGQUIT, handler, 0);
   setsig(SIGILL,  handler, 0);
   setsig(SIGTRAP, handler, 0);
   setsig(SIGTERM, handler, 0);
   setsig(SIGPIPE, handler, 0);
   setsig(SIGALRM, handler, SA_RESTART);

   fflush(stdout);
   fflush(stderr);

   if (locale)
      log_info(":I: using locale \"%s\"\n", locale);

   if (dbg_test(DBG_VERBOSE))
      dict_config_print( NULL, DictConfig );

   dict_init_databases( DictConfig );

   dict_initsetproctitle(argc, argv, envp);

   if (inetd) {
      dict_inetd(0);
      exit(0);
   }

   masterSocket = net_open_tcp( bind_to, daemon_service, depth );


   for (;;) {
      dict_setproctitle( "%s: %d/%d",
			 dict_get_banner(1),
			 _dict_forks - _dict_reaps,
			 _dict_forks );

      if (flg_test(LOG_SERVER))
         log_info( ":I: %d accepting on %s\n", getpid(), daemon_service );

/*unblock_signals ();*/
      childSocket = accept (masterSocket,
			    (struct sockaddr *)&csin, &alen);
      errno_accept = errno;
/*block_signals ();*/

      if (childSocket < 0){
	 switch (errno_accept){
	 case EINTR:
	    if (need_reload_config){
	       reload_config ();
	       need_reload_config = 0;
	       databases_unloaded = 0;
	    }

	    if (need_unload_databases){
	       unload_databases ();
	       need_unload_databases = 0;
	       databases_unloaded = 1;
	    }
	    continue;
	 case ECONNABORTED:
	 case ECONNRESET:
	 case ETIMEDOUT:
	 case EHOSTUNREACH:
	 case ENETUNREACH:
	    continue;
	 default:
	    log_info (":E: can't accept: errno = %d: %s\n",
		      errno_accept, strerror (errno_accept));
	    err_fatal_errno (__func__, ":E: can't accept");
	 }
      }

      if (_dict_daemon || dbg_test(DBG_NOFORK)) {
	 dict_daemon(childSocket,&csin,0);
      } else {
	 if (_dict_forks - _dict_reaps < _dict_daemon_limit_childs) {
	    if (!start_daemon()) { /* child */
	       int databases_loaded = (DictConfig != NULL);

	       alarm(0);
	       if (_dict_daemon_limit_time){
		  setsig (SIGALRM, handler, 0);
		  alarm(_dict_daemon_limit_time);
	       }

	       dict_daemon (childSocket, &csin, databases_loaded ? 0 : 2);

	       exit(0);
	    } else {		   /* parent */
	       close(childSocket);
	    }
	 } else {
	    dict_daemon(childSocket, &csin, 1);
	 }
      }
   }

   dict_close_databases (DictConfig);

   destroy ();
   return 0;
}
