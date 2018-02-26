/*
 *  This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
 * USA.
 *
 * Project home page: http://github.com/termux-packages/termux
 * Twaik Yont <twaikyont@gmail.com>
 */

#ifdef  __cplusplus
extern "C" {
#endif

const char *termux_passwd_hash(char* pass);
int termux_change_passwd(const char *user, const char *user_hash);
int termux_auth(const char *user, const char *user_hash);

#ifdef  __cplusplus
}
#endif
