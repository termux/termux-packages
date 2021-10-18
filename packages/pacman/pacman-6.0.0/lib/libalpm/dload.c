/*
 *  dload.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
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

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h> /* setsockopt, SO_KEEPALIVE */
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h> /* IPPROTO_TCP */
#endif
#ifdef HAVE_NETINET_TCP_H
#include <netinet/tcp.h> /* TCP_KEEPINTVL, TCP_KEEPIDLE */
#endif

#ifdef HAVE_LIBCURL
#include <curl/curl.h>
#endif

/* libalpm */
#include "dload.h"
#include "alpm_list.h"
#include "alpm.h"
#include "log.h"
#include "util.h"
#include "handle.h"

#ifdef HAVE_LIBCURL

/* RFC1123 states applications should support this length */
#define HOSTNAME_SIZE 256

static int curl_add_payload(alpm_handle_t *handle, CURLM *curlm,
	struct dload_payload *payload, const char *localpath);
static int curl_gethost(const char *url, char *buffer, size_t buf_len);

/* number of "soft" errors required to blacklist a server, set to 0 to disable
 * server blacklisting */
const unsigned int server_error_limit = 3;

struct server_error_count {
	char server[HOSTNAME_SIZE];
	unsigned int errors;
};

static struct server_error_count *find_server_errors(alpm_handle_t *handle, const char *server)
{
	alpm_list_t *i;
	struct server_error_count *h;
	char hostname[HOSTNAME_SIZE];
	/* key off the hostname because a host may serve multiple repos under
	 * different url's and errors are likely to be host-wide */
	if(curl_gethost(server, hostname, sizeof(hostname)) != 0) {
		return NULL;
	}
	for(i = handle->server_errors; i; i = i->next) {
		h = i->data;
		if(strcmp(hostname, h->server) == 0) {
			return h;
		}
	}
	if((h = calloc(sizeof(struct server_error_count), 1))
			&& alpm_list_append(&handle->server_errors, h)) {
		strcpy(h->server, hostname);
		h->errors = 0;
		return h;
	} else {
		free(h);
		return NULL;
	}
}

static int should_skip_server(alpm_handle_t *handle, const char *server)
{
	struct server_error_count *h;
	if(server_error_limit && (h = find_server_errors(handle, server)) ) {
		return h->errors >= server_error_limit;
	}
	return 0;
}

static void server_increment_error(alpm_handle_t *handle, const char *server, int count)
{
	struct server_error_count *h;
	if(server_error_limit
			&& (h = find_server_errors(handle, server))
			&& !should_skip_server(handle, server) ) {
		h->errors += count;

		if(should_skip_server(handle, server)) {
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("too many errors from %s, skipping for the remainder of this transaction\n"),
					h->server);
		}
	}
}

static void server_soft_error(alpm_handle_t *handle, const char *server)
{
	server_increment_error(handle, server, 1);
}

static void server_hard_error(alpm_handle_t *handle, const char *server)
{
	server_increment_error(handle, server, server_error_limit);
}

static const char *get_filename(const char *url)
{
	char *filename = strrchr(url, '/');
	if(filename != NULL) {
		return filename + 1;
	}

	/* no slash found, it's a filename */
	return url;
}

static char *get_fullpath(const char *path, const char *filename,
		const char *suffix)
{
	char *filepath;
	/* len = localpath len + filename len + suffix len + null */
	size_t len = strlen(path) + strlen(filename) + strlen(suffix) + 1;
	MALLOC(filepath, len, return NULL);
	snprintf(filepath, len, "%s%s%s", path, filename, suffix);

	return filepath;
}

enum {
	ABORT_SIGINT = 1,
	ABORT_OVER_MAXFILESIZE
};

static int dload_interrupted;

static int dload_progress_cb(void *file, curl_off_t dltotal, curl_off_t dlnow,
		curl_off_t UNUSED ultotal, curl_off_t UNUSED ulnow)
{
	struct dload_payload *payload = (struct dload_payload *)file;
	off_t current_size, total_size;
	alpm_download_event_progress_t cb_data = {0};

	/* avoid displaying progress bar for redirects with a body */
	if(payload->respcode >= 300) {
		return 0;
	}

	/* SIGINT sent, abort by alerting curl */
	if(dload_interrupted) {
		return 1;
	}

	if(dlnow < 0 || dltotal <= 0 || dlnow > dltotal) {
		/* bogus values : stop here */
		return 0;
	}

	current_size = payload->initial_size + dlnow;

	/* is our filesize still under any set limit? */
	if(payload->max_size && current_size > payload->max_size) {
		dload_interrupted = ABORT_OVER_MAXFILESIZE;
		return 1;
	}

	/* none of what follows matters if the front end has no callback */
	if(payload->handle->dlcb == NULL) {
		return 0;
	}

	total_size = payload->initial_size + dltotal;

	if(payload->prevprogress == total_size) {
		return 0;
	}

	/* do NOT include initial_size since it wasn't part of the package's
	 * download_size (nor included in the total download size callback) */
	cb_data.total = dltotal;
	cb_data.downloaded = dlnow;
	payload->handle->dlcb(payload->handle->dlcb_ctx,
			payload->remote_name, ALPM_DOWNLOAD_PROGRESS, &cb_data);
	payload->prevprogress = current_size;

	return 0;
}

static int curl_gethost(const char *url, char *buffer, size_t buf_len)
{
	size_t hostlen;
	char *p, *q;

	if(strncmp(url, "file://", 7) == 0) {
		p = _("disk");
		hostlen = strlen(p);
	} else {
		p = strstr(url, "//");
		if(!p) {
			return 1;
		}
		p += 2; /* jump over the found // */
		hostlen = strcspn(p, "/");

		/* there might be a user:pass@ on the URL. hide it. avoid using memrchr()
		 * for portability concerns. */
		q = p + hostlen;
		while(--q > p) {
			if(*q == '@') {
				break;
			}
		}
		if(*q == '@' && p != q) {
			hostlen -= q - p + 1;
			p = q + 1;
		}
	}

	if(hostlen > buf_len - 1) {
		/* buffer overflow imminent */
		return 1;
	}
	memcpy(buffer, p, hostlen);
	buffer[hostlen] = '\0';

	return 0;
}

static int utimes_long(const char *path, long seconds)
{
	if(seconds != -1) {
		struct timeval tv[2] = {
			{ .tv_sec = seconds, },
			{ .tv_sec = seconds, },
		};
		return utimes(path, tv);
	}
	return 0;
}

/* prefix to avoid possible future clash with getumask(3) */
static mode_t _getumask(void)
{
	mode_t mask = umask(0);
	umask(mask);
	return mask;
}

static size_t dload_parseheader_cb(void *ptr, size_t size, size_t nmemb, void *user)
{
	size_t realsize = size * nmemb;
	const char *fptr, *endptr = NULL;
	const char * const cd_header = "Content-Disposition:";
	const char * const fn_key = "filename=";
	struct dload_payload *payload = (struct dload_payload *)user;
	long respcode;

	if(_alpm_raw_ncmp(cd_header, ptr, strlen(cd_header)) == 0) {
		if((fptr = strstr(ptr, fn_key))) {
			fptr += strlen(fn_key);

			/* find the end of the field, which is either a semi-colon, or the end of
			 * the data. As per curl_easy_setopt(3), we cannot count on headers being
			 * null terminated, so we look for the closing \r\n */
			endptr = fptr + strcspn(fptr, ";\r\n") - 1;

			/* remove quotes */
			if(*fptr == '"' && *endptr == '"') {
				fptr++;
				endptr--;
			}

			STRNDUP(payload->content_disp_name, fptr, endptr - fptr + 1,
					RET_ERR(payload->handle, ALPM_ERR_MEMORY, realsize));
		}
	}

	curl_easy_getinfo(payload->curl, CURLINFO_RESPONSE_CODE, &respcode);
	if(payload->respcode != respcode) {
		payload->respcode = respcode;
	}

	return realsize;
}

static void curl_set_handle_opts(CURL *curl, struct dload_payload *payload)
{
	alpm_handle_t *handle = payload->handle;
	const char *useragent = getenv("HTTP_USER_AGENT");
	struct stat st;

	/* the curl_easy handle is initialized with the alpm handle, so we only need
	 * to reset the handle's parameters for each time it's used. */
	curl_easy_reset(curl);
	curl_easy_setopt(curl, CURLOPT_URL, payload->fileurl);
	curl_easy_setopt(curl, CURLOPT_ERRORBUFFER, payload->error_buffer);
	curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT, 10L);
	curl_easy_setopt(curl, CURLOPT_MAXREDIRS, 10L);
	curl_easy_setopt(curl, CURLOPT_FILETIME, 1L);
	curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0L);
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
	curl_easy_setopt(curl, CURLOPT_XFERINFOFUNCTION, dload_progress_cb);
	curl_easy_setopt(curl, CURLOPT_XFERINFODATA, (void *)payload);
	if(!handle->disable_dl_timeout) {
		curl_easy_setopt(curl, CURLOPT_LOW_SPEED_LIMIT, 1L);
		curl_easy_setopt(curl, CURLOPT_LOW_SPEED_TIME, 10L);
	}
	curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, dload_parseheader_cb);
	curl_easy_setopt(curl, CURLOPT_HEADERDATA, (void *)payload);
	curl_easy_setopt(curl, CURLOPT_NETRC, CURL_NETRC_OPTIONAL);
	curl_easy_setopt(curl, CURLOPT_TCP_KEEPALIVE, 1L);
	curl_easy_setopt(curl, CURLOPT_TCP_KEEPIDLE, 60L);
	curl_easy_setopt(curl, CURLOPT_TCP_KEEPINTVL, 60L);
	curl_easy_setopt(curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
	curl_easy_setopt(curl, CURLOPT_PRIVATE, (void *)payload);

	_alpm_log(handle, ALPM_LOG_DEBUG, "%s: url is %s\n",
		payload->remote_name, payload->fileurl);

	if(payload->max_size) {
		_alpm_log(handle, ALPM_LOG_DEBUG, "%s: maxsize %jd\n",
				payload->remote_name, (intmax_t)payload->max_size);
		curl_easy_setopt(curl, CURLOPT_MAXFILESIZE_LARGE,
				(curl_off_t)payload->max_size);
	}

	if(useragent != NULL) {
		curl_easy_setopt(curl, CURLOPT_USERAGENT, useragent);
	}

	if(!payload->force && payload->destfile_name &&
			stat(payload->destfile_name, &st) == 0) {
		/* start from scratch, but only download if our local is out of date. */
		curl_easy_setopt(curl, CURLOPT_TIMECONDITION, CURL_TIMECOND_IFMODSINCE);
		curl_easy_setopt(curl, CURLOPT_TIMEVALUE, (long)st.st_mtime);
		_alpm_log(handle, ALPM_LOG_DEBUG,
				"%s: using time condition %ld\n",
				payload->remote_name, (long)st.st_mtime);
	} else if(stat(payload->tempfile_name, &st) == 0 && payload->allow_resume) {
		/* a previous partial download exists, resume from end of file. */
		payload->tempfile_openmode = "ab";
		curl_easy_setopt(curl, CURLOPT_RESUME_FROM_LARGE, (curl_off_t)st.st_size);
		_alpm_log(handle, ALPM_LOG_DEBUG,
				"%s: tempfile found, attempting continuation from %jd bytes\n",
				payload->remote_name, (intmax_t)st.st_size);
		payload->initial_size = st.st_size;
	}
}

static FILE *create_tempfile(struct dload_payload *payload, const char *localpath)
{
	int fd;
	FILE *fp;
	char *randpath;
	size_t len;

	/* create a random filename, which is opened with O_EXCL */
	len = strlen(localpath) + 14 + 1;
	MALLOC(randpath, len, RET_ERR(payload->handle, ALPM_ERR_MEMORY, NULL));
	snprintf(randpath, len, "%salpmtmp.XXXXXX", localpath);
	if((fd = mkstemp(randpath)) == -1 ||
			fchmod(fd, ~(_getumask()) & 0666) ||
			!(fp = fdopen(fd, payload->tempfile_openmode))) {
		unlink(randpath);
		close(fd);
		_alpm_log(payload->handle, ALPM_LOG_ERROR,
				_("failed to create temporary file for download\n"));
		free(randpath);
		return NULL;
	}
	/* fp now points to our alpmtmp.XXXXXX */
	free(payload->tempfile_name);
	payload->tempfile_name = randpath;
	free(payload->remote_name);
	STRDUP(payload->remote_name, strrchr(randpath, '/') + 1,
			fclose(fp); RET_ERR(payload->handle, ALPM_ERR_MEMORY, NULL));

	return fp;
}

/* Return 0 if retry was successful, -1 otherwise */
static int curl_retry_next_server(CURLM *curlm, CURL *curl, struct dload_payload *payload)
{
	const char *server;
	size_t len;
	struct stat st;
	alpm_handle_t *handle = payload->handle;

	while(payload->servers && should_skip_server(handle, payload->servers->data)) {
		payload->servers = payload->servers->next;
	}
	if(!payload->servers) {
		_alpm_log(payload->handle, ALPM_LOG_DEBUG,
				"%s: no more servers to retry\n", payload->remote_name);
		return -1;
	}
	server = payload->servers->data;
	payload->servers = payload->servers->next;

	/* regenerate a new fileurl */
	FREE(payload->fileurl);
	len = strlen(server) + strlen(payload->filepath) + 2;
	MALLOC(payload->fileurl, len, RET_ERR(handle, ALPM_ERR_MEMORY, -1));
	snprintf(payload->fileurl, len, "%s/%s", server, payload->filepath);


	fflush(payload->localf);

	if(payload->allow_resume && stat(payload->tempfile_name, &st) == 0) {
		/* a previous partial download exists, resume from end of file. */
		payload->tempfile_openmode = "ab";
		curl_easy_setopt(curl, CURLOPT_RESUME_FROM_LARGE, (curl_off_t)st.st_size);
		_alpm_log(handle, ALPM_LOG_DEBUG,
				"%s: tempfile found, attempting continuation from %jd bytes\n",
				payload->remote_name, (intmax_t)st.st_size);
		payload->initial_size = st.st_size;
	} else {
		/* we keep the file for a new retry but remove its data if any */
		if(ftruncate(fileno(payload->localf), 0)) {
			RET_ERR(handle, ALPM_ERR_SYSTEM, -1);
		}
		fseek(payload->localf, 0, SEEK_SET);
	}

	if(handle->dlcb && !payload->signature) {
		alpm_download_event_retry_t cb_data;
		cb_data.resume = payload->allow_resume;
		handle->dlcb(handle->dlcb_ctx, payload->remote_name, ALPM_DOWNLOAD_RETRY, &cb_data);
	}

	/* Set curl with the new URL */
	curl_easy_setopt(curl, CURLOPT_URL, payload->fileurl);

	curl_multi_remove_handle(curlm, curl);
	curl_multi_add_handle(curlm, curl);

	return 0;
}

/* Returns 2 if download retry happened
 * Returns 1 if the file is up-to-date
 * Returns 0 if current payload is completed successfully
 * Returns -1 if an error happened for a required file
 * Returns -2 if an error happened for an optional file
 */
static int curl_check_finished_download(CURLM *curlm, CURLMsg *msg,
		const char *localpath, int *active_downloads_num)
{
	alpm_handle_t *handle = NULL;
	struct dload_payload *payload = NULL;
	CURL *curl = msg->easy_handle;
	CURLcode curlerr;
	char *effective_url;
	long timecond;
	curl_off_t remote_size;
	curl_off_t bytes_dl = 0;
	long remote_time = -1;
	struct stat st;
	char hostname[HOSTNAME_SIZE];
	int ret = -1;

	curlerr = curl_easy_getinfo(curl, CURLINFO_PRIVATE, &payload);
	ASSERT(curlerr == CURLE_OK, RET_ERR(handle, ALPM_ERR_LIBCURL, -1));
	handle = payload->handle;

	curl_gethost(payload->fileurl, hostname, sizeof(hostname));
	curlerr = msg->data.result;
	_alpm_log(handle, ALPM_LOG_DEBUG, "%s: curl returned result %d from transfer\n",
			payload->remote_name, curlerr);

	/* was it a success? */
	switch(curlerr) {
		case CURLE_OK:
			/* get http/ftp response code */
			_alpm_log(handle, ALPM_LOG_DEBUG, "%s: response code %ld\n",
					payload->remote_name, payload->respcode);
			if(payload->respcode >= 400) {
				if(!payload->errors_ok) {
					handle->pm_errno = ALPM_ERR_RETRIEVE;
					/* non-translated message is same as libcurl */
					snprintf(payload->error_buffer, sizeof(payload->error_buffer),
							"The requested URL returned error: %ld", payload->respcode);
					_alpm_log(handle, ALPM_LOG_ERROR,
							_("failed retrieving file '%s' from %s : %s\n"),
							payload->remote_name, hostname, payload->error_buffer);
					server_soft_error(handle, payload->fileurl);
				}
				if(curl_retry_next_server(curlm, curl, payload) == 0) {
					(*active_downloads_num)++;
					return 2;
				} else {
					payload->unlink_on_fail = 1;
					goto cleanup;
				}
			}
			break;
		case CURLE_ABORTED_BY_CALLBACK:
			/* handle the interrupt accordingly */
			if(dload_interrupted == ABORT_OVER_MAXFILESIZE) {
				curlerr = CURLE_FILESIZE_EXCEEDED;
				payload->unlink_on_fail = 1;
				handle->pm_errno = ALPM_ERR_LIBCURL;
				_alpm_log(handle, ALPM_LOG_ERROR,
						_("failed retrieving file '%s' from %s : expected download size exceeded\n"),
						payload->remote_name, hostname);
				server_soft_error(handle, payload->fileurl);
			}
			goto cleanup;
		case CURLE_COULDNT_RESOLVE_HOST:
			handle->pm_errno = ALPM_ERR_SERVER_BAD_URL;
			_alpm_log(handle, ALPM_LOG_ERROR,
					_("failed retrieving file '%s' from %s : %s\n"),
					payload->remote_name, hostname, payload->error_buffer);
			server_hard_error(handle, payload->fileurl);
			if(curl_retry_next_server(curlm, curl, payload) == 0) {
				(*active_downloads_num)++;
				return 2;
			} else {
				payload->unlink_on_fail = 1;
				goto cleanup;
			}
		default:
			if(!payload->errors_ok) {
				handle->pm_errno = ALPM_ERR_LIBCURL;
				_alpm_log(handle, ALPM_LOG_ERROR,
						_("failed retrieving file '%s' from %s : %s\n"),
						payload->remote_name, hostname, payload->error_buffer);
				server_soft_error(handle, payload->fileurl);
			} else {
				_alpm_log(handle, ALPM_LOG_DEBUG,
						"failed retrieving file '%s' from %s : %s\n",
						payload->remote_name, hostname, payload->error_buffer);
			}
			if(curl_retry_next_server(curlm, curl, payload) == 0) {
				(*active_downloads_num)++;
				return 2;
			} else {
				/* delete zero length downloads */
				if(fstat(fileno(payload->localf), &st) == 0 && st.st_size == 0) {
					payload->unlink_on_fail = 1;
				}
				goto cleanup;
			}
	}

	/* retrieve info about the state of the transfer */
	curl_easy_getinfo(curl, CURLINFO_FILETIME, &remote_time);
	curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD_T, &remote_size);
	curl_easy_getinfo(curl, CURLINFO_SIZE_DOWNLOAD_T, &bytes_dl);
	curl_easy_getinfo(curl, CURLINFO_CONDITION_UNMET, &timecond);
	curl_easy_getinfo(curl, CURLINFO_EFFECTIVE_URL, &effective_url);

	if(payload->trust_remote_name) {
		if(payload->content_disp_name) {
			/* content-disposition header has a better name for our file */
			free(payload->destfile_name);
			payload->destfile_name = get_fullpath(localpath,
				get_filename(payload->content_disp_name), "");
		} else {
			const char *effective_filename = strrchr(effective_url, '/');

			if(effective_filename && strlen(effective_filename) > 2) {
				effective_filename++;

				/* if destfile was never set, we wrote to a tempfile. even if destfile is
				 * set, we may have followed some redirects and the effective url may
				 * have a better suggestion as to what to name our file. in either case,
				 * refactor destfile to this newly derived name. */
				if(!payload->destfile_name || strcmp(effective_filename,
							strrchr(payload->destfile_name, '/') + 1) != 0) {
					free(payload->destfile_name);
					payload->destfile_name = get_fullpath(localpath, effective_filename, "");
				}
			}
		}
	}

	/* Let's check if client requested downloading accompanion *.sig file */
	if(!payload->signature && payload->download_signature && curlerr == CURLE_OK && payload->respcode < 400) {
		struct dload_payload *sig = NULL;

		int len = strlen(effective_url) + 5;
		CALLOC(sig, 1, sizeof(*sig), GOTO_ERR(handle, ALPM_ERR_MEMORY, cleanup));
		MALLOC(sig->fileurl, len, FREE(sig); GOTO_ERR(handle, ALPM_ERR_MEMORY, cleanup));
		snprintf(sig->fileurl, len, "%s.sig", effective_url);

		if(payload->trust_remote_name) {
			/* In this case server might provide a new name for the main payload.
			 * Choose *.sig filename based on this new name.
			 */
			const char* realname = payload->destfile_name ? payload->destfile_name : payload->tempfile_name;
			const char *final_file = get_filename(realname);
			int remote_name_len = strlen(final_file) + 5;
			MALLOC(sig->remote_name, remote_name_len, FREE(sig->fileurl); FREE(sig); GOTO_ERR(handle, ALPM_ERR_MEMORY, cleanup));
			snprintf(sig->remote_name, remote_name_len, "%s.sig", final_file);
		}

		sig->signature = 1;
		sig->handle = handle;
		sig->force = payload->force;
		sig->unlink_on_fail = payload->unlink_on_fail;
		sig->errors_ok = payload->signature_optional;
		/* set hard upper limit of 16KiB */
		sig->max_size = 16 * 1024;

		curl_add_payload(handle, curlm, sig, localpath);
		(*active_downloads_num)++;
	}

	/* time condition was met and we didn't download anything. we need to
	 * clean up the 0 byte .part file that's left behind. */
	if(timecond == 1 && bytes_dl == 0) {
		_alpm_log(handle, ALPM_LOG_DEBUG, "%s: file met time condition\n",
			payload->remote_name);
		ret = 1;
		unlink(payload->tempfile_name);
		goto cleanup;
	}

	/* remote_size isn't necessarily the full size of the file, just what the
	 * server reported as remaining to download. compare it to what curl reported
	 * as actually being transferred during curl_easy_perform() */
	if(remote_size != -1 && bytes_dl != -1 &&
			bytes_dl != remote_size) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("%s appears to be truncated: %jd/%jd bytes\n"),
				payload->remote_name, (intmax_t)bytes_dl, (intmax_t)remote_size);
		GOTO_ERR(handle, ALPM_ERR_RETRIEVE, cleanup);
	}

	ret = 0;

cleanup:
	/* disconnect relationships from the curl handle for things that might go out
	 * of scope, but could still be touched on connection teardown. This really
	 * only applies to FTP transfers. */
	curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1L);
	curl_easy_setopt(curl, CURLOPT_ERRORBUFFER, (char *)NULL);

	if(payload->localf != NULL) {
		fclose(payload->localf);
		utimes_long(payload->tempfile_name, remote_time);
	}

	if(ret == 0) {
		if(payload->destfile_name) {
			if(rename(payload->tempfile_name, payload->destfile_name)) {
				_alpm_log(handle, ALPM_LOG_ERROR, _("could not rename %s to %s (%s)\n"),
						payload->tempfile_name, payload->destfile_name, strerror(errno));
				ret = -1;
			}
		}
	}

	if((ret == -1 || dload_interrupted) && payload->unlink_on_fail &&
			payload->tempfile_name) {
		unlink(payload->tempfile_name);
	}

	if(handle->dlcb) {
		alpm_download_event_completed_t cb_data = {0};
		cb_data.total = bytes_dl;
		cb_data.result = ret;
		handle->dlcb(handle->dlcb_ctx, payload->remote_name, ALPM_DOWNLOAD_COMPLETED, &cb_data);
	}

	curl_multi_remove_handle(curlm, curl);
	curl_easy_cleanup(curl);
	payload->curl = NULL;

	FREE(payload->fileurl);

	if(ret == -1 && payload->errors_ok) {
		ret = -2;
	}

	if(payload->signature) {
		/* free signature payload memory that was allocated earlier in dload.c */
		_alpm_dload_payload_reset(payload);
		FREE(payload);
	}

	return ret;
}

/* Returns 0 in case if a new download transaction has been successfully started
 * Returns -1 if am error happened while starting a new download
 */
static int curl_add_payload(alpm_handle_t *handle, CURLM *curlm,
		struct dload_payload *payload, const char *localpath)
{
	size_t len;
	CURL *curl = NULL;
	char hostname[HOSTNAME_SIZE];
	int ret = -1;

	curl = curl_easy_init();
	payload->curl = curl;

	if(payload->fileurl) {
		ASSERT(!payload->servers, GOTO_ERR(handle, ALPM_ERR_WRONG_ARGS, cleanup));
		ASSERT(!payload->filepath, GOTO_ERR(handle, ALPM_ERR_WRONG_ARGS, cleanup));
	} else {
		const char *server;
		while(payload->servers && should_skip_server(handle, payload->servers->data)) {
			payload->servers = payload->servers->next;
		}

		ASSERT(payload->servers, GOTO_ERR(handle, ALPM_ERR_SERVER_NONE, cleanup));
		ASSERT(payload->filepath, GOTO_ERR(handle, ALPM_ERR_WRONG_ARGS, cleanup));

		server = payload->servers->data;
		payload->servers = payload->servers->next;

		len = strlen(server) + strlen(payload->filepath) + 2;
		MALLOC(payload->fileurl, len, GOTO_ERR(handle, ALPM_ERR_MEMORY, cleanup));
		snprintf(payload->fileurl, len, "%s/%s", server, payload->filepath);
	}

	payload->tempfile_openmode = "wb";
	if(!payload->remote_name) {
		STRDUP(payload->remote_name, get_filename(payload->fileurl),
			GOTO_ERR(handle, ALPM_ERR_MEMORY, cleanup));
	}
	if(curl_gethost(payload->fileurl, hostname, sizeof(hostname)) != 0) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("url '%s' is invalid\n"), payload->fileurl);
		GOTO_ERR(handle, ALPM_ERR_SERVER_BAD_URL, cleanup);
	}

	if(payload->remote_name && strlen(payload->remote_name) > 0) {
		payload->destfile_name = get_fullpath(localpath, payload->remote_name, "");
		payload->tempfile_name = get_fullpath(localpath, payload->remote_name, ".part");
		if(!payload->destfile_name || !payload->tempfile_name) {
			goto cleanup;
		}
	} else {
		/* URL doesn't contain a filename, so make a tempfile. We can't support
		 * resuming this kind of download; partial transfers will be destroyed */
		payload->unlink_on_fail = 1;

		payload->localf = create_tempfile(payload, localpath);
		if(payload->localf == NULL) {
			goto cleanup;
		}
	}

	curl_set_handle_opts(curl, payload);

	if(payload->max_size == payload->initial_size && payload->max_size != 0) {
		/* .part file is complete */
		ret = 0;
		goto cleanup;
	}

	if(payload->localf == NULL) {
		payload->localf = fopen(payload->tempfile_name, payload->tempfile_openmode);
		if(payload->localf == NULL) {
			_alpm_log(handle, ALPM_LOG_ERROR,
					_("could not open file %s: %s\n"),
					payload->tempfile_name, strerror(errno));
			GOTO_ERR(handle, ALPM_ERR_RETRIEVE, cleanup);
		}
	}

	_alpm_log(handle, ALPM_LOG_DEBUG,
			"%s: opened tempfile for download: %s (%s)\n",
			payload->remote_name,
			payload->tempfile_name,
			payload->tempfile_openmode);

	curl_easy_setopt(curl, CURLOPT_WRITEDATA, payload->localf);
	curl_multi_add_handle(curlm, curl);

	if(handle->dlcb) {
		alpm_download_event_init_t cb_data = {.optional = payload->errors_ok};
		handle->dlcb(handle->dlcb_ctx, payload->remote_name, ALPM_DOWNLOAD_INIT, &cb_data);
	}

	return 0;

cleanup:
	curl_easy_cleanup(curl);
	return ret;
}

/* Returns -1 if an error happened for a required file
 * Returns 0 if a payload was actually downloaded
 * Returns 1 if no files were downloaded and all errors were non-fatal
 */
static int curl_download_internal(alpm_handle_t *handle,
		alpm_list_t *payloads /* struct dload_payload */,
		const char *localpath)
{
	int active_downloads_num = 0;
	int err = 0;
	int max_streams = handle->parallel_downloads;
	int updated = 0; /* was a file actually updated */
	CURLM *curlm = handle->curlm;

	while(active_downloads_num > 0 || payloads) {
		CURLMcode mc;

		for(; active_downloads_num < max_streams && payloads; active_downloads_num++) {
			struct dload_payload *payload = payloads->data;

			if(curl_add_payload(handle, curlm, payload, localpath) == 0) {
				payloads = payloads->next;
			} else {
				/* The payload failed to start. Do not start any new downloads.
				 * Wait until all active downloads complete.
				 */
				_alpm_log(handle, ALPM_LOG_ERROR, _("failed to setup a download payload for %s\n"), payload->remote_name);
				payloads = NULL;
				err = -1;
			}
		}

		mc = curl_multi_perform(curlm, &active_downloads_num);
		if(mc == CURLM_OK) {
			mc = curl_multi_wait(curlm, NULL, 0, 1000, NULL);
		}

		if(mc != CURLM_OK) {
			_alpm_log(handle, ALPM_LOG_ERROR, _("curl returned error %d from transfer\n"), mc);
			payloads = NULL;
			err = -1;
		}

		while(true) {
			int msgs_left = 0;
			CURLMsg *msg = curl_multi_info_read(curlm, &msgs_left);
			if(!msg) {
				break;
			}
			if(msg->msg == CURLMSG_DONE) {
				int ret = curl_check_finished_download(curlm, msg,
						localpath, &active_downloads_num);
				if(ret == -1) {
					/* if current payload failed to download then stop adding new payloads but wait for the
					 * current ones
					 */
					payloads = NULL;
					err = -1;
				} else if(ret == 0) {
					updated = 1;
				}
			} else {
				_alpm_log(handle, ALPM_LOG_ERROR, _("curl transfer error: %d\n"), msg->msg);
			}
		}
	}

	_alpm_log(handle, ALPM_LOG_DEBUG, "curl_download_internal return code is %d\n", err);
	return err ? -1 : updated ? 0 : 1;
}

#endif

/* Returns -1 if an error happened for a required file
 * Returns 0 if a payload was actually downloaded
 * Returns 1 if no files were downloaded and all errors were non-fatal
 */
int _alpm_download(alpm_handle_t *handle,
		alpm_list_t *payloads /* struct dload_payload */,
		const char *localpath)
{
	if(handle->fetchcb == NULL) {
#ifdef HAVE_LIBCURL
		return curl_download_internal(handle, payloads, localpath);
#else
		RET_ERR(handle, ALPM_ERR_EXTERNAL_DOWNLOAD, -1);
#endif
	} else {
		alpm_list_t *p;
		int updated = 0;
		for(p = payloads; p; p = p->next) {
			struct dload_payload *payload = p->data;
			alpm_list_t *s;
			int ret = -1;

			if(payload->fileurl) {
				ret = handle->fetchcb(handle->fetchcb_ctx, payload->fileurl, localpath, payload->force);
			} else {
				for(s = payload->servers; s && ret == -1; s = s->next) {
					const char *server = s->data;
					char *fileurl;

					size_t len = strlen(server) + strlen(payload->filepath) + 2;
					MALLOC(fileurl, len, RET_ERR(handle, ALPM_ERR_MEMORY, -1));
					snprintf(fileurl, len, "%s/%s", server, payload->filepath);

					ret = handle->fetchcb(handle->fetchcb_ctx, fileurl, localpath, payload->force);
					free(fileurl);
				}
			}

			if(ret == -1 && !payload->errors_ok) {
				RET_ERR(handle, ALPM_ERR_EXTERNAL_DOWNLOAD, -1);
			} else if(ret == 0) {
				updated = 1;
			}
		}
		return updated ? 0 : 1;
	}
}

static char *filecache_find_url(alpm_handle_t *handle, const char *url)
{
	const char *filebase = strrchr(url, '/');

	if(filebase == NULL) {
		return NULL;
	}

	filebase++;
	if(*filebase == '\0') {
		return NULL;
	}

	return _alpm_filecache_find(handle, filebase);
}

int SYMEXPORT alpm_fetch_pkgurl(alpm_handle_t *handle, const alpm_list_t *urls,
	  alpm_list_t **fetched)
{
	const char *cachedir;
	alpm_list_t *payloads = NULL;
	const alpm_list_t *i;
	alpm_event_t event = {0};

	CHECK_HANDLE(handle, return -1);
	ASSERT(*fetched == NULL, RET_ERR(handle, ALPM_ERR_WRONG_ARGS, -1));

	/* find a valid cache dir to download to */
	cachedir = _alpm_filecache_setup(handle);

	for(i = urls; i; i = i->next) {
		char *url = i->data;

		/* attempt to find the file in our pkgcache */
		char *filepath = filecache_find_url(handle, url);
		if(filepath) {
			/* the file is locally cached so add it to the output right away */
			alpm_list_append(fetched, filepath);
		} else {
			struct dload_payload *payload = NULL;

			ASSERT(url, GOTO_ERR(handle, ALPM_ERR_WRONG_ARGS, err));
			CALLOC(payload, 1, sizeof(*payload), GOTO_ERR(handle, ALPM_ERR_MEMORY, err));
			STRDUP(payload->fileurl, url, FREE(payload); GOTO_ERR(handle, ALPM_ERR_MEMORY, err));
			payload->allow_resume = 1;
			payload->handle = handle;
			payload->trust_remote_name = 1;
			payload->download_signature = (handle->siglevel & ALPM_SIG_PACKAGE);
			payload->signature_optional = (handle->siglevel & ALPM_SIG_PACKAGE_OPTIONAL);
			payloads = alpm_list_add(payloads, payload);
		}
	}

	if(payloads) {
		event.type = ALPM_EVENT_PKG_RETRIEVE_START;
		event.pkg_retrieve.num = alpm_list_count(payloads);
		EVENT(handle, &event);
		if(_alpm_download(handle, payloads, cachedir) == -1) {
			_alpm_log(handle, ALPM_LOG_WARNING, _("failed to retrieve some files\n"));
			event.type = ALPM_EVENT_PKG_RETRIEVE_FAILED;
			EVENT(handle, &event);

			GOTO_ERR(handle, ALPM_ERR_RETRIEVE, err);
		} else {
			event.type = ALPM_EVENT_PKG_RETRIEVE_DONE;
			EVENT(handle, &event);
		}

		for(i = payloads; i; i = i->next) {
			struct dload_payload *payload = i->data;
			char *filepath;

			if(payload->destfile_name) {
				const char *filename = mbasename(payload->destfile_name);
				filepath = _alpm_filecache_find(handle, filename);
			} else {
				STRDUP(filepath, payload->tempfile_name, GOTO_ERR(handle, ALPM_ERR_MEMORY, err));
			}
			if(filepath) {
				alpm_list_append(fetched, filepath);
			} else {
				_alpm_log(handle, ALPM_LOG_WARNING, _("download completed successfully but no file in the cache\n"));
				GOTO_ERR(handle, ALPM_ERR_RETRIEVE, err);
			}
		}

		alpm_list_free_inner(payloads, (alpm_list_fn_free)_alpm_dload_payload_reset);
		FREELIST(payloads);
	}

	return 0;

err:
	alpm_list_free_inner(payloads, (alpm_list_fn_free)_alpm_dload_payload_reset);
	FREELIST(payloads);
	FREELIST(*fetched);

	return -1;
}

void _alpm_dload_payload_reset(struct dload_payload *payload)
{
	ASSERT(payload, return);

	FREE(payload->remote_name);
	FREE(payload->tempfile_name);
	FREE(payload->destfile_name);
	FREE(payload->content_disp_name);
	FREE(payload->fileurl);
	FREE(payload->filepath);
	*payload = (struct dload_payload){0};
}
