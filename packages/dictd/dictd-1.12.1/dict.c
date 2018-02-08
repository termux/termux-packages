/* dict.c -- 
 * Created: Fri Mar 28 19:16:29 1997 by faith@dict.org
 * Copyright 1997-2002 Rickard E. Faith (faith@dict.org)
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

#include "dict.h"
#include "parse.h"
#include "md5.h"
#include <stdarg.h>

extern int         yy_flex_debug;
       lst_List    dict_Servers;
       FILE        *dict_output;
       FILE        *dict_error;
       int         formatted;
       int         flush;

const char *host_connected    = NULL;
const char *service_connected = NULL;

#define BUFFERSIZE  2048
#define PIPESIZE     256
#define DEF_STRAT    "."
#define DEF_DB       "*"

#define CMD_PRINT     0
#define CMD_DEFPRINT  1
#define CMD_CONNECT   2
#define CMD_CLIENT    3
#define CMD_AUTH      4
#define CMD_INFO      5
#define CMD_SERVER    6
#define CMD_DBS       7
#define CMD_STRATS    8
#define CMD_HELP      9
#define CMD_MATCH    10
#define CMD_DEFINE   11
#define CMD_SPELL    12
#define CMD_WIND     13
#define CMD_CLOSE    14
#define CMD_OPTION_MIME 15

struct cmd {
   int        command;
   int        sent;
   int        flag;
   const char *host;
   const char *service;
   const char *database;
   const char *strategy;
   const char *word;
   const char *client;
   const char *user;
   const char *key;
   const char *comment;
};

lst_List      cmd_list;
unsigned long client_defines;
unsigned long client_bytes;
unsigned long client_pipesize = PIPESIZE;
char          *client_text    = NULL;

int option_mime = 0;

int ex_status = 0;
static void set_ex_status (int status)
{
   if (!ex_status)
      ex_status = status;
}

#define EXST_NO_MATCH                20
#define EXST_APPROX_MATCHES          21
#define EXST_NO_DATABASES            22
#define EXST_NO_STRATEGIES           23

#define EXST_UNEXPECTED              30
#define EXST_TEMPORARILY_UNAVAILABLE 31
#define EXST_SHUTTING_DOWN           32
#define EXST_SYNTAX_ERROR            33
#define EXST_ILLEGAL_PARAM           34
#define EXST_COMMAND_NOT_IMPLEMENTED 35
#define EXST_PARAM_NOT_IMPLEMENTED   36
#define EXST_ACCESS_DENIED           37
#define EXST_AUTH_DENIED             38
#define EXST_INVALID_DB              39
#define EXST_INVALID_STRATEGY        40
#define EXST_CONNECTION_FAILED       41

struct def {
   lst_List   data;
   const char *word;
   const char *db;
   const char *dbname;
};

struct reply {
   int        s;
   const char *host;
   const char *service;
   const char *user;
   const char *key;
   const char *msgid;
   const char *word;
   lst_List   data;
   int        retcode;
   int        count;		/* definitions found */
   int        matches;		/* matches found */
   int        match;		/* doing match found */
   int        listed;		/* Databases or strategies listed */
   struct def *defs;
} cmd_reply;

static const char *cpy( const char *s )
{
   if (!s || !*s) return NULL;
   return str_copy(s);
}

static void client_crlf( char *d, const char *s )
{
   int flag = 0;
   
   while (*s) {
      if (*s == '\n') {
	 *d++ = '\r';
	 *d++ = '\n';
	 ++s;
	 ++flag;
      } else {
	 *d++ = *s++;
	 flag = 0;
      }
   }
   if (!flag) {
      *d++ = '\r';
      *d++ = '\n';
   }
   *d = '\0';
}

static void unexpected_status_code (
   int expected_status, int act_status,
   const char *message)
{
   switch (act_status){
   case CODE_TEMPORARILY_UNAVAILABLE:
      fprintf (stderr,
	       "%s\n",
	       (message ? message : "Server temporarily unavailable"));
      exit (EXST_TEMPORARILY_UNAVAILABLE);

   case CODE_SHUTTING_DOWN:
      fprintf (stderr,
	       "%s\n", (message ? message : "Server shutting down"));
      exit (EXST_SHUTTING_DOWN);

   case CODE_SYNTAX_ERROR:
      fprintf (stderr,
	       "%s\n", (message ? message : "Command not recognized"));
      exit (EXST_SYNTAX_ERROR);

   case CODE_ILLEGAL_PARAM:
      fprintf (stderr,
	       "%s\n", (message ? message : "Illegal parameters"));
      exit (EXST_ILLEGAL_PARAM);

   case CODE_COMMAND_NOT_IMPLEMENTED:
      fprintf (stderr,
	       "%s\n", (message ? message : "Command not implemented"));
      exit (EXST_COMMAND_NOT_IMPLEMENTED);

   case CODE_PARAM_NOT_IMPLEMENTED:
      fprintf (stderr,
	       "%s\n", (message ? message : "Parameter not implemented"));
      exit (EXST_PARAM_NOT_IMPLEMENTED);

   case CODE_ACCESS_DENIED:
      fprintf (stderr,
	       "%s\n", (message ? message : "Access denied"));
      exit (EXST_ACCESS_DENIED);

   case CODE_AUTH_DENIED:
      fprintf (stderr,
	       "%s\n", (message ? message : "Authentication denied"));
      exit (EXST_AUTH_DENIED);

   case CODE_INVALID_DB:
      fprintf (stderr,
	       "%s\n", (message ? message : "Invalid database"));
      exit (EXST_INVALID_DB);

   case CODE_INVALID_STRATEGY:
      fprintf (stderr,
	       "%s\n", (message ? message : "Invalid strategy"));
      exit (EXST_INVALID_STRATEGY);

   case CODE_NO_MATCH:
      fprintf (stderr,
	       "%s\n", (message ? message : "No matches found"));
      exit (EXST_NO_MATCH);

   case CODE_NO_DATABASES:
      fprintf (stderr,
	       "%s\n", (message ? message : "No databases"));
      exit (EXST_NO_DATABASES);

   case CODE_NO_STRATEGIES:
      fprintf (stderr,
	       "%s\n", (message ? message : "No strategies"));
      exit (EXST_NO_STRATEGIES);

   default:
      fprintf (stderr,
	       "Unexpected status code %d (%s), wanted %d\n",
	       act_status,
	       (message ? message : "no message"),
	       expected_status);

      exit (EXST_UNEXPECTED);
   }
}

static void client_open_pager( void )
{
   dict_output = stdout;
   dict_error  = stderr;
}

static void client_close_pager( void )
{
   fflush (dict_output);
}

static lst_List client_read_text( int s )
{
   lst_List l = lst_create();
   char     line[BUFFERSIZE];
   int      len;

   while ((len = net_read(s, line, BUFFERSIZE - 1)) >= 0) {
      line [len] = 0;

      client_bytes += len;
      PRINTF(DBG_RAW,("* Text: %s\n",line));
      if (line[0] == '.' && line[1] == '\0') break;
      if (len >= 2 && line[0] == '.' && line[1] == '.') 
	 lst_append( l, xstrdup(line + 1) );
      else
	 lst_append( l, xstrdup(line) );
   }
   if (len < 0) {
       client_close_pager();
       err_fatal_errno( __func__, "Error reading from socket\n" );
   }
   return l;
}

static void client_print_text( lst_List l, int print_host_port )
{
   lst_Position p;
   const char   *e;

   if (!l) return;

   if (formatted && print_host_port){
      fprintf (dict_output, "%s\t%s\n", host_connected, service_connected);
   }

   LST_ITERATE(l,p,e) fprintf( dict_output, "  %s\n", e );
}

static void client_print_definitions (const struct def *r)
{
   if (formatted){
      fprintf (dict_output, "%s\t%s\t", host_connected, service_connected);

      if (r -> dbname && r -> db)
      {
	 fprintf( dict_output, "%s\t%s\n", r -> db, r -> dbname);
      } else if (r -> dbname) {
	 fprintf( dict_output, "%s\n", r -> dbname );
      } else if (r -> db) {
	 fprintf( dict_output, "%s\n", r -> db );
      } else {
	 fprintf( dict_output, "unknown\n" );
      }
   }else{
      fprintf (dict_output, "\nFrom ");
      if (r -> dbname && r -> db)
      {
	 fprintf( dict_output, "%s [%s]",
		  r -> dbname,
		  r -> db);
      } else if (r -> dbname) {
	 fprintf( dict_output, "%s", r -> dbname );
      } else if (r -> db) {
	 fprintf( dict_output, "%s", r -> db );
      } else {
	 fprintf( dict_output, "unknown" );
      }

      fprintf( dict_output, ":\n\n" );
   }

   client_print_text( r -> data, 0 );
}

static void client_print_matches( lst_List l, int flag, const char *word )
{
   lst_Position p;
   const char   *e;
   arg_List     a;
   const char   *prev = NULL;
   const char   *last;
   const char   *db;
   static int   first = 1;
   int          pos = 0;
   int          len;
   int          count;
   int          empty_line_found = 0;

   const char  *arg0 = NULL;
   const char  *arg1 = NULL;

   count = 0;
   if (l) {
      last = NULL;
      LST_ITERATE(l,p,e) {
	 if (last && !strcmp(last,e)) continue;
	 ++count;
	 last = e;
      }
   } else {
       if (flag)
           fprintf( dict_error, "No matches found for \"%s\"\n", word );
       set_ex_status (EXST_NO_MATCH);
       return;
   }

   last = NULL;
   LST_ITERATE(l,p,e) {
      /* skip MIME header */
      if (option_mime && !empty_line_found){
	 empty_line_found = (e [0] == 0 ||
			     (e [0] == '\r' && e [1] == 0));
	 continue;
      }

      /* */
      if (last && !strcmp(last,e)) continue;
      last = e;
      a = arg_argify( e, 0 );
      if (arg_count(a) != 2)
	 err_internal( __func__,
		       "MATCH command didn't return 2 args: \"%s\"\n", e );

      arg0 = arg_get (a,0);
      arg1 = arg_get (a,1);

      if (formatted){
	 fprintf (dict_output, "%s\t%s\t%s\t%s\n",
		  host_connected, service_connected, arg0, arg1);
      }else{
	 if ((db = str_find(arg0)) != prev) {
	    if (!first) fprintf( dict_output, "\n" );
	    first = 0;
	    fprintf( dict_output, "%s:", db );
	    prev = db;
	    pos = 6 + strlen(db);
	 }
	 len = strlen(arg1);
	 if (pos + len + 4 > 70) {
	    fprintf( dict_output, "\n" );
	    pos = 0;
	 }
	 if (strchr (arg1,' ')) {
	    fprintf( dict_output, "  \"%s\"", arg1 );
	    pos += len + 4;
	 } else {
	    fprintf( dict_output, "  %s", arg1 );
	    pos += len + 2;
	 }
      }

      arg_destroy(a);
   }
   fprintf( dict_output, "\n" );
}

static void client_print_listed( lst_List l )
{
   lst_Position p;
   const char   *e;
   arg_List     a;
   int          colWidth = 10; /* minimum size of first column */
   int          colMax = 16; /* maximum size of unragged first column */
   char         format[32];
   int          empty_line_found = 0;
   int len;

   if (!l) return;
   LST_ITERATE(l,p,e) {
      /* skip MIME header */
      if (option_mime && !empty_line_found){
	 empty_line_found = (e [0] == 0 ||
			     (e [0] == '\r' && e [1] == 0));
	 continue;
      }

      /* */
      a = arg_argify( e, 0 );
      if (arg_count(a) != 2)
	 err_internal( __func__,
		       "SHOW command didn't return 2 args: \"%s\"\n", e );

      len = strlen (arg_get (a,0));

      if (len > colWidth && len <= colMax)
        colWidth = len;

      arg_destroy(a);
   }

   snprintf( format, sizeof (format), " %%-%ds %%s\n", colWidth );

   empty_line_found = 0;

   LST_ITERATE(l,p,e) {
      /* skip MIME header */
      if (option_mime && !empty_line_found){
	 empty_line_found = (e [0] == 0 ||
			     (e [0] == '\r' && e [1] == 0));
	 continue;
      }

      /* */
      a = arg_argify( e, 0 );

      if (formatted){
	 assert (host_connected);
	 assert (service_connected);

	 fprintf (dict_output, "%s\t%s\t%s\t%s\n",
		  host_connected, service_connected, arg_get (a,0), arg_get (a,1));
      }else{
	 fprintf (dict_output, format, arg_get (a,0), arg_get (a,1));
      }

      arg_destroy(a);
   }
}

static void client_free_text( lst_List l )
{
   lst_Position p;
   char         *e;

   if (!l) return;
   LST_ITERATE(l,p,e) {
      if (e) xfree(e);
   }
   lst_destroy(l);
}

static int client_read_status( int s,
			       const char **message,
			       int *count,
			       const char **word,
			       const char **db,
			       const char **dbname,
			       const char **msgid )
{
   static char buf[BUFFERSIZE];
   arg_List    cmdline;
   int         argc;
   char        **argv;
   int         status;
   char        *start, *end, *p;
   int         len;

   if ((len = net_read( s, buf, BUFFERSIZE )) < 0) {
      client_close_pager();
      err_fatal_errno( __func__, "Error reading from socket\n" );
   }
   client_bytes += len;
   PRINTF(DBG_RAW,("* Read: %s\n",buf));

   if ((status = atoi(buf)) < 100) status = 600;
   PRINTF(DBG_RAW,("* Status = %d\n",status));

   if (message && (p = strchr(buf, ' '))) *message = p + 1;

   if (count)  *count = 0;
   if (word)   *word = NULL;
   if (db)     *db = NULL;
   if (dbname) *dbname = NULL;
   if (msgid)  *msgid = NULL;

   switch (status) {
   case CODE_HELLO:
      if ((start = strrchr(buf, '<')) && (end = strrchr(buf,'>'))) {
	 end[1] = '\0';
	 *msgid = str_copy( start );
	 PRINTF(DBG_VERBOSE,("Msgid is \"%s\"\n",*msgid));
      }
      break;
   case CODE_DATABASE_LIST:
   case CODE_STRATEGY_LIST:
   case CODE_DEFINITIONS_FOUND:
   case CODE_MATCHES_FOUND:
      cmdline = arg_argify(buf,0);
      arg_get_vector( cmdline, &argc, &argv );
      if (argc > 1 && count) *count = atoi(argv[1]);
      arg_destroy(cmdline);
      break;
   case CODE_DEFINITION_FOLLOWS:
      cmdline = arg_argify(buf,0);
      arg_get_vector( cmdline, &argc, &argv );
      if (argc > 1 && word)   *word   = str_find(argv[1]);
      if (argc > 2 && db)     *db     = str_find(argv[2]);
      if (argc > 3 && dbname) *dbname = str_find(argv[3]);
      arg_destroy(cmdline);
      break;
   default:
      break;
   }

   return status;
}

static struct cmd *make_command( int command, ... )
{
   va_list    ap;
   struct cmd *c = xmalloc( sizeof( struct cmd ) );

   memset( c, 0, sizeof( struct cmd ) );
   c->command = command;

   va_start( ap, command );
   switch (command) {
   case CMD_PRINT:
      c->comment  = va_arg( ap, const char * );
      break;
   case CMD_DEFPRINT:
      c->database = va_arg( ap, const char * );
      c->word     = va_arg( ap, const char * );
      c->flag     = va_arg( ap, int );
      break;
   case CMD_CONNECT:
      c->host     = va_arg( ap, const char * );
      c->service  = va_arg( ap, const char * );
      c->user     = va_arg( ap, const char * );
      c->key      = va_arg( ap, const char * );
      break;
   case CMD_CLIENT:
      c->client   = va_arg( ap, const char * );
      break;
   case CMD_AUTH:
      break;
   case CMD_INFO:
      c->database = va_arg( ap, const char * );
      break;
   case CMD_SERVER:
      break;
   case CMD_DBS:
      break;
   case CMD_STRATS:
      break;
   case CMD_HELP:
      break;
   case CMD_MATCH:
      c->database = va_arg( ap, const char * );
      c->strategy = va_arg( ap, const char * );
      c->word     = va_arg( ap, const char * );
      break;
   case CMD_DEFINE:
      c->database = va_arg( ap, const char * );
      c->word     = va_arg( ap, const char * );
      break;
   case CMD_SPELL:
      c->database = va_arg( ap, const char * );
      c->word     = va_arg( ap, const char * );
      break;
   case CMD_WIND:
      c->database = va_arg( ap, const char * );
      c->strategy = va_arg( ap, const char * );
      c->word     = va_arg( ap, const char * );
      break;
   case CMD_CLOSE:
      break;
   case CMD_OPTION_MIME:
      break;
   default:
      err_internal( __func__, "Illegal command %d\n", command );
   }
   va_end( ap );

   return c;
}

static void append_command( struct cmd *c )
{
   if (!cmd_list) cmd_list = lst_create();
   lst_append( cmd_list, c );
}


static void prepend_command( struct cmd *c )
{
   if (!cmd_list) cmd_list = lst_create();
   lst_push( cmd_list, c );
}


static void request( void )
{
   char              b[BUFFERSIZE];
   char              *buffer = alloca( client_pipesize );
   char              *p = buffer;
   lst_Position      pos;
   struct cmd        *c = NULL;
   unsigned char     digest[16];
   char              hex[33];
   struct MD5Context ctx;
   int               i;
   unsigned          len;
   int               total = 0;
   int               count = 0;

   *p = '\0';
   c = lst_top(cmd_list);
   if (c->command == CMD_CONNECT) {
      cmd_reply.user = c->user;
      cmd_reply.key  = c->key;
   }
      
   LST_ITERATE(cmd_list,pos,c) {
      b[0] = '\0';
      len = 0;
      PRINTF(DBG_PIPE,("* Looking at request %d\n",c->command));
      if (c->sent) {
	 PRINTF(DBG_PIPE,("* Skipping\n"));
	 return;	/* FIXME!  Keep sending deeper things? */
      }
      ++count;
      switch( c->command) {
      case CMD_PRINT:                                                 break;
      case CMD_DEFPRINT:                                              break;
      case CMD_CONNECT:                                               break;
      case CMD_AUTH:
	 if (!cmd_reply.key || !cmd_reply.user)                       break;
	 if (!cmd_reply.msgid)                                        goto end;
	 MD5Init(&ctx);
	 MD5Update(&ctx, (const unsigned char *) cmd_reply.msgid, strlen(cmd_reply.msgid));
	 MD5Update(&ctx, (const unsigned char *) cmd_reply.key, strlen(cmd_reply.key));
	 MD5Final(digest, &ctx );
	 for (i = 0; i < 16; i++)
	    sprintf( hex+2*i, "%02x", digest[i] );
	 hex[32] = '\0';
	 snprintf( b, BUFFERSIZE, "auth %s %s\n", cmd_reply.user, hex );
	 break;
      case CMD_CLIENT:
         if (client_text)
            snprintf( b, BUFFERSIZE, "client \"%s: %s\"\n",
                            c->client, client_text );
         else
            snprintf( b, BUFFERSIZE, "client \"%s\"\n", c->client );
         break;
      case CMD_INFO:   snprintf( b, BUFFERSIZE, "show info %s\n",
                                       c->database );                 break;
      case CMD_SERVER: snprintf( b, BUFFERSIZE, "show server\n" );    break;
      case CMD_DBS:    snprintf( b, BUFFERSIZE, "show db\n" );        break;
      case CMD_STRATS: snprintf( b, BUFFERSIZE, "show strat\n" );     break;
      case CMD_HELP:   snprintf( b, BUFFERSIZE, "help\n" );           break;
      case CMD_MATCH:
	 cmd_reply.word = c->word;
	 snprintf( b, BUFFERSIZE,
			 "match %s %s \"%s\"\n",
			 c->database, c->strategy, c->word );         break;
      case CMD_DEFINE:
	 cmd_reply.word = c->word;
	 snprintf( b, BUFFERSIZE, "define %s \"%s\"\n",
			 c->database, c->word );                      break;
      case CMD_SPELL:                                                 goto end;
      case CMD_WIND:                                                  goto end;
      case CMD_CLOSE:  snprintf( b, BUFFERSIZE, "quit\n" );           break;
      case CMD_OPTION_MIME: snprintf( b, BUFFERSIZE, "option mime\n" );    break;
      default:
	 err_internal( __func__, "Unknown command %d\n", c->command );
      }
      len = strlen(b);
      if (total + len + 3 > client_pipesize) {
	 if (count == 1 && p == buffer && total == 0) {
				/* The buffer is too small, but we have to
				   send something...  */
	    PRINTF(DBG_PIPE,("* Reallocating buffer to %d bytes\n",len+1));
	    p = buffer = alloca( len + 1 );
	 } else {
	    break;
	 }
      }
      strcpy( p, b );
      p += len;
      total += len;
      ++c->sent;
      if (dbg_test(DBG_SERIAL)) break; /* Don't pipeline. */
   }

end:				/* Ready to send buffer, but are we
				   connected? */
   if (!cmd_reply.s) {
      c = lst_top(cmd_list);
      if (c->command != CMD_CONNECT) {
	 err_internal( __func__, "Not connected, but no CMD_CONNECT\n" );
      }
      if ((cmd_reply.s = net_connect_tcp( c->host,
					     c->service
					     ? c->service
					     : DICT_DEFAULT_SERVICE )) < 0) {
	 const char *message;
	 
	 switch (cmd_reply.s) {
	 case NET_NOHOST:     message = "Can't get host entry for";     break;
	 case NET_NOSERVICE:  message = "Can't get service entry for";  break;
	 case NET_NOPROTOCOL: message = "Can't get protocol entry for"; break;
	 case NET_NOCONNECT:  message = "Can't connect to";             break;
	 default:             message = "Unknown error for";            break;
	 }
	 PRINTF(DBG_VERBOSE,("%s %s.%s\n",
			     message,
			     c->host,
			     c->service ? c->service : DICT_DEFAULT_SERVICE));
	 if (lst_length(cmd_list) > 1) {
	    c = lst_nth_get(cmd_list,2);
	    if (c->command == CMD_CONNECT) {
				/* undo pipelining */
	       cmd_reply.s = 0;
	       if (!dbg_test(DBG_SERIAL)) {
		  LST_ITERATE(cmd_list,pos,c) c->sent = 0;
	       }
	       return;
	    }
	 }
         client_close_pager();
	 fprintf (stderr, "Cannot connect to any servers%s\n",\
		  dbg_test(DBG_VERBOSE) ? "" : " (use -v to see why)" );
	 exit (EXST_CONNECTION_FAILED);
      }
      cmd_reply.host    = c->host;
      cmd_reply.service = c->service ? c->service : DICT_DEFAULT_SERVICE;
      cmd_reply.user    = c->user;
      cmd_reply.key     = c->key;
   }
   if ((len = strlen(buffer))) {
      char *pt;

      PRINTF(DBG_PIPE,("* Sending %d commands (%d bytes)\n",count,len));
      PRINTF(DBG_RAW,("* Send/%d: %s",c->command,buffer));
      pt = alloca(2*len);
      client_crlf(pt,buffer);
      net_write( cmd_reply.s, pt, strlen(pt) );
   } else {
      PRINTF(DBG_PIPE,("* Sending nothing\n"));
      PRINTF(DBG_RAW,("* Send/%d\n",c->command)); 
   }
}

static void process( void )
{
   struct cmd *c;
   int        expected;
   const char *message = NULL;
   int        i;
   int        *listed;
   FILE       *old;

   while ((c = lst_top( cmd_list ))) {
      request();		/* Send requests */
      lst_pop( cmd_list );
      expected = CODE_OK;
      switch (c->command) {
      case CMD_PRINT:
	 if (!formatted){
	    if (c->comment) fprintf( dict_output, "%s", c->comment );
	 }

	 if (cmd_reply.match)
	    client_print_matches( cmd_reply.data, 1, cmd_reply.word );
	 else if (cmd_reply.listed)
	    client_print_listed( cmd_reply.data );
	 else
	    client_print_text( cmd_reply.data, 1 );

	 if (flush){
	    fflush (dict_output);
	 }

	 client_free_text( cmd_reply.data );
	 cmd_reply.data = NULL;
	 cmd_reply.matches = cmd_reply.match = cmd_reply.listed = 0;
	 expected = cmd_reply.retcode;
	 break;
      case CMD_DEFPRINT:
	 if (cmd_reply.count) {
	    if (c->flag) {
	       fprintf( dict_output, "%d definition%s found",
			cmd_reply.count,
			cmd_reply.count == 1 ? "" : "s" );
	       fprintf( dict_output, "\n" );
	    }
	    for (i = 0; i < cmd_reply.count; i++) {
	       client_print_definitions (&cmd_reply.defs [i]);

	       if (flush){
		  fflush (dict_output);
	       }

	       client_free_text( cmd_reply.defs[i].data );
	       cmd_reply.defs[i].data = NULL;
	    }
	    xfree( cmd_reply.defs );
	    cmd_reply.count = 0;

	 } else if (cmd_reply.matches) {
	    fprintf( dict_error,
		     "No definitions found for \"%s\", perhaps you mean:",
		     c->word );
	    fprintf( dict_error, "\n" );

	    old = dict_output;
	    dict_output = dict_error;
	    client_print_matches( cmd_reply.data, 0, c->word );
	    dict_output = old;

	    if (flush){
	       fflush (dict_output);
	    }

	    client_free_text( cmd_reply.data );
	    cmd_reply.data = NULL;
	    cmd_reply.matches = 0;

	    set_ex_status (EXST_APPROX_MATCHES);
	 } else {
	    fprintf( dict_error,
		     "No definitions found for \"%s\"\n", c->word );

	    set_ex_status (EXST_NO_MATCH);
	 }

	 expected = cmd_reply.retcode;
	 break;
      case CMD_CONNECT:
	 if (!cmd_reply.s) break; /* Connection failed, continue; */
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 NULL, NULL, NULL, NULL,
						 &cmd_reply.msgid );
	 if (cmd_reply.retcode == CODE_ACCESS_DENIED) {
            client_close_pager();
	    err_fatal( NULL,
		       "Access to server %s.%s denied when connecting\n",
		    cmd_reply.host,
		    cmd_reply.service );
	 }

	 /* */
	 host_connected    = c -> host;
	 if (c -> service)
	    service_connected = c -> service;
	 else
	    service_connected = DICT_DEFAULT_SERVICE;

	 /* */
	 expected = CODE_HELLO;
	 while (((struct cmd *)lst_top(cmd_list))->command == CMD_CONNECT)
	    lst_pop(cmd_list);

	 break;
      case CMD_OPTION_MIME:
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 NULL, NULL, NULL, NULL, NULL);
	 if (cmd_reply.retcode != expected && dbg_test(DBG_VERBOSE))
	    fprintf( dict_error, "Client command gave unexpected status code %d (%s)\n",
		    cmd_reply.retcode, message ? message : "no message" );

	 expected = cmd_reply.retcode;
	 break;
      case CMD_CLIENT:
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 NULL, NULL, NULL, NULL, NULL);
	 if (cmd_reply.retcode != expected && dbg_test(DBG_VERBOSE))
	    fprintf( dict_error, "Client command gave unexpected status code %d (%s)\n",
		    cmd_reply.retcode, message ? message : "no message" );

/*	 set_ex_status (cmd_reply.retcode); */

	 expected = cmd_reply.retcode;
	 break;
      case CMD_AUTH:
	 if (!cmd_reply.key || !cmd_reply.user || !cmd_reply.msgid) {
	    expected = cmd_reply.retcode;
	    break;
	 }
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 NULL, NULL, NULL, NULL, NULL);
	 expected = CODE_AUTH_OK;
	 if (cmd_reply.retcode == CODE_AUTH_DENIED) {
	    err_warning( NULL,
			 "Authentication to %s.%s denied\n",
			 cmd_reply.host,
			 cmd_reply.service );
	    expected = CODE_AUTH_DENIED;
	 }
	 break;
      case CMD_INFO:
	 expected = CODE_DATABASE_INFO;
	 listed = NULL;
	 goto gettext;
      case CMD_SERVER:
	 expected = CODE_SERVER_INFO;
	 listed = NULL;
	 goto gettext;
      case CMD_HELP:
	 expected = CODE_HELP;
	 listed = NULL;
	 goto gettext;
      case CMD_DBS:
	 expected = CODE_DATABASE_LIST;
	 listed = &cmd_reply.listed;
	 goto gettext;
      case CMD_STRATS:
	 expected = CODE_STRATEGY_LIST;
	 listed = &cmd_reply.listed;
	 goto gettext;
   gettext:
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 listed,
						 NULL, NULL, NULL, NULL);
	 if (cmd_reply.retcode == expected) {
	    cmd_reply.data = client_read_text( cmd_reply.s );
	    cmd_reply.retcode = client_read_status( cmd_reply.s,
						    &message,
						    NULL,NULL,NULL,NULL,NULL);
	    expected = CODE_OK;
	 }
	 break;
      case CMD_DEFINE:
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 &cmd_reply.count,
						 NULL, NULL, NULL, NULL );
	 if (!client_defines) tim_start( "define" );
	 switch (expected = cmd_reply.retcode) {
	 case CODE_DEFINITIONS_FOUND:
	    cmd_reply.defs = xmalloc(cmd_reply.count*sizeof(struct def));
	    expected = CODE_DEFINITION_FOLLOWS;
	    for (i = 0; i < cmd_reply.count; i++) {
	       ++client_defines;
	       cmd_reply.retcode
		  = client_read_status( cmd_reply.s,
					&message,
					NULL,
					&cmd_reply.defs[i].word,
					&cmd_reply.defs[i].db,
					&cmd_reply.defs[i].dbname,
					NULL );
	       if (cmd_reply.retcode != expected) goto error;
	       cmd_reply.defs[i].data = client_read_text( cmd_reply.s );
	    }
	    expected = CODE_OK;
	    cmd_reply.retcode = client_read_status( cmd_reply.s,
						    &message,
						    NULL,NULL,NULL,NULL,NULL );
	    break;
	 case CODE_NO_MATCH:
	    PRINTF(DBG_VERBOSE,
		   ("No match found for \"%s\" in %s\n",c->word,c->database));
	    break;
	 case CODE_INVALID_DB:
	    fprintf(stderr, "%s is not a valid database, use -D for a list\n",
		    c->database );
	    set_ex_status (EXST_INVALID_DB);
	    break;
	 case CODE_NO_DATABASES:
	    fprintf( dict_error, "There are no databases currently available\n" );

	    set_ex_status (EXST_NO_DATABASES);

	    break;
	 default:
	    expected = CODE_OK;
	 }
   error:
	 break;
      case CMD_MATCH:
	 cmd_reply.match = 1;
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 &cmd_reply.matches,
						 NULL, NULL, NULL, NULL );
	 switch (expected = cmd_reply.retcode) {
	 case CODE_MATCHES_FOUND:
	    cmd_reply.data = client_read_text( cmd_reply.s );
	    expected = CODE_OK;
	    cmd_reply.retcode = client_read_status( cmd_reply.s,
						    &message,
						    NULL,NULL,NULL,NULL,NULL );
	    break;
	 case CODE_TEMPORARILY_UNAVAILABLE:
	    fprintf (stderr,
		    "Server temporarily unavailable\n");

	    set_ex_status (EXST_TEMPORARILY_UNAVAILABLE);

	    break;
	 case CODE_NO_MATCH:
	    PRINTF(DBG_VERBOSE,
		   ("No match found in %s for \"%s\" using %s\n",
		    c->database,c->word,c->strategy));

	    set_ex_status (EXST_NO_MATCH);

	    break;
	 case CODE_INVALID_DB:
	    fprintf( dict_error,
		     "%s is not a valid database, use -D for a list\n",
		     c->database );

	    set_ex_status (EXST_INVALID_DB);

	    break;
	 case CODE_INVALID_STRATEGY:
	    fprintf( dict_error,
		     "%s is not a valid search strategy, use -S for a list\n",
		     c->strategy );

	    set_ex_status (EXST_INVALID_STRATEGY);

	    break;
	 case CODE_NO_DATABASES:
	    fprintf( dict_error,
		     "There are no databases currently available\n" );

	    set_ex_status (EXST_NO_DATABASES);

	    break;
	 case CODE_NO_STRATEGIES:
	    fprintf( dict_error,
		     "There are no search strategies currently available\n" );

	    set_ex_status (EXST_NO_STRATEGIES);

	    break;
	 default:
	    expected = CODE_OK;
	 }
	 break;
      case CMD_SPELL:
	 if (cmd_reply.retcode == CODE_NO_MATCH) {
	    prepend_command( make_command( CMD_MATCH,
					   c->database, DEF_STRAT, c->word ) );
	 }
	 expected = cmd_reply.retcode;
	 break;
      case CMD_WIND:
	  if (cmd_reply.matches) {
	    if (!cmd_reply.data)
	       err_internal( __func__,
			     "%d matches, but no list\n", cmd_reply.matches );

	    for (i = cmd_reply.matches; i > 0; --i) {
	       /* skip MIME header */
	       const char *line = lst_nth_get( cmd_reply.data, i );
	       arg_List   a;
	       const char *orig, *s;
	       char       *escaped, *d;

	       if (option_mime){
		  if (line [0] == 0 ||
		      (line [0] == '\r' && line [1] == '\0'))
		  {
		     break;
		  }
	       }

	       /* */
	       a = arg_argify( line, 0 );
	       if (arg_count(a) != 2)
		  err_internal( __func__,
				"MATCH command didn't return 2 args: \"%s\"\n",
				line );

	       prepend_command( make_command( CMD_DEFPRINT,
					      str_find(arg_get(a,0)),
					      str_copy(arg_get(a,1)),
					      0 ) );

				/* Escape " and \ in word before sending */
	       orig    = arg_get(a,1);
	       escaped = xmalloc(strlen(orig) * 2 + 1);
	       for (s = orig, d = escaped; *s;) {
		   switch (*s) {
		   case '"':
		   case '\\':
		       *d++ = '\\';
		   default:
		       *d++ = *s++;
		   }
	       }
	       *d++ = '\0';
	       prepend_command( make_command( CMD_DEFINE,
					      str_find(arg_get(a,0)),
					      str_copy(escaped),
					      0 ) );
	       xfree(escaped);
	       arg_destroy(a);
	    }
	    client_free_text( cmd_reply.data );
	    cmd_reply.matches = 0;
	 } else {
	    fprintf( dict_error, "No matches found for \"%s\"", c->word );
	    fprintf( dict_error, "\n" );

	    set_ex_status (EXST_NO_MATCH);
	 }
	 expected = cmd_reply.retcode;
	 break;
      case CMD_CLOSE:
	 cmd_reply.retcode = client_read_status( cmd_reply.s,
						 &message,
						 NULL, NULL, NULL, NULL, NULL);
	 expected = CODE_GOODBYE;
	 break;
      default:
	 err_internal( __func__, "Illegal command %d\n", c->command );
      }
      if (cmd_reply.s && cmd_reply.retcode != expected) {
         client_close_pager();
	 unexpected_status_code (expected, cmd_reply.retcode, message);
      }
      PRINTF(DBG_RAW,("* Processed %d\n",c->command));
      xfree(c);
   }
}

#if 0
static void handler( int sig )
{
   const char *name = NULL;
   
   switch (sig) {
   case SIGHUP:  name = "SIGHUP";  break;
   case SIGINT:  name = "SIGINT";  break;
   case SIGQUIT: name = "SIGQUIT"; break;
   case SIGILL:  name = "SIGILL";  break;
   case SIGTRAP: name = "SIGTRAP"; break;
   case SIGTERM: name = "SIGTERM"; break;
   case SIGPIPE: name = "SIGPIPE"; break;
   }

   if (name)
      err_fatal( __func__, "Caught %s, exiting\n", name );
   else
      err_fatal( __func__, "Caught signal %d, exiting\n", sig );

   exit(0);
}

static void setsig( int sig, void (*f)(int) )
{
   struct sigaction   sa;
   
   sa.sa_handler = f;
   sigemptyset(&sa.sa_mask);
   sa.sa_flags = 0;
   sigaction(sig, &sa, NULL);
}
#endif

static void client_config_print( FILE *stream, lst_List c )
{
   FILE         *s = stream ? stream : stderr;
   lst_Position p;
   dictServer   *e;

   printf( "Configuration file:\n" );
   LST_ITERATE(dict_Servers,p,e) {
      if (e->port || e->user || e->secret) {
	 fprintf( s, "   server %s {\n", e->host );
	 if (e->port) fprintf( s, "      port %s\n", e->port );
	 if (e->user) fprintf( s, "      user %s %s\n",
			       e->user,
			       e->secret ? "*" : "(none)" );
	 fprintf( s, "   }\n" );
      } else {
	 fprintf( s, "   server %s\n", e->host );
      }
   }
}

static const char *id_string (void)
{
   static char buffer[BUFFERSIZE];

   snprintf( buffer, BUFFERSIZE, "%s", DICT_VERSION );
   
   return buffer;
}

static const char *client_get_banner( void )
{
   static char       *buffer= NULL;
   struct utsname    uts;
   
   if (buffer) return buffer;
   uname( &uts );
   buffer = xmalloc(256);
   snprintf( buffer, 256,
	     "%s %s/rf on %s %s", err_program_name (), id_string (),
	     uts.sysname, uts.release );
   return buffer;
}

static void banner( FILE *out_stream )
{
   fprintf( out_stream , "%s\n", client_get_banner() );
   fprintf( out_stream, 
	    "Copyright 1997-2002 Rickard E. Faith (faith@dict.org)\n" );
   fprintf( out_stream,
	    "Copyright 2002-2007 Aleksey Cheusov (vle@gmx.net)\n" );
   fprintf( out_stream, "\n" );
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
   
   banner ( stdout );
   while (*p) fprintf( stdout, "   %s\n", *p++ );
}

static void help( FILE *out_stream )
{
   static const char *help_msg[] = {
   "Usage: dict [options] [word]",
   "Query a dictd server for the definition of a word", 
   "",
      "-h --host <server>        specify server",
      "-p --port <service>       specify port",
      "-d --database <dbname>    select a database to search",
      "-m --match                match instead of define",
      "-s --strategy <strategy>  strategy for matching or defining",
      "-c --config <file>        specify configuration file",
      "-C --nocorrect            disable attempted spelling correction",
      "-D --dbs                  show available databases",
      "-S --strats               show available search strategies",
      "-H --serverhelp           show server help",
      "-i --info <dbname>        show information about a database",
      "-I --serverinfo           show information about the server",
      "-a --noauth               disable authentication",
      "-u --user <username>      username for authentication",
      "-k --key <key>            shared secret for authentication",
      "-V --version              display version information",
      "-L --license              display copyright and license information",
      "   --help                 display this help",
      "-v --verbose              be verbose",
      "-r --raw                  trace raw transaction",
      "   --debug <flag>         set debugging flag",
      "   --pipesize <size>      specify buffer size for pipelining (256)",
      "   --client <text>        additional text for client command",
      "-M --mime                 send OPTION MIME command if server supports it",
      "-f --formatted            use strict tabbed format of output",
      0 };
   const char        **p = help_msg;

   banner( out_stream );
   while (*p) fprintf( out_stream, "%s\n", *p++ );
}

int main( int argc, char **argv )
{
   int                c;
   const char         *host       = NULL;
   const char         *service    = NULL;
   const char         *user       = NULL;
   const char         *key        = NULL;
   const char         *database   = DEF_DB;
   const char         *strategy   = DEF_STRAT;
   const char         *configFile = NULL;
   const char         *word       = NULL;
   int                doauth      = 1;
   int                docorrect   = 1;
   int                offset      = 0;
   int                i;
   enum { DEFINE = 0x0001,
	  MATCH  = 0x0002,
	  INFO   = 0x0010,
	  SERVER = 0x0020,
	  DBS    = 0x0040,
	  STRATS = 0x0080,
	  HELP        = 0x0100,
	  OPTION_MIME = 0x0200,
   }      function    = DEFINE;
   struct option      longopts[]  = {
      { "host",       1, 0, 'h' },
      { "port",       1, 0, 'p' },
      { "database",   1, 0, 'd' },
      { "info",       1, 0, 'i' },
      { "serverinfo", 0, 0, 'I' },
      { "match",      0, 0, 'm' },
      { "strategy",   1, 0, 's' },
      { "nocorrect",  0, 0, 'C' },
      { "config",     1, 0, 'c' },
      { "dbs",        0, 0, 'D' },
      { "strats",     0, 0, 'S' },
      { "serverhelp", 0, 0, 'H' },
      { "noauth",     0, 0, 'a' },
      { "user",       1, 0, 'u' },
      { "key",        1, 0, 'k' },
      { "version",    0, 0, 'V' },
      { "license",    0, 0, 'L' },
      { "help",       0, 0, 501 },
      { "verbose",    0, 0, 'v' },
      { "raw",        0, 0, 'r' },
      { "pager",      1, 0, 'P' },
      { "debug",      1, 0, 502 },
      { "pipesize",   1, 0, 504 },
      { "client",     1, 0, 505 },
      { "mime",       1, 0, 'M' },
      { "formatted",  0, 0, 'f' },
      { "flush",      0, 0, 'F' },
      { 0,            0, 0,  0  }
   };

   dict_output = stdout;
   dict_error  = stderr;

   maa_init (argv[0]);

   dbg_register( DBG_VERBOSE, "verbose" );
   dbg_register( DBG_RAW,     "raw" );
   dbg_register( DBG_SCAN,    "scan" );
   dbg_register( DBG_PARSE,   "parse" );
   dbg_register( DBG_PIPE,    "pipe" );
   dbg_register( DBG_SERIAL,  "serial" );
   dbg_register( DBG_TIME,    "time" );
   dbg_register( DBG_URL,     "url" );

   while ((c = getopt_long( argc, argv,
			    "h:p:d:i:Ims:DSHau:c:Ck:VLvrP:MfF",
			    longopts, NULL )) != EOF)
   {
      switch (c) {
      case 'h': host = optarg;                         break;
      case 'p': service = optarg;                      break;
      case 'd': database = optarg;                     break;
      case 'i': database = optarg; function |= INFO;   break;
      case 'I':                    function |= SERVER; break;
      case 'm': function &= ~DEFINE; function |= MATCH; break;
      case 's': strategy = optarg;                     break;
      case 'D':                    function |= DBS;    break;
      case 'S':                    function |= STRATS; break;
      case 'H':                    function |= HELP;   break;
      case 'M': option_mime = 1; function |= OPTION_MIME;   break;
      case 'c': configFile = optarg;                   break;
      case 'C': docorrect = 0;                         break;
      case 'a': doauth = 0;                            break;
      case 'u': user = optarg;                         break;
      case 'k': key = optarg;                          break;
      case 'V': banner( stdout ); exit(1);             break;
      case 'L': license(); exit(1);                    break;
      case 'v': dbg_set( "verbose" );                  break;
      case 'r': dbg_set( "raw" );                      break;
      case 'P':
	 if (strcmp (optarg, "-")){
	    fprintf (stderr, "Option --pager is now deprecated");
	    exit (1);
	 }
	 break;
      case 505: client_text = optarg;                  break;
      case 504: client_pipesize = atoi(optarg);        break;
      case 502: dbg_set( optarg );                     break;
      case 501:	help( stdout );	exit(1);               break;	      
      case 'f': formatted = 1;                         break;
      case 'F': flush = 1;                         break;
      default:  help( stderr ); exit(1);               break;
      }
   }

   if (optind == argc && (!(function & ~(DEFINE|MATCH)))) {
      banner( stderr );
      fprintf( stderr, "Use --help for help\n" );
      exit(1);
   }

   if (client_pipesize > 1000000) client_pipesize = 1000000;
   
   if (dbg_test(DBG_PARSE))     prs_set_debug(1);
   if (dbg_test(DBG_SCAN))      yy_flex_debug = 1;
   else                         yy_flex_debug = 0;

   if (configFile) {
      prs_file_nocpp( configFile );
   } else {
      char b[256];
      char *env = getenv("HOME");

      snprintf( b, 256, "%s/%s", env ? env : "./", DICT_RC_NAME );
      PRINTF(DBG_VERBOSE,("Trying %s...\n",b));
      if (!access(b, R_OK)) {
	 prs_file_nocpp(b);
      } else {
	 PRINTF(DBG_VERBOSE,("Trying %s...\n",
			     DICT_CONFIG_PATH DICT_CONFIG_NAME));
	 if (!access( DICT_CONFIG_PATH DICT_CONFIG_NAME, R_OK ))
	    prs_file_nocpp( DICT_CONFIG_PATH DICT_CONFIG_NAME );
      }
   }
   if (dbg_test(DBG_VERBOSE)) {
      if (dict_Servers) client_config_print( NULL, dict_Servers );
      else              fprintf( stderr, "No configuration\n" );
   }

   if (optind < argc && !strncmp(argv[optind],"dict://",7)) {
      char *p;
      int  state, fin;
      char *s;

/*  dict://<user>:<passphrase>@<host>:<port>/d:<word>:<database>:<n>
           000000 111111111111 222222 333333 4 555555 6666666666 777

    dict://<user>:<passphrase>@<host>/d:<word>:<database>:<n>
           000000 111111111111 222222 4 555555 6666666666 777
	   
    dict://<host>:<port>/d:<word>:<database>:<n>
           000000 111111 4 555555 6666666666 777
	   
    dict://<host>/d:<word>:<database>:<n>
           000000 4 555555 6666666666 777
	   
    dict://<host>/d:<word>:<database>:<n>
           000000 4 555555 6666666666 777
	   
    dict://<user>:<passphrase>@<host>:<port>/m:<word>:<database>:<strat>:<n>
           000000 111111111111 222222 333333 4 555555 6666666666 7777777 888
	   
    dict://<host>:<port>/m:<word>:<database>:<strat>:<n>
           000000 111111 4 555555 6666666666 7777777 888

    dict://<host>/m:<word>:<database>:<strat>:<n>
           000000 4 555555 6666666666 7777777 888
	   
*/

      for (s = p = argv[optind] + 7, state = 0, fin = 0; !fin; ++p) {
	 switch (*p) {
	 case '\0': ++fin;
	 case ':':
	    switch (state) {
	    case 0: *p = '\0'; host = user = cpy(s);     ++state; s=p+1; break;
	    case 2: *p = '\0'; host = cpy(s);            ++state; s=p+1; break;
	    case 4:
	       if (s == p - 1) {
		  if (*s == 'd') function = DEFINE;
		  else if (*s == 'm') function = MATCH;
		  else {
		     PRINTF(DBG_URL,("State = %d, s = %s\n",state,s));
                     client_close_pager();
		     err_fatal( NULL, "Parse error at %s\n", p );
		  }
		                                         ++state; s=p+1; break;
	       } else {
		  PRINTF(DBG_URL,("State = %d, s = %s\n",state,s));
                  client_close_pager();
		  err_fatal( NULL, "Parse error at %s\n", p );
	       }
	       break;
	    case 5: *p = '\0'; word = cpy(s);            ++state; s=p+1; break;
	    case 6: *p = '\0'; database = cpy(s);        ++state; s=p+1; break;
	    case 7: *p = '\0';
	       if (function == DEFINE) offset = atoi(s);
	       else                    strategy = cpy(s);
	                                                 ++state; s=p+1; break;
	    case 8: *p = '\0';
	       if (function == MATCH) offset = atoi(s); ++state; s=p+1; break;
				/* FALLTHROUGH */
	    default:
	       PRINTF(DBG_URL,("State = %d, s = %s\n",state,s));
               client_close_pager();
	       err_fatal( NULL, "Parse error at %s\n", p );
	    }
	    break;
	 case '@':
	    switch (state) {
	    case 1: *p = '\0'; key = xstrdup(s);         ++state; s=p+1; break;
	    default:
	       PRINTF(DBG_URL,("State = %d, s = %s\n",state,s));
               client_close_pager();
	       err_fatal( NULL, "Parse error at %s\n", p );
	    }
	    break;
	 case '/':
	    switch (state) {
	    case 0: *p = '\0'; host = xstrdup(s);      state = 4; s=p+1; break;
	    case 1: *p = '\0'; service = xstrdup(s);   state = 4; s=p+1; break;
	    case 2: *p = '\0'; host = xstrdup(s);      state = 4; s=p+1; break;
	    default:
	       PRINTF(DBG_URL,("State = %d, s = %s\n",state,s));
               client_close_pager();
	       err_fatal( NULL, "Parse error at %s\n", p );
	    }
	    break;
	 }
      }

      if (!key)      user = NULL;
      if (!database) database = DEF_DB;
      if (!strategy) strategy = DEF_STRAT;
      
      if (dbg_test(DBG_URL)) {
	 printf( "user = %s, passphrase = %s\n",
		 user ? user : "(null)", key ? key : "(null)" );
	 printf( "host = %s, port = %s\n",
		 host ? host : "(null)", service ? service : "(null)" );
	 printf( "word = %s, database = %s, strategy = %s\n",
		 word ? word : "(null)",
		 strategy ? strategy : "(null)",
		 database ? database : "(null)" );
      }
      if (host && !host[0]) {   /* Empty host causes default to be used. */
          xfree((void *)host);
          host = NULL;
      }
   }

#if 0
   setsig(SIGHUP,  handler);
   setsig(SIGINT,  handler);
   setsig(SIGQUIT, handler);
   setsig(SIGILL,  handler);
   setsig(SIGTRAP, handler);
   setsig(SIGTERM, handler);
   setsig(SIGPIPE, handler);
#endif

   fflush(stdout);
   fflush(stderr);

   tim_start("total");

   if (host) {
      append_command( make_command( CMD_CONNECT, host, service, user, key ) );
   } else {
      lst_Position p;
      dictServer   *s;

      if (dict_Servers) {
	 LST_ITERATE(dict_Servers,p,s) {
	    append_command( make_command( CMD_CONNECT,
					  s->host,
					  s->port,
					  s->user,
					  s->secret ) );
	 }
#ifdef USE_DICT_ORG
      }
      append_command(make_command(CMD_CONNECT,"dict.org",     NULL,user,key));
      append_command(make_command(CMD_CONNECT,"alt0.dict.org",NULL,user,key));
#else
      }else{
	 fprintf (stderr, "'dict.conf' doesn't specify any dict server\n");
	 exit (1);
      }
#endif
   }
   append_command( make_command( CMD_CLIENT, client_get_banner() ) );
   if (doauth) append_command( make_command( CMD_AUTH ) );
   if (function & OPTION_MIME) {
      append_command( make_command( CMD_OPTION_MIME ) );
      append_command( make_command( CMD_PRINT, NULL ) );
   }
   if (function & INFO) {
      append_command( make_command( CMD_INFO, database ) );
      append_command( make_command( CMD_PRINT, NULL ) );
   }
   if (function & SERVER) {
      append_command( make_command( CMD_SERVER ) );
      append_command( make_command( CMD_PRINT, NULL ) );
   }
   if (function & DBS) {
      append_command( make_command( CMD_DBS ) );
      append_command( make_command( CMD_PRINT, "Databases available:\n" ) );
   }
   if (function & STRATS) {
      append_command( make_command( CMD_STRATS ) );
      append_command( make_command( CMD_PRINT, "Strategies available:\n" ) );
   }
   if (function & HELP) {
      append_command( make_command( CMD_HELP ) );
      append_command( make_command( CMD_PRINT, "Server help:\n" ) );
   }

   if (function & MATCH) {
      if (word) {
	 append_command( make_command( CMD_MATCH, database, strategy, word ) );
	 append_command( make_command( CMD_PRINT, NULL ) );
      } else {
	 for (i = optind; i < argc; i++) {
	    append_command( make_command( CMD_MATCH,
					  database, strategy, argv[i] ) );
	    append_command( make_command( CMD_PRINT, NULL ) );
	 }
      }
   } else if (function & DEFINE) {
      if (word) {
	 append_command( make_command( CMD_DEFINE, database, word ) );
	 append_command( make_command( CMD_DEFPRINT, database, word, 1 ) );
      } else {
	 for (i = optind; i < argc; i++) {
	    if (!strcmp(strategy, DEF_STRAT)) {
	       append_command( make_command( CMD_DEFINE, database, argv[i] ) );
	       if (docorrect)
		  append_command( make_command( CMD_SPELL, database, argv[i]));
	       append_command( make_command(CMD_DEFPRINT,database,argv[i],1) );
	    } else {
	       append_command( make_command( CMD_MATCH,
					     database, strategy, argv[i] ) );
	       append_command( make_command( CMD_WIND,
					     database, strategy, argv[i] ) );
	    }
	 }
      }
   }
   append_command( make_command( CMD_CLOSE ) );

   if (!dbg_test(DBG_VERBOSE|DBG_TIME)) client_open_pager();
   process();
   client_close_pager();
   
   if (dbg_test(DBG_TIME)) {
      fprintf( dict_output, "\n" );
      tim_stop("total");
      if (client_defines) {
	 tim_stop("define");
	 fprintf( stderr,
		  "* %ld definitions in %.2fr %.2fu %.2fs"
		  " => %.1f d/sec\n",
		  client_defines,
		  tim_get_real( "define" ),
		  tim_get_user( "define" ),
		  tim_get_system( "define" ),
		  client_defines / tim_get_real( "define" ) );
      }
      fprintf( stderr,
	       "* %ld bytes total in %.2fr %.2fu %.2fs => %.0f bps\n",
	       client_bytes,
	       tim_get_real( "total" ),
	       tim_get_user( "total" ),
	       tim_get_system( "total" ),
	       client_bytes / tim_get_real( "total" ) );
   }

   return ex_status;
}
