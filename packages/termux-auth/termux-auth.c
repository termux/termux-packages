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

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <termux-auth.h>
#include <openssl/md5.h>

#ifndef TERMUX_PASS_HASH
#define TERMUX_PASS_HASH "/data/data/com.termux/files/home/.ssh/access_hash"
#endif

#define HASH_LENGTH MD5_DIGEST_LENGTH*2

const char *read_hashfile(void){
	int hashfile;
	unsigned int hash;

	hashfile = open(TERMUX_PASS_HASH, O_RDONLY);
	if (hashfile<0) {
		perror("Can not open repository file");
	}
		
	char *readhash = malloc(HASH_LENGTH+1);
	memset(readhash, 0, HASH_LENGTH+1);
		read(hashfile, readhash, HASH_LENGTH);
	close(hashfile);
	
	return readhash;
}

const char *termux_passwd_hash(char* pass){
	unsigned char md5digest[MD5_DIGEST_LENGTH];
	memset(md5digest, 0, MD5_DIGEST_LENGTH);
	//Make compiler happy
	MD5((const unsigned char*) pass, strlen(pass), md5digest);
	
	char *md5 = malloc(MD5_DIGEST_LENGTH*2+1);
	memset(md5, 0, MD5_DIGEST_LENGTH*2+1);
	int i; for(i=0; i < MD5_DIGEST_LENGTH; i++) {
		char temp[3];
		snprintf(temp,sizeof(temp),"%02x",md5digest[i]);

		if(i == 0) strncpy(md5,temp,3);
		else strncat(md5,temp,MD5_DIGEST_LENGTH);
	}
	return md5;
}

int termux_change_passwd(const char *user, const char *user_hash){
	const char *u = user; //ignoring, not needed yet
	
	int hashfile;
	unsigned char *hash;
	unlink(TERMUX_PASS_HASH);
	hashfile = open(TERMUX_PASS_HASH, O_WRONLY | O_EXCL | O_CREAT);
	chmod(TERMUX_PASS_HASH, 0600);
	dprintf(hashfile, "%s\n", user_hash);
	close(hashfile);
	
	return 0;
}

int termux_auth(const char *user, const char *user_hash){
	const char *u = user; //ignoring, not needed yet
	const char *passwd_hash = read_hashfile();
	sleep(1); //protection from bruteforce
	return strcmp((const char*)passwd_hash, user_hash) == 0;
}
