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
# Function for deleting temporary directory with uploaded files from
# the server.
aptly_delete_dir() {
  echo "[$(date +%H:%M:%S)] Deleting uploads temporary directory..."

  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" \
      --request DELETE \
      ${REPOSITORY_URL}/files/${REPOSITORY_NAME}-${GITHUB_SHA}
  )

  http_status_code=$(echo "$curl_response" | cut -d'|' -f2 | grep -oP '\d{3}$')

  if [ "$http_status_code" != "200" ]; then
    echo "[$(date +%H:%M:%S)] Warning: server returned $http_status_code code while deleting temporary directory."
  fi
}

aptly_upload_file() {
  local filename="$1"
  curl_response=$(curl \
    "${CURL_COMMON_OPTIONS[@]}" \
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
  echo "[$(date +%H:%M:%S)] Adding packages to repository '$REPOSITORY_NAME'..."
  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" \
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
    fi
  else
    echo "[$(date +%H:%M:%S)] Error: got http_status_code == '$http_status_code', packages may not appear in repository."
  fi
}

aptly_publish_repo() {
  echo "[$(date +%H:%M:%S)] Publishing repository changes..."
  curl_response=$(
    curl \
      "${CURL_COMMON_OPTIONS[@]}" \
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
