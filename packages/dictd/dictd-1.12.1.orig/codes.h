/* codes.h -- 
 * Created: Wed Apr 16 08:44:03 1997 by faith@dict.org
 * Copyright 1997, 2000 Rickard E. Faith (faith@dict.org)
 * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
 * This program comes with ABSOLUTELY NO WARRANTY.
 */

#ifndef _CODES_H_
#define _CODES_H_

#define CODE_DATABASE_LIST           110 /* n databases present */
#define CODE_STRATEGY_LIST           111 /* n strategies available */
#define CODE_DATABASE_INFO           112 /* database information follows */
#define CODE_HELP                    113 /* help text follows */
#define CODE_SERVER_INFO             114 /* server information follows */

#define CODE_DEFINITIONS_FOUND       150 /* n definitions */
#define CODE_DEFINITION_FOLLOWS      151 /* word database name */
#define CODE_MATCHES_FOUND           152 /* n matches */

#define CODE_STATUS                  210 /* (status information here) */

#define CODE_HELLO                   220 /* text msg-id */
#define CODE_GOODBYE                 221 /* Closing Connection */

#define CODE_AUTH_OK                 230 /* Authentication Successful */

#define CODE_OK                      250 /* ok */

#define CODE_TEMPORARILY_UNAVAILABLE 420 /* server unavailable */
#define CODE_SHUTTING_DOWN           421 /* server shutting down */

#define CODE_SYNTAX_ERROR            500 /* syntax, command not recognized */
#define CODE_ILLEGAL_PARAM           501 /* syntax, illegal parameters */
#define CODE_COMMAND_NOT_IMPLEMENTED 502 /* command not implemented */
#define CODE_PARAM_NOT_IMPLEMENTED   503 /* parameter not implemented */

#define CODE_ACCESS_DENIED           530 /* access denied */
#define CODE_AUTH_DENIED             531 /* authentication denied */
#define CODE_UNKNOWN_MECH            532 /* unknown authentication mechanism */

#define CODE_INVALID_DB              550 /* invalid database */
#define CODE_INVALID_STRATEGY        551 /* invalid strategy */
#define CODE_NO_MATCH                552 /* no match */
#define CODE_NO_DATABASES            554 /* no databases */
#define CODE_NO_STRATEGIES           555 /* no strategies */

#endif
