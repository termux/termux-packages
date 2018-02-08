/* dictzip.h -- Header file for dict program
 * Created: Fri Dec  2 20:01:18 1994 by faith@dict.org
 * Copyright 1994, 1995, 1996, 1997, 2000 Rickard E. Faith (faith@dict.org)
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
 *
 */

#ifndef _DICTZIP_H_
#define _DICTZIP_H_

#include "maa.h"
#include "zlib.h"
#include "dictd.h"

				/* End of configurable things */

#define BUFFERSIZE 10240
#define DBG_VERBOSE     (0<<30|1<< 0) /* Verbose                           */
#define DBG_ZIP         (0<<30|1<< 1) /* Zip                               */
#define DBG_UNZIP       (0<<30|1<< 2) /* Unzip                             */
#define DBG_SEARCH      (0<<30|1<< 3) /* Search                            */
#define DBG_SCAN        (0<<30|1<< 4) /* Config file scan                  */
#define DBG_PARSE       (0<<30|1<< 5) /* Config file parse                 */
#define DBG_INIT        (0<<30|1<< 6) /* Database initialization           */

#define HEADER_CRC 0		/* Conflicts with gzip 1.2.4               */

/* Use of the FEXTRA fields.  The FEXTRA area can be 0xffff bytes long, 2
   bytes of which are used for the subfield ID, and 2 bytes of which are
   used for the subfield length.  This leaves 0xfffb bytes (0x7ffd 2-byte
   entries or 0x3ffe 4-byte entries).  Given that the zip output buffer must
   be 10% + 12 bytes larger than the input buffer, we can store 58969 bytes
   per entry, or about 1.8GB if the 2-byte entries are used.  If this
   becomes a limiting factor, another format version can be selected and
   defined for 4-byte entries. */


				/* Output buffer must be greater than or
                                   equal to 110% of input buffer size, plus
                                   12 bytes. */
#define OUT_BUFFER_SIZE 0xffffL

#define IN_BUFFER_SIZE ((unsigned long)((double)(OUT_BUFFER_SIZE - 12) * 0.89))

#define PREFILTER_IN_BUFFER_SIZE (IN_BUFFER_SIZE * 0.89)


/* For gzip-compatible header, as defined in RFC 1952 */

				/* Magic for GZIP (rfc1952)                */
#define GZ_MAGIC1     0x1f	/* First magic byte                        */
#define GZ_MAGIC2     0x8b	/* Second magic byte                       */

				/* FLaGs (bitmapped), from rfc1952         */
#define GZ_FTEXT      0x01	/* Set for ASCII text                      */
#define GZ_FHCRC      0x02	/* Header CRC16                            */
#define GZ_FEXTRA     0x04	/* Optional field (random access index)    */
#define GZ_FNAME      0x08	/* Original name                           */
#define GZ_COMMENT    0x10	/* Zero-terminated, human-readable comment */
#define GZ_MAX           2	/* Maximum compression                     */
#define GZ_FAST          4	/* Fasted compression                      */

				/* These are from rfc1952                  */
#define GZ_OS_FAT        0	/* FAT filesystem (MS-DOS, OS/2, NT/Win32) */
#define GZ_OS_AMIGA      1	/* Amiga                                   */
#define GZ_OS_VMS        2	/* VMS (or OpenVMS)                        */
#define GZ_OS_UNIX       3      /* Unix                                    */
#define GZ_OS_VMCMS      4      /* VM/CMS                                  */
#define GZ_OS_ATARI      5      /* Atari TOS                               */
#define GZ_OS_HPFS       6      /* HPFS filesystem (OS/2, NT)              */
#define GZ_OS_MAC        7      /* Macintosh                               */
#define GZ_OS_Z          8      /* Z-System                                */
#define GZ_OS_CPM        9      /* CP/M                                    */
#define GZ_OS_TOPS20    10      /* TOPS-20                                 */
#define GZ_OS_NTFS      11      /* NTFS filesystem (NT)                    */
#define GZ_OS_QDOS      12      /* QDOS                                    */
#define GZ_OS_ACORN     13      /* Acorn RISCOS                            */
#define GZ_OS_UNKNOWN  255      /* unknown                                 */

#define GZ_RND_S1       'R'	/* First magic for random access format    */
#define GZ_RND_S2       'A'	/* Second magic for random access format   */

#define GZ_ID1           0	/* GZ_MAGIC1                               */
#define GZ_ID2           1	/* GZ_MAGIC2                               */
#define GZ_CM            2	/* Compression Method (Z_DEFALTED)         */
#define GZ_FLG	         3	/* FLaGs (see above)                       */
#define GZ_MTIME         4	/* Modification TIME                       */
#define GZ_XFL           8	/* eXtra FLags (GZ_MAX or GZ_FAST)         */
#define GZ_OS            9	/* Operating System                        */
#define GZ_XLEN         10	/* eXtra LENgth (16bit)                    */
#define GZ_FEXTRA_START 12	/* Start of extra fields                   */
#define GZ_SI1          12	/* Subfield ID1                            */
#define GZ_SI2          13      /* Subfield ID2                            */
#define GZ_SUBLEN       14	/* Subfield length (16bit)                 */
#define GZ_VERSION      16      /* Version for subfield format             */
#define GZ_CHUNKLEN     18	/* Chunk length (16bit)                    */
#define GZ_CHUNKCNT     20	/* Number of chunks (16bit)                */
#define GZ_RNDDATA      22	/* Random access data (16bit)              */

#define DICT_UNKNOWN    0
#define DICT_TEXT       1
#define DICT_GZIP       2
#define DICT_DZIP       3


#endif
