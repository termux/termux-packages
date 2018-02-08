/* daemon.c -- Server daemon
 * Created: Fri Feb 28 18:17:56 1997 by faith@dict.org
 * Copyright 1997, 1998, 1999, 2000, 2002 Rickard E. Faith (faith@dict.org)
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
#include "index.h"
#include "data.h"
#include "md5.h"
#include "regex.h"
#include "dictdplugin.h"
#include "strategy.h"
#include "plugin.h"

#include <ctype.h>
#include <setjmp.h>

int stdin2stdout_mode = 0; /* copy stdin to stdout ( dict_dictd function ) */

static int          _dict_defines, _dict_matches;
static int          daemonS_in  = 0;
static int          daemonS_out = 1;
static const char   *daemonHostname  = NULL;
static const char   *daemonIP        = NULL;
static int          daemonPort       = -1;
static char         daemonStamp[256] = "";
static jmp_buf      env;

static int          daemonMime;

static void daemon_define( const char *cmdline, int argc, const char **argv );
static void daemon_match( const char *cmdline, int argc, const char **argv );
static void daemon_show_db( const char *cmdline, int argc, const char **argv );
static void daemon_show_strat( const char *cmdline, int argc, const char **argv );
void daemon_show_info( const char *cmdline, int argc, const char **argv );
static void daemon_show_server( const char *cmdline, int argc, const char **argv );
static void daemon_show( const char *cmdline, int argc, const char **argv );
static void daemon_option_mime( const char *cmdline, int argc, const char **argv );
static void daemon_option( const char *cmdline, int argc, const char **argv );
static void daemon_client( const char *cmdline, int argc, const char **argv );
static void daemon_auth( const char *cmdline, int argc, const char **argv );
static void daemon_status( const char *cmdline, int argc, const char **argv );
static void daemon_help( const char *cmdline, int argc, const char **argv );
static void daemon_quit( const char *cmdline, int argc, const char **argv );

#define MAXARGCS 3
static struct {
   int        argc;
   const char *name[MAXARGCS];
   void       (*f)( const char *cmdline, int argc, const char **argv );
} commandInfo[] = {
   { 1, {"define"},             daemon_define },
   { 1, {"d"},                  daemon_define },
   { 1, {"match"},              daemon_match },
   { 1, {"m"},                  daemon_match },
   { 2, {"show", "db"},         daemon_show_db },
   { 2, {"show", "databases"},  daemon_show_db },
   { 2, {"show", "strat"},      daemon_show_strat },
   { 2, {"show", "strategies"}, daemon_show_strat },
   { 2, {"show", "info"},       daemon_show_info },
   { 2, {"show", "server"},     daemon_show_server },
   { 1, {"show"},               daemon_show },
   { 2, {"option", "mime"},     daemon_option_mime },
   { 1, {"option"},             daemon_option },
   { 1, {"client"},             daemon_client },
   { 1, {"auth"},               daemon_auth },
   { 1, {"status"},             daemon_status },
   { 1, {"s"},                  daemon_status },
   { 1, {"help"},               daemon_help },
   { 1, {"h"},                  daemon_help },
   { 1, {"quit"},               daemon_quit },
   { 1, {"q"},                  daemon_quit },
};
#define COMMANDS (sizeof(commandInfo)/sizeof(commandInfo[0]))

static void *(lookup_command)( int argc, const char **argv )
{
   size_t i;
   int j;
   int err;

   for (i = 0; i < COMMANDS; i++) {
      if (argc >= commandInfo[i].argc) {
	 for (err = 0, j = 0; j < commandInfo[i].argc; j++) {
	    if (strcasecmp(argv[j], commandInfo[i].name[j])) {
	       err = 1;
	       break;
	    }
	 }
	 if (!err) return commandInfo[i].f;
      }
   }
   return NULL;
}

static unsigned long daemon_compute_mask(int bits)
{
   unsigned long mask = 0xffffffff;

   if (bits < 1) return 0;
   if (bits < 32) mask -= (1 << (32-bits)) - 1;
   return mask;
}

static void daemon_log( int type, const char *format, ... )
{
   va_list ap;
   char    buf[8*1024];
   char    *buf2;
   size_t  len;
   char    *s, *d;
   int     c;
   char    marker = '?';

   switch (type) {
   case DICT_LOG_TERM:
      if (!flg_test(LOG_STATS))    return; marker = 'I'; break;
   case DICT_LOG_TRACE:
      if (!flg_test(LOG_SERVER))   return; marker = 'I'; break;
   case DICT_LOG_CLIENT:
      if (!flg_test(LOG_CLIENT))   return; marker = 'C'; break;
   case DICT_LOG_CONNECT:
      if (!flg_test(LOG_CONNECT))  return; marker = 'K'; break;
   case DICT_LOG_DEFINE:
      if (!flg_test(LOG_FOUND))    return; marker = 'D'; break;
   case DICT_LOG_MATCH:
      if (!flg_test(LOG_FOUND))    return; marker = 'M'; break;
   case DICT_LOG_NOMATCH:
      if (!flg_test(LOG_NOTFOUND)) return; marker = 'N'; break;
   case DICT_LOG_COMMAND:
      if (!flg_test(LOG_COMMAND))  return; marker = 'T'; break;
   case DICT_LOG_AUTH:
      if (!flg_test(LOG_AUTH))     return; marker = 'A'; break;
   }

   if (dbg_test(DBG_PORT))
      snprintf(
	 buf, sizeof (buf)/2,
	 ":%c: %s:%d ", marker, daemonHostname, daemonPort );
   else if (flg_test(LOG_HOST))
      snprintf(
	 buf, sizeof (buf)/2,
	 ":%c: %s ", marker, daemonHostname );
   else
      snprintf(
	 buf, sizeof (buf)/2,
	 ":%c: ", marker );

   len = strlen( buf );

   va_start( ap, format );
   vsnprintf( buf+len, sizeof (buf)/2-len, format, ap );
   va_end( ap );
   len = strlen( buf );

   if (len >= sizeof (buf)/2) {
      log_info( ":E: buffer overflow (%d)\n", len );
      buf[2048] = '\0';
      len = strlen(buf);
   }

   buf2 = alloca( 3*(len+3) );

   for (s = buf, d = buf2; *s; s++) {
      c = (unsigned char)*s;
      if (c == '\t')      *d++ = ' ';
      else if (c == '\n') *d++ = c;
      else {
	 if (c < 32)        { *d++ = '^'; *d++ = c + 64;           }
	 else if (c == 127) { *d++ = '^'; *d++ = '?';              }
	 else                 *d++ = c;
      }
   }
   *d = '\0';
   log_info( "%s", buf2 );

   if (d != buf2) d[-1] = '\0';	/* kill newline */
   dict_setproctitle( "dictd %s", buf2 );
}

static int daemon_check_mask(const char *spec, const char *ip)
{
   char           *tmp = alloca(strlen(spec) + 1);
   char           *pt;
   char           tstring[64], mstring[64];
   struct in_addr target, mask;
   int            bits;
   unsigned long  bitmask;
   
   strcpy(tmp, spec);
   if (!(pt = strchr(tmp, '/'))) {
      log_info( ":E: No / in %s, denying access to %s\n", spec, ip);
      return DICT_DENY;
   }
   *pt++ = '\0';
   if (!*pt) {
      log_info( ":E: No bit count after / in %s, denying access to %s\n",
                spec, ip);
      return DICT_DENY;
   }
   
   inet_aton(ip, &target);
   inet_aton(tmp, &mask);
   bits = strtol(pt, NULL, 10);
   strcpy(tstring, inet_ntoa(target));
   strcpy(mstring, inet_ntoa(mask));
   if (bits < 0 || bits > 32) {
      log_info( ":E: Bit count (%d) out of range, denying access to %s\n",
                bits, ip);
      return DICT_DENY;
   }
   
   bitmask = daemon_compute_mask(bits);
   if ((ntohl(target.s_addr) & bitmask) == (ntohl(mask.s_addr) & bitmask)) {
      PRINTF(DBG_AUTH, ("%s matches %s/%d\n", tstring, mstring, bits));
      return DICT_MATCH;
   }
   PRINTF(DBG_AUTH, ("%s does NOT match %s/%d\n", tstring, mstring, bits));
   return DICT_NOMATCH;
}

static int daemon_check_range(const char *spec, const char *ip)
{
   char           *tmp = alloca(strlen(spec) + 1);
   char           *pt;
   char           tstring[64], minstring[64], maxstring[64];
   struct in_addr target, min, max;
   
   strcpy(tmp, spec);
   if (!(pt = strchr(tmp, ':'))) {
      log_info( ":E: No : in range %s, denying access to %s\n", spec, ip);
      return DICT_DENY;
   }
   *pt++ = '\0';
   if (strchr(pt, ':')) {
      log_info( ":E: More than one : in range %s, denying access to %s\n",
                spec, ip);
      return DICT_DENY;
   }
   if (!*pt) {
      log_info( ":E: Misformed range %s, denying access to %s\n", spec, ip);
      return DICT_DENY;
   }
   
   inet_aton(ip, &target);
   inet_aton(tmp, &min);
   inet_aton(pt, &max);
   strcpy(tstring, inet_ntoa(target));
   strcpy(minstring, inet_ntoa(min));
   strcpy(maxstring, inet_ntoa(max));
   if (ntohl(target.s_addr) >= ntohl(min.s_addr)
       && ntohl(target.s_addr) <= ntohl(max.s_addr)) {
      PRINTF(DBG_AUTH,("%s in range from %s to %s\n",
                       tstring, minstring, maxstring));
      return DICT_MATCH;
   }
   PRINTF(DBG_AUTH,("%s NOT in range from %s to %s\n",
                    tstring, minstring, maxstring));
   return DICT_NOMATCH;
}

static int daemon_check_wildcard(const char *spec, const char *ip)
{
   char         regbuf[256];
   char         erbuf[100];
   int          err;
   const char   *s;
   char         *d;
   regex_t      re;

   for (d = regbuf, s = spec; s && *s; ++s) {
      switch (*s) {
      case '*': *d++ = '.';  *d++ = '*'; break;
      case '.': *d++ = '\\'; *d++ = '.'; break;
      case '?': *d++ = '.';              break;
      default:  *d++ = *s;               break;
      }
   }
   *d = '\0';
   if ((err = regcomp(&re, regbuf, REG_ICASE|REG_NOSUB))) {
      regerror(err, &re, erbuf, sizeof(erbuf));
      log_info( ":E: regcomp(%s): %s\n", regbuf, erbuf );
      return DICT_DENY;	/* Err on the side of safety */
   }
   if (!regexec(&re, daemonHostname, 0, NULL, 0)
       || !regexec(&re, daemonIP, 0, NULL, 0)) {
      PRINTF(DBG_AUTH,
             ("Match %s with %s/%s\n", spec, daemonHostname, daemonIP));
      regfree(&re);
      return DICT_MATCH;
   }
   regfree(&re);
   PRINTF(DBG_AUTH,
          ("No match (%s with %s/%s)\n", spec, daemonHostname, daemonIP));
   return DICT_NOMATCH;
}

static int daemon_check_list( const char *user, lst_List acl )
{
   lst_Position p;
   dictAccess   *a;
   int          retcode;

   if (!acl)
      return DICT_ALLOW;

   for (p = lst_init_position(acl); p; p = lst_next_position(p)) {
      a = lst_get_position(p);
      switch (a->type) {
      case DICT_DENY:
      case DICT_ALLOW:
      case DICT_AUTHONLY:
         if (strchr(a->spec, '/'))
            retcode = daemon_check_mask(a->spec, daemonIP);
         else if  (strchr(a->spec, ':'))
            retcode = daemon_check_range(a->spec, daemonIP);
         else
            retcode = daemon_check_wildcard(a->spec, daemonIP);
         switch (retcode) {
         case DICT_DENY:
            return DICT_DENY;
         case DICT_MATCH:
            if (a->type == DICT_DENY) {
                daemon_log( DICT_LOG_AUTH, "spec %s denies %s/%s\n",
                            a->spec, daemonHostname, daemonIP);
            }
            return a->type;
         }
	 break;
      case DICT_USER:
	 if (user && !strcmp(user,a->spec)) return DICT_ALLOW;
      case DICT_GROUP:		/* Groups are not yet implemented. */
	 break;
      }
   }
   return DICT_DENY;
}

static int daemon_check_auth( const char *user )
{
   lst_Position p;
   lst_List     dbl = DictConfig->dbl;
   dictDatabase *db;
   
   switch (daemon_check_list( user, DictConfig->acl )) {
   default:
   case DICT_DENY:
      return 1;
   case DICT_AUTHONLY:
      if (!user) return 0;
   case DICT_ALLOW:
      for (p = lst_init_position(dbl); p; p = lst_next_position(p)) {
	 db = lst_get_position(p);
	 switch (daemon_check_list(user, db->acl)) {
	 case DICT_ALLOW: db->available = 1; continue;
	 default:         db->available = 0; continue;
	 }
      }
      break;
   }
   return 0;
}

void daemon_terminate( int sig, const char *name )
{
   alarm(0);
   tim_stop( "t" );
   close(daemonS_in);
   close(daemonS_out);
   if (name) {
      daemon_log( DICT_LOG_TERM,
		  "%s: d/m/c = %d/%d/%d; %sr %su %ss\n",
                  name,
                  _dict_defines,
                  _dict_matches,
                  _dict_comparisons,
                  dict_format_time( tim_get_real( "t" ) ),
                  dict_format_time( tim_get_user( "t" ) ),
                  dict_format_time( tim_get_system( "t" ) ) );
   } else {
      daemon_log( DICT_LOG_TERM,
		  "signal %d: d/m/c = %d/%d/%d; %sr %su %ss\n",
                  sig,
                  _dict_defines,
                  _dict_matches,
                  _dict_comparisons,
                  dict_format_time( tim_get_real( "t" ) ),
                  dict_format_time( tim_get_user( "t" ) ),
                  dict_format_time( tim_get_system( "t" ) ) );
   }

   log_close();
   longjmp(env,1);
   if (sig) exit(sig+128);

   exit(0);
}


static void daemon_write( const char *buf, int len )
{
   int left = len;
   int count;
   
   while (left) {
      if ((count = write(daemonS_out, buf, left)) != left) {
	 if (count <= 0) {
	    if (errno == EPIPE) {
	       daemon_terminate( 0, "pipe" );
	    }
#if HAVE_STRERROR
            log_info( ":E: writing %d of %d bytes:"
                      " retval = %d, errno = %d (%s)\n",
                      left, len, count, errno, strerror(errno) );
#else
            log_info( ":E: writing %d of %d bytes:"
                      " retval = %d, errno = %d\n",
                      left, len, count, errno );
#endif
            daemon_terminate( 0, __func__ );
         }
      }
      left -= count;
   }
}

static void daemon_crlf( char *d, const char *s, int dot )
{
   int first = 1;
   
   while (*s) {
      if (*s == '\n') {
	 *d++ = '\r';
	 *d++ = '\n';
	 first = 1;
	 ++s;
      } else {
	 if (dot && first && *s == '.' && s[1] == '\n')
	    *d++ = '.'; /* double first dot on line */
	 first = 0;
	 *d++ = *s++;
      }
   }
   if (dot) {                   /* add final . */
      if (!first){
	 *d++ = '\r';
	 *d++ = '\n';
      }
      *d++ = '.';
      *d++ = '\r';
      *d++ = '\n';
   }
   *d = '\0';
}

static void daemon_printf( const char *format, ... )
{
   va_list ap;
   char    buf[BUFFERSIZE];
   char    *pt;
   int     len;

   va_start( ap, format );
   vsnprintf( buf, sizeof (buf), format, ap );
   va_end( ap );
   if ((len = strlen( buf )) >= BUFFERSIZE) {
      log_info( ":E: buffer overflow: %d\n", len );
      daemon_terminate( 0, __func__ );
   }

   pt = alloca(2*len + 10); /* +10 for the case when buf == "\n"*/
   daemon_crlf(pt, buf, 0);
   daemon_write(pt, strlen(pt));
}

static void daemon_mime( void )
{
   if (daemonMime) daemon_write( "\r\n", 2 );
}

static void daemon_mime_definition (const dictDatabase *db)
{
   if (daemonMime){
      if (db -> mime_header){
	 daemon_printf ("%s", db -> mime_header);
      }

      daemon_write ("\r\n", 2);
   }
}

static void daemon_text( const char *text, int dot )
{
   char *pt = alloca( 2*strlen(text) + 10 );

   daemon_crlf(pt, text, dot);
   daemon_write(pt, strlen(pt));
}

static int daemon_read( char *buf, int count )
{
   return net_read( daemonS_in, buf, count );
}

static void daemon_ok( int code, const char *string, const char *timer )
{
   static int lastDefines     = 0;
   static int lastMatches     = 0;
   static int lastComparisons = 0;

   if (code == CODE_STATUS) {
      lastDefines     = 0;
      lastMatches     = 0;
      lastComparisons = 0;
   }

   if (!timer) {
      daemon_printf("%d %s\n", code, string);
   } else {
      tim_stop( timer );
      daemon_printf("%d %s [d/m/c = %d/%d/%d; %sr %su %ss]\n",
                    code,
                    string,
                    _dict_defines - lastDefines,
                    _dict_matches - lastMatches,
                    _dict_comparisons - lastComparisons,
                    dict_format_time( tim_get_real( timer ) ),
                    dict_format_time( tim_get_user( timer ) ),
                    dict_format_time( tim_get_system( timer ) ) );
   }

   lastDefines     = _dict_defines;
   lastMatches     = _dict_matches;
   lastComparisons = _dict_comparisons;
}

static int daemon_count_defs( lst_List list )
{
   lst_Position  p;
   dictWord      *dw;
   unsigned long previousStart = 0;
   unsigned long previousEnd   = 0;
   const char   *previousDef   = NULL;
   int           count         = 0;

   LST_ITERATE(list,p,dw) {
      if (
	 previousStart == dw->start &&
	 previousEnd   == dw->end &&
	 previousDef   == dw->def)
      {
	 continue;
      }

      previousStart = dw->start;
      previousEnd   = dw->end;
      previousDef   = dw->def;

      ++count;
   }
   return count;
}

static void daemon_dump_defs( lst_List list )
{
   lst_Position  p;
   char          *buf;
   dictWord      *dw;
   const dictDatabase  *db         = NULL;
   const dictDatabase  *db_visible = NULL;
   unsigned long previousStart = 0;
   unsigned long previousEnd   = 0;
   const char *  previousDef   = NULL;
   int count;

   LST_ITERATE(list,p,dw) {
      db = dw->database;

      if (
	 previousStart == dw->start &&
	 previousEnd   == dw->end &&
	 previousDef   == dw->def) 
      {
	 continue;
      }

      previousStart = dw->start;
      previousEnd   = dw->end;
      previousDef   = dw->def;

      buf = dict_data_obtain ( db, dw );

      if (dw -> database_visible){
	 db_visible = dw -> database_visible;
      }else{
	 db_visible = db;
      }

      daemon_printf (
	  "%d \"%s\" %s \"%s\"\n",
	  CODE_DEFINITION_FOLLOWS,
	  dw->word,
	  db_visible -> invisible ? "*" : db_visible -> databaseName,
	  db_visible -> invisible ? ""  : db_visible -> databaseShort);

      daemon_mime_definition (db);

      if (db->filter){
	 count = strlen(buf);
	 daemon_log( DICT_LOG_AUTH, "filtering with: %s\ncount: %d\n",
		     db->filter, count );

	 dict_data_filter(buf, &count, strlen (buf), db->filter);
	 buf[count] = '\0';
      }

      daemon_text(buf, 1);
      xfree( buf );
   }
}

static int daemon_count_matches( lst_List list )
{
   lst_Position p;
   dictWord     *dw;
   const char   *prevword     = NULL;
   const dictDatabase *prevdb = NULL;
   int           count        = 0;

   LST_ITERATE(list,p,dw) {
      if (prevdb == dw->database && prevword && !strcmp(prevword,dw->word))
	 continue;

      prevword = dw->word;
      prevdb   = dw->database;

      ++count;
   }
   return count;
}

static void daemon_dump_matches( lst_List list )
{
   lst_Position p;
   dictWord     *dw;
   const char   *prevword     = NULL;
   const dictDatabase *prevdb = NULL;
   const dictDatabase *db     = NULL;

   daemon_mime();
   LST_ITERATE(list,p,dw) {
      db = dw -> database;

      if (prevdb == dw->database && prevword && !strcmp(prevword,dw->word))
	  continue;

      prevword = dw->word;
      prevdb   = dw->database;

      if (dw -> database_visible){
	 db = dw -> database_visible;
      }

      daemon_printf (
	  "%s \"%s\"\n",
	  db -> invisible ? "*" : db -> databaseName,
	  dw -> word );
   }
   daemon_printf( ".\n" );
}

static void daemon_banner( void )
{
   time_t         t;

   time(&t);

   snprintf( daemonStamp, sizeof (daemonStamp), "<%d.%d.%lu@%s>", 
	    _dict_forks,
	    (int) getpid(),
	    (long unsigned)t,
	     net_hostname() );
   daemon_printf( "%d %s %s <auth.mime> %s\n",
		  CODE_HELLO,
                  net_hostname(),
		  dict_get_banner(0),
		  daemonStamp );
}

static void daemon_define( const char *cmdline, int argc, const char **argv )
{
   lst_List       list = lst_create();
   int            matches = 0;
   const char    *word;
   const char    *databaseName;
   int            extension = (argv[0][0] == 'd' && argv[0][1] == '\0');
   int            db_found = 0;

   if (extension) {
      switch (argc) {
      case 2:  databaseName = "*";     word = argv[1]; break;
      case 3:  databaseName = argv[1]; word = argv[2]; break;
      default:
	 daemon_printf( "%d syntax error, illegal parameters\n",
			CODE_ILLEGAL_PARAM );
	 return;
      }
   } else if (argc == 3) {
      databaseName = argv[1];
      word = argv[2];
   } else {
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
      return;
   }

   matches = abs(dict_search_databases (
      list, NULL,
      databaseName, word, DICT_STRAT_EXACT,
      &db_found));

   if (db_found && matches > 0) {
      int actual_matches = daemon_count_defs( list );

      _dict_defines += actual_matches;
      daemon_log( DICT_LOG_DEFINE,
		  "%s \"%s\" %d\n", databaseName, word, actual_matches);
      daemon_printf( "%d %d definitions retrieved\n",
		     CODE_DEFINITIONS_FOUND,
		     actual_matches );
      daemon_dump_defs( list );
      daemon_ok( CODE_OK, "ok", "c" );
#ifdef USE_PLUGIN
      call_dictdb_free (DictConfig->dbl);
#endif
      dict_destroy_list( list );
      return;
   }

   if (!db_found) {
#ifdef USE_PLUGIN
      call_dictdb_free (DictConfig->dbl);
#endif
      dict_destroy_list( list );
      daemon_printf( "%d invalid database, use SHOW DB for list\n",
		     CODE_INVALID_DB );
      return;
   }

#ifdef USE_PLUGIN
   call_dictdb_free (DictConfig->dbl);
#endif
   dict_destroy_list( list );
   daemon_log( DICT_LOG_NOMATCH,
	       "%s exact \"%s\"\n", databaseName, word );
   daemon_ok( CODE_NO_MATCH, "no match", "c" );
}

static void daemon_match( const char *cmdline, int argc, const char **argv )
{
   lst_List       list = lst_create();
   int            matches = 0;
   const char     *word;
   const char     *databaseName;
   const char     *strategy;
   int            strategyNumber;
   int            extension = (argv[0][0] == 'm' && argv[0][1] == '\0');
   int            db_found = 0;

   if (extension) {
      switch (argc) {
      case 2:databaseName = "*";     strategy = ".";     word = argv[1]; break;
      case 3:databaseName = "*";     strategy = argv[1]; word = argv[2]; break;
      case 4:databaseName = argv[1]; strategy = argv[2]; word = argv[3]; break;
      default:
	 daemon_printf( "%d syntax error, illegal parameters\n",
			CODE_ILLEGAL_PARAM );
	 return;
      }
   } else if (argc == 4) {
      databaseName = argv[1];
      strategy = argv[2];
      word = argv[3];
   } else {
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
      return;
   }

   if ((strategyNumber = lookup_strategy(strategy)) < 0) {
      daemon_printf( "%d invalid strategy, use SHOW STRAT for a list\n",
		     CODE_INVALID_STRATEGY );
      return;
   }

   matches = abs(dict_search_databases (
      list, NULL,
      databaseName, word, strategyNumber | DICT_MATCH_MASK,
      &db_found));

   if (db_found && matches > 0) {
      int actual_matches = daemon_count_matches( list );
      
      _dict_matches += actual_matches;
      daemon_log( DICT_LOG_MATCH,
		  "%s %s \"%s\" %d\n",
		  databaseName, strategy, word, actual_matches);
      daemon_printf( "%d %d matches found\n",
		     CODE_MATCHES_FOUND, actual_matches );
      daemon_dump_matches( list );
      daemon_ok( CODE_OK, "ok", "c" );
#ifdef USE_PLUGIN
      call_dictdb_free (DictConfig->dbl);
#endif
      dict_destroy_list( list );
      return;
   }

   if (!db_found) {
#ifdef USE_PLUGIN
      call_dictdb_free (DictConfig->dbl);
#endif
      dict_destroy_list( list );
      daemon_printf( "%d invalid database, use SHOW DB for list\n",
		     CODE_INVALID_DB );
      return;
   }

#ifdef USE_PLUGIN
   call_dictdb_free (DictConfig->dbl);
#endif
   dict_destroy_list( list );
   daemon_log( DICT_LOG_NOMATCH,
	       "%s %s \"%s\"\n", databaseName, strategy, word );
   daemon_ok( CODE_NO_MATCH, "no match", "c" );
}

static lst_Position first_database_pos (void)
{
   return lst_init_position (DictConfig->dbl);
}

static dictDatabase *next_database (
   lst_Position *databasePosition,
   const char *name)
{
   dictDatabase *db = NULL;

   assert (databasePosition);

   if (!name)
      return NULL;

   if (*name == '*' || *name == '!') {
      if (*databasePosition) {
	 do {
	    db = lst_get_position( *databasePosition );

	    *databasePosition = lst_next_position( *databasePosition );
	 } while ( db && (!db->available || db->invisible));
      }
      return db;
   } else {
      while (*databasePosition) {
         db = lst_get_position( *databasePosition );
	 *databasePosition = lst_next_position( *databasePosition );

         if (db){
	    if (
	       !db -> invisible && db->available &&
	       !strcmp(db -> databaseName,name))
	    {
	       return db;
	    }
	 }else{
	    return NULL;
	 }
      }

      return NULL;
   }
}

static int count_databases( void )
{
   int count = 0;
   const dictDatabase *db;

   lst_Position databasePosition = first_database_pos ();

   while (NULL != (db = next_database (&databasePosition, "*"))){
      assert (!db -> invisible);

      if (!db -> exit_db)
	 ++count;
   }

   return count;
}

static void destroy_word_list (lst_List l)
{
   char *word;

   while (lst_length (l)){
      word = lst_pop (l);
      if (word)
	 xfree (word);
   }
   lst_destroy (l);
}

/*
  Search for all words in word_list in the database db
 */
static int dict_search_words (
   lst_List *l,
   lst_List word_list,
   const dictDatabase *db,
   int strategy,
   int *error, int *result,
   const dictPluginData **extra_result, int *extra_result_size)
{
   lst_Position word_list_pos;
   int mc = 0;
   int matches_count = 0;
   const char *word;

   word_list_pos = lst_init_position (word_list);
   while (word_list_pos){
      word = lst_get_position (word_list_pos);

      if (word){
	 matches_count = dict_search (
	    l, word, db, strategy,
	    daemonMime,
	    result, extra_result, extra_result_size);

	 if (*result == DICT_PLUGIN_RESULT_PREPROCESS){
	    assert (matches_count > 0);

	    xfree (lst_get_position (word_list_pos));
	    lst_set_position (word_list_pos, NULL);
	 }

	 if (matches_count < 0){
	    *error = 1;
	    matches_count = abs (matches_count);
	    mc += matches_count;
	    break;
	 }

	 mc += matches_count;
      }

      word_list_pos = lst_next_position (word_list_pos);
   }

   return mc;
}

int dict_search_databases (
   lst_List *l,
   lst_Position databasePosition, /* NULL for global database list */
   const char *databaseName, const char *word, int strategy,
   int *db_found)
{
   int matches       = -1;
   int matches_count = 0;
   int error         = 0;


   const dictDatabase *db;
   dictWord *dw;
   char *p;

   lst_List preprocessed_words;
   int i;

   int                   result;
   const dictPluginData *extra_result;
   int                   extra_result_size;

   *db_found = 0;

   if (!databasePosition)
      databasePosition = first_database_pos ();

   preprocessed_words = lst_create ();
   lst_append (preprocessed_words, xstrdup(word));

   while (!error && (db = next_database (&databasePosition, databaseName))) {
      if (db -> exit_db)
	 /* dictionary_exit */
	 break;

      *db_found = 1;

      result = DICT_PLUGIN_RESULT_NOTFOUND;

      matches_count = dict_search_words (
	 l,
	 preprocessed_words, db, strategy,
	 &error,
	 &result, &extra_result, &extra_result_size);

      if (matches < 0)
	 matches = 0;

      if (result == DICT_PLUGIN_RESULT_PREPROCESS){
	 for (i=0; i < matches_count; ++i){
	    dw = lst_pop (l);
	    switch (dw -> def_size){
	    case -1:
	       p = xstrdup (dw -> word);
	       lst_append (preprocessed_words, p);
	       break;
	    case 0:
	       break;
	    default:
	       p = xmalloc (1 + dw -> def_size);
	       memcpy (p, dw -> def, dw -> def_size);
	       p [dw -> def_size] = 0;

	       lst_append (preprocessed_words, p);
	    }

	    dict_destroy_datum (dw);
	 }
      }else{
	 matches += matches_count;

	 if (result == DICT_PLUGIN_RESULT_EXIT)
	    break;

	 if (*databaseName == '*')
	    continue;
	 else if (!matches && *databaseName == '!')
	    continue;

	 break;
      }
   }

   destroy_word_list (preprocessed_words);

   return error ? -matches : matches;
}

static void daemon_show_db( const char *cmdline, int argc, const char **argv )
{
   int          count;
   const dictDatabase *db;
   
   lst_Position databasePosition;

   if (argc != 2) {
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
      return;
   }

   if (!(count = count_databases())) {
      daemon_printf( "%d no databases present\n", CODE_NO_DATABASES );
   } else {
      daemon_printf( "%d %d databases present\n",
		     CODE_DATABASE_LIST, count );

      databasePosition = first_database_pos ();

      daemon_mime();
      while ((db = next_database(&databasePosition, "*"))) {
	 assert (!db->invisible);

	 if (db -> exit_db)
	    continue;

	 daemon_printf(
	    "%s \"%s\"\n",
	    db->databaseName, db->databaseShort );
      }
      daemon_printf( ".\n" );
      daemon_ok( CODE_OK, "ok", NULL );
   }
}

static void daemon_show_strat( const char *cmdline, int argc, const char **argv )
{
   int i;

   int strat_count        = get_strategy_count ();
   dictStrategy const * const * strats = get_strategies ();

   if (argc != 2) {
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
      return;
   }

   if (strat_count){
      daemon_printf( "%d %d strategies present\n",
		     CODE_STRATEGY_LIST, strat_count );
      daemon_mime();

      for (i = 0; i < strat_count; i++) {
	 daemon_printf( "%s \"%s\"\n",
			strats [i] -> name, strats [i] -> description );
      }

      daemon_printf( ".\n" );
      daemon_ok( CODE_OK, "ok", NULL );
   }else{
      daemon_printf( "%d no strategies available\n", CODE_NO_STRATEGIES );
   }
}

void daemon_show_info(
   const char *cmdline,
   int argc, const char **argv )
{
   char         *buf=NULL;
   dictWord     *dw;
   const dictDatabase *db;
   lst_List     list;
   const char  *info_entry_name = DICT_INFO_ENTRY_NAME;

   lst_Position databasePosition = first_database_pos ();

   if (argc != 3) {
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
      return;
   }

   if ((argv[2][0] == '*' || argv[2][0] == '!') && argv[2][1] == '\0') {
      daemon_printf( "%d invalid database, use SHOW DB for list\n",
		     CODE_INVALID_DB );
      return;
   }

   list = lst_create();
   while ((db = next_database(&databasePosition, argv[2]))) {
      if (db -> databaseInfo && db -> databaseInfo [0] != '@'){
	 daemon_printf( "%d information for %s\n",
			CODE_DATABASE_INFO, argv[2] );
	 daemon_mime();
	 daemon_text(db -> databaseInfo, 1);
	 daemon_ok( CODE_OK, "ok", NULL );
	 return;
      }

      if (db -> databaseInfo && db -> databaseInfo [0] == '@')
	 info_entry_name = db -> databaseInfo + 1;

      if (dict_search (
	 list,
	 info_entry_name,
	 db, DICT_STRAT_EXACT, 0,
	 NULL, NULL, NULL))
      {
	 int i=1;
	 int list_size = lst_length (list);

	 daemon_printf( "%d information for %s\n",
			CODE_DATABASE_INFO, argv[2] );
	 daemon_mime();

	 if (db -> virtual_db){
	    daemon_printf ("The virtual dictionary `%s' includes the following:\n\n",
			   db -> databaseName);
	 }

	 for (i=1; i <= list_size; ++i){
	    dw = lst_nth_get( list, i );

	    daemon_printf ("============ %s ============\n",
			   dw -> database -> databaseName);

	    buf = dict_data_obtain( dw -> database, dw );

#ifdef USE_PLUGIN
	    call_dictdb_free (DictConfig->dbl);
#endif

	    if (buf)
	       daemon_text (buf, 0);
	 }

	 daemon_text ("\n", 1);
	 daemon_ok( CODE_OK, "ok", NULL );

	 dict_destroy_list (list);

	 return;
      } else {
#ifdef USE_PLUGIN
	 call_dictdb_free (DictConfig->dbl);
#endif

	 dict_destroy_list( list );
	 daemon_printf( "%d information for %s\n",
			CODE_DATABASE_INFO, argv[2] );
	 daemon_mime();
	 daemon_text( "No information available\n" , 1);
	 daemon_ok( CODE_OK, "ok", NULL );
	 return;
      }
   }

   dict_destroy_list( list );
   daemon_printf( "%d invalid database, use SHOW DB for list\n",
		  CODE_INVALID_DB );
}

static int daemon_get_max_dbname_length ()
{
   size_t max_len  = 0;
   size_t curr_len = 0;

   const dictDatabase *db;

   lst_Position databasePosition = first_database_pos ();

   while (NULL != (db = next_database (&databasePosition, "*"))){
      assert (!db -> invisible);

      if (db -> databaseName){
	 curr_len = strlen (db -> databaseName);

	 if (curr_len > max_len){
	    max_len = curr_len;
	 }
      }
   }

   return (int) max_len;
}

static void daemon_show_server (
   const char *cmdline,
   int argc, const char **argv)
{
   FILE          *str;
   char          buffer[1024];
   const dictDatabase  *db;
   double        uptime;

   int headwords;

   int index_size;
   char index_size_uom;

   int data_size;
   char data_size_uom;
   int data_length;
   char data_length_uom;

   int max_dbname_len;

   lst_Position databasePosition = first_database_pos ();

   daemon_printf( "%d server information\n", CODE_SERVER_INFO );
   daemon_mime();

   /* banner: dictd and OS */
   if (!site_info_no_banner){
      daemon_printf( "%s\n", dict_get_banner(0) );
   }

   /* uptime and forks */
   if (!site_info_no_uptime && !inetd){
      tim_stop("dictd");
      uptime = tim_get_real("dictd");

      daemon_printf (
	 "On %s: up %s, %d fork%s (%0.1f/hour)\n",
	 net_hostname(),
	 dict_format_time( uptime ),
	 _dict_forks,
	 _dict_forks > 1 ? "s" : "",
	 (_dict_forks/uptime)*3600.0 );

      daemon_printf ("\n");
   }

   if (!site_info_no_dblist && count_databases()) {
      daemon_printf( "Database      Headwords         Index          Data  Uncompressed\n" );

      databasePosition = first_database_pos ();

      while (db = next_database (&databasePosition, "*"),
	     db != NULL)
      {
	 headwords       = (db->index ? db->index->headwords : 0);

	 index_size      = 0;
	 index_size_uom = 'k';

	 data_size       = 0;
	 data_size_uom  = 'k';
	 data_length     = 0;
	 data_length_uom= 'k';

	 max_dbname_len = 0;

	 assert (!db -> invisible);

	 if (db->index){
	    index_size = db->index->size/1024 > 10240 ?
	       db->index->size/1024/1024 : db->index->size/1024;
	    index_size_uom = db->index->size/1024 > 10240 ? 'M' : 'k';
	 }

	 if (db->data){
	    data_size = db->data->size/1024 > 10240 ?
	       db->data->size/1024/1024 : db->data->size/1024;
	    data_size_uom = db->data->size/1024 > 10240 ? 'M' : 'k';

	    data_length = db->data->length/1024 > 10240 ?
	       db->data->length/1024/1024 : db->data->length/1024;
	    data_length_uom = db->data->length/1024 > 10240 ? 'M' : 'k';
	 }

	 max_dbname_len = daemon_get_max_dbname_length ();

	 daemon_printf(
	    "%-*.*s %10i %10i %cB %10i %cB %10i %cB\n",
	    max_dbname_len,
	    max_dbname_len,

	    db->databaseName,
	    headwords,

	    index_size,
	    index_size_uom,

	    data_size,
	    data_size_uom,

	    data_length,
	    data_length_uom);
      }

      daemon_printf ("\n");
   }

   if (site_info && (str = fopen( site_info, "r" ))) {
      while ((fgets( buffer, 1000, str ))) daemon_printf( "%s", buffer );
      fclose( str );
   }
   daemon_printf( ".\n" );
   daemon_ok( CODE_OK, "ok", NULL );
}

static void daemon_show( const char *cmdline, int argc, const char **argv )
{
   daemon_printf( "%d syntax error, illegal parameters\n",
		  CODE_ILLEGAL_PARAM );
}

static void daemon_option_mime( const char *cmdline, int argc, const char **argv )
{
   ++daemonMime;
   daemon_ok( CODE_OK, "ok - using MIME headers", NULL );
}

static void daemon_option( const char *cmdline, int argc, const char **argv )
{
   daemon_printf( "%d syntax error, illegal parameters\n",
		  CODE_ILLEGAL_PARAM );
}

static void daemon_client( const char *cmdline, int argc, const char **argv )
{
   const char *pt = strchr( cmdline, ' ' );
   
   if (pt)
      daemon_log( DICT_LOG_CLIENT, "%.200s\n", pt + 1 );
   else
      daemon_log( DICT_LOG_CLIENT, "%.200s\n", cmdline );
   daemon_ok( CODE_OK, "ok", NULL );
}

static void daemon_auth( const char *cmdline, int argc, const char **argv )
{
   char              *buf;
   hsh_HashTable     h = DictConfig->usl;
   const char        *secret;
   struct MD5Context ctx;
   unsigned char     digest[16];
   char              hex[33];
   int               i;
   int               buf_size;

   if (argc != 3)
      daemon_printf( "%d syntax error, illegal parameters\n",
		     CODE_ILLEGAL_PARAM );
   if (!h || !(secret = hsh_retrieve(h, argv[1]))) {
      daemon_log( DICT_LOG_AUTH, "%s@%s/%s denied: invalid username\n",
                  argv[1], daemonHostname, daemonIP );
      daemon_printf( "%d auth denied\n", CODE_AUTH_DENIED );
      return;
   }

   buf_size = strlen(daemonStamp) + strlen(secret) + 10;
   buf = alloca(buf_size);
   snprintf( buf, buf_size, "%s%s", daemonStamp, secret );

   MD5Init(&ctx);
   MD5Update(&ctx, (const unsigned char *) buf, strlen(buf));
   MD5Final(digest, &ctx);

   for (i = 0; i < 16; i++)
      snprintf( hex+2*i, 3, "%02x", digest[i] );

   hex[32] = '\0';

   PRINTF(DBG_AUTH,("Got %s expected %s\n", argv[2], hex ));

   if (strcmp(hex,argv[2])) {
      daemon_log( DICT_LOG_AUTH, "%s@%s/%s denied: hash mismatch\n",
                  argv[1], daemonHostname, daemonIP );
      daemon_printf( "%d auth denied\n", CODE_AUTH_DENIED );
   } else {
      daemon_printf( "%d authenticated\n", CODE_AUTH_OK );
      daemon_check_auth( argv[1] );
   }
}

static void daemon_status( const char *cmdline, int argc, const char **argv )
{
   daemon_ok( CODE_STATUS, "status", "t" );
}

static void daemon_help( const char *cmdline, int argc, const char **argv )
{
   daemon_printf( "%d help text follows\n", CODE_HELP );
   daemon_mime();
   daemon_text(
    "DEFINE database word         -- look up word in database\n"
    "MATCH database strategy word -- match word in database using strategy\n"
    "SHOW DB                      -- list all accessible databases\n"
    "SHOW DATABASES               -- list all accessible databases\n"
    "SHOW STRAT                   -- list available matching strategies\n"
    "SHOW STRATEGIES              -- list available matching strategies\n"
    "SHOW INFO database           -- provide information about the database\n"
    "SHOW SERVER                  -- provide site-specific information\n"
    "OPTION MIME                  -- use MIME headers\n"
    "CLIENT info                  -- identify client to server\n"
    "AUTH user string             -- provide authentication information\n"
    "STATUS                       -- display timing information\n"
    "HELP                         -- display this help information\n"
    "QUIT                         -- terminate connection\n\n"
    "The following commands are unofficial server extensions for debugging\n"
    "only.  You may find them useful if you are using telnet as a client.\n"
    "If you are writing a client, you MUST NOT use these commands, since\n"
    "they won't be supported on any other server!\n\n"
    "D word                       -- DEFINE * word\n"
    "D database word              -- DEFINE database word\n"
    "M word                       -- MATCH * . word\n"
    "M strategy word              -- MATCH * strategy word\n"
    "M database strategy word     -- MATCH database strategy word\n"
    "S                            -- STATUS\n"
    "H                            -- HELP\n"
    "Q                            -- QUIT\n"
   , 1);
   daemon_ok( CODE_OK, "ok", NULL );
}

static void daemon_quit( const char *cmdline, int argc, const char **argv )
{
   daemon_ok( CODE_GOODBYE, "bye", "t" );
   daemon_terminate( 0, "quit" );
}

/* The whole sub should be moved here, but I want to keep the diff small. */
int _handleconn (int error);

int dict_inetd (int error)
{
   if (setjmp(env)) return 0;

   daemonPort = -1;
   daemonIP   = "inetd";

   daemonHostname = daemonIP;

   daemonS_in        = 0;
   daemonS_out       = 1;

   return _handleconn (error);
}

int dict_daemon( int s, struct sockaddr_in *csin, int error )
{
   struct hostent *h;
	
   if (setjmp(env)) return 0;

   daemonPort = ntohs(csin->sin_port);
   daemonIP   = str_find( inet_ntoa(csin->sin_addr) );
   if ((h = gethostbyaddr((void *)&csin->sin_addr,
			  sizeof(csin->sin_addr), csin->sin_family))) {
      daemonHostname = str_find( h->h_name );
   } else
      daemonHostname = daemonIP;

   daemonS_in        = s;
   daemonS_out       = s;

   return _handleconn (error);
}

int _handleconn (int error) {
   int            query_count = 0;
   char           buf[4096];
   int            count;
   arg_List       cmdline;
   int            argc;
   char         **argv;
   void           (*command)(const char *, int, const char **);

   _dict_defines     = 0;
   _dict_matches     = 0;
   _dict_comparisons = 0;

   tim_start( "t" );
   daemon_log( DICT_LOG_TRACE, "connected\n" );
   daemon_log( DICT_LOG_CONNECT, "%s/%s connected on port %d\n",
               daemonHostname, daemonIP, daemonPort );
   dict_setproctitle( "dictd: %s connected", daemonHostname );

   if (error) {
      daemon_printf( "%d server temporarily unavailable\n",
		     CODE_TEMPORARILY_UNAVAILABLE );
      daemon_terminate( 0, "temporarily unavailable" );
   }

   if (daemon_check_auth( NULL )) {
      daemon_log( DICT_LOG_AUTH, "%s/%s denied: ip/hostname rules\n",
                  daemonHostname, daemonIP );
      daemon_printf( "%d access denied\n", CODE_ACCESS_DENIED );
      daemon_terminate( 0, "access denied" );
   }

   daemon_banner();

   if (!_dict_daemon_limit_time)
      alarm (client_delay);

   while (count = daemon_read( buf, 4000 ), count >= 0) {
      ++query_count;

      if (_dict_daemon_limit_queries &&
	  query_count >= _dict_daemon_limit_queries)
      {
	 daemon_terminate (0, "query limit");
      }

      if (stdin2stdout_mode){
	 daemon_printf( "# %s\n", buf );
      }

      if (!_dict_daemon_limit_time)
	 alarm(0);

      tim_start( "c" );
      if (!count) {
#if 0
         daemon_ok( CODE_OK, "ok", "c" );
#endif
	 continue;
      }

      daemon_log( DICT_LOG_COMMAND, "%.80s\n", buf );
      cmdline = arg_argify(buf,0);
      arg_get_vector( cmdline, &argc, &argv );
      if ((command = lookup_command (argc, (const char **) argv))) {
	 command(buf, argc, (const char **) argv);
      } else {
	 daemon_printf( "%d unknown command\n", CODE_SYNTAX_ERROR );
      }
      arg_destroy(cmdline);

      if (!_dict_daemon_limit_time)
	 alarm (client_delay);
   }
#if 0
   printf( "%d %d\n", count, errno );
#endif
   daemon_terminate( 0, "close" );
   return 0;
}
