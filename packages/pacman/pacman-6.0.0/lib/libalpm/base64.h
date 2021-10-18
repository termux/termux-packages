/**
 * \file base64.h
 *
 *  Copyright (C) 2006-2010, Brainspark B.V.
 *
 *  This file is part of PolarSSL (http://www.polarssl.org)
 *  Lead Maintainer: Paul Bakker <polarssl_maintainer at polarssl.org>
 *
 *  All rights reserved.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef BASE64_H
#define BASE64_H

#include <string.h>

#define POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL               -0x0010  /**< Output buffer too small. */
#define POLARSSL_ERR_BASE64_INVALID_CHARACTER              -0x0012  /**< Invalid character in input. */

#if 0
/**
 * \brief          Encode a buffer into base64 format
 *
 * \param dst      destination buffer
 * \param dlen     size of the buffer
 * \param src      source buffer
 * \param slen     amount of data to be encoded
 *
 * \return         0 if successful, or POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL.
 *                 *dlen is always updated to reflect the amount
 *                 of data that has (or would have) been written.
 *
 * \note           Call this function with *dlen = 0 to obtain the
 *                 required buffer size in *dlen
 */
int base64_encode( unsigned char *dst, size_t *dlen,
                   const unsigned char *src, size_t slen );
#endif

/**
 * \brief          Decode a base64-formatted buffer
 *
 * \param dst      destination buffer
 * \param dlen     size of the buffer
 * \param src      source buffer
 * \param slen     amount of data to be decoded
 *
 * \return         0 if successful, POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL, or
 *                 POLARSSL_ERR_BASE64_INVALID_DATA if the input data is not
 *                 correct. *dlen is always updated to reflect the amount
 *                 of data that has (or would have) been written.
 *
 * \note           Call this function with *dlen = 0 to obtain the
 *                 required buffer size in *dlen
 */
int base64_decode( unsigned char *dst, size_t *dlen,
                   const unsigned char *src, size_t slen );

#endif /* base64.h */
