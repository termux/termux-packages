# These options and functions are sourced from
# .github/workflows/packages.yml and used for uploading packages to
# our repos

CURL_COMMON_OPTIONS=(
  --silent
  --retry 2
  --retry-delay 3
  --user-agent 'Termux-Packages/1.0\ (https://github.com/termux/termux-packages)'
  --user "${APTLY_API_AUTH}"
  --write-out "|%{http_code}"
)

CURL_ADDITIONAL_OPTIONS=()

# Warn and dont push instead of error out if no auth provided
check_login() {
  export APTLY_API_AUTH_WARN=${APTLY_API_AUTH_WARN:=0}
  local e=0
  if [[ -z "${APTLY_API_AUTH}" ]]; then
    e=1
    if [[ "$((APTLY_API_AUTH_WARN & 1))" == 0 ]]; then
      echo "[$(date +%H:%M:%S)] Warning: No APTLY_API_AUTH provided"
      APTLY_API_AUTH_WARN=$((APTLY_API_AUTH_WARN | 1))
    fi
  fi
  if [[ -z "${GPG_PASSPHRASE}" ]]; then
    e=1
    if [[ "$((APTLY_API_AUTH_WARN & 2))" == 0 ]]; then
      echo "[$(date +%H:%M:%S)] Warning: No GPG_PASSPHRASE provided"
      APTLY_API_AUTH_WARN=$((APTLY_API_AUTH_WARN | 2))
    fi
  fi
  if [[ "${e}" != 0 ]]; then
    if [[ "$((APTLY_API_AUTH_WARN & 4))" == 0 ]]; then
      echo "[$(date +%H:%M:%S)] Warning: You are most likely on a forked repo. Upload will be cancelled. Fix this if incorrect."
      APTLY_API_AUTH_WARN=$((APTLY_API_AUTH_WARN | 4))
    fi
    return 1
  fi
}

# Function for deleting temporary directory with uploaded files from
# the server.
aptly_delete_dir() {
  ! check_login && return 0
  echo "[$(date +%H:%M:%S)] Deleting uploads temporary directory..."

  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" "${CURL_ADDITIONAL_OPTIONS[@]}" \
      --request DELETE \
      ${REPOSITORY_URL}/files/${REPOSITORY_NAME}-${GITHUB_SHA}
  )

  http_status_code=$(echo "$curl_response" | cut -d'|' -f2 | grep -oP '\d{3}$')

  if [ "$http_status_code" != "200" ]; then
    echo "[$(date +%H:%M:%S)] Warning: server returned $http_status_code code while deleting temporary directory."
  fi
}

aptly_upload_file() {
  ! check_login && return 0
  local filename="$1"
  curl_response=$(curl \
    "${CURL_COMMON_OPTIONS[@]}" "${CURL_ADDITIONAL_OPTIONS[@]}" \
    --request POST \
    --form file=@${filename} \
    ${REPOSITORY_URL}/files/${REPOSITORY_NAME}-${GITHUB_SHA} || true
  )
  http_status_code=$(echo "$curl_response" | cut -d'|' -f2 | grep -oP '\d{3}$')

  if [ "$http_status_code" = "200" ]; then
    echo "[$(date +%H:%M:%S)] Uploaded: $(echo "$curl_response" | cut -d'|' -f1 | jq -r '.[]' | cut -d'/' -f2)"
  elif [ "$http_status_code" = "000" ]; then
    echo "[$(date +%H:%M:%S)]: Failed to upload '$filename'. Server/proxy dropped connection during upload."
    echo "[$(date +%H:%M:%S)]: Aborting any further uploads to this repo."
    aptly_delete_dir
    return 1
  else
    # Manually cleaning up the temporary directory to reclaim disk space.
    # Don't rely on scheduled server-side scripts.
    echo "[$(date +%H:%M:%S)] Error: failed to upload '$filename'. Server returned $http_status_code code."
    echo "[$(date +%H:%M:%S)] Aborting any further uploads to this repo."
    aptly_delete_dir
    return 1
  fi
  return 0
}

aptly_add_to_repo() {
  ! check_login && return 0
  echo "[$(date +%H:%M:%S)] Adding packages to repository '$REPOSITORY_NAME'..."
  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" "${CURL_ADDITIONAL_OPTIONS[@]}" \
      --max-time 300 \
      --request POST \
      ${REPOSITORY_URL}/repos/${REPOSITORY_NAME}/file/${REPOSITORY_NAME}-${GITHUB_SHA} || true
  )
  http_status_code=$(echo "$curl_response" | cut -d'|' -f2 | grep -oP '\d{3}$')

  if [ "$http_status_code" = "200" ]; then
    warnings=$(echo "$curl_response" | cut -d'|' -f1 | jq '.Report.Warnings' | jq -r '.[]')
    if [ -n "$warnings" ]; then
      echo "[$(date +%H:%M:%S)] APTLY WARNINGS (NON-CRITICAL):"
      echo
      echo "$warnings"
      echo
      return 1
    fi
  elif [ "$http_status_code" == "000" ]; then
    echo "[$(date +%H:%M:%S)] Warning: server/proxy dropped connection. Assuming that the host is adding packages inspite of lost connection."
    echo "[$(date +%H:%M:%S)] Warning: Waiting for host to add packages. Sleeping for 180s. Assuming that packages will be added till then."
    sleep 180
    return 0
  else
    echo "[$(date +%H:%M:%S)] Error: got http_status_code == '$http_status_code'."
    echo "[$(date +%H:%M:%S)] Error: the unexpected happened. Ask any maintainer to check the aptly log"
    return 1
  fi
  return 0
}

aptly_publish_repo() {
  ! check_login && return 0
  echo "[$(date +%H:%M:%S)] Publishing repository changes..."
  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" "${CURL_ADDITIONAL_OPTIONS[@]}" \
      --max-time 300 \
      --header 'Content-Type: application/json' \
      --request PUT \
      --data "{\"Signing\": {\"Passphrase\": \"${GPG_PASSPHRASE}\"}}" \
      ${REPOSITORY_URL}/publish/${REPOSITORY_NAME}/${REPOSITORY_DISTRIBUTION} || true
  )
  http_status_code=$(echo "$curl_response" | cut -d'|' -f2 | grep -oP '\d{3}$')

  if [ "$http_status_code" = "200" ]; then
    echo "[$(date +%H:%M:%S)] Repository has been updated successfully."
  elif [ "$http_status_code" = "000" ]; then
    echo "[$(date +%H:%M:%S)] Warning: server/proxy has dropped connection."
    # Ignore - nothing can be done with that unless we change proxy.
    # return 1
  elif [ "$http_status_code" = "504" ]; then
    echo "[$(date +%H:%M:%S)] Warning: request processing time was too long, connection dropped."
    # Ignore - nothing can be done with that unless we change repository
    # management tool or reduce repository size.
    # return 1
  else
    echo "[$(date +%H:%M:%S)] Error: got http_status_code == '$http_status_code'"
    return 1
  fi
  return 0
}
