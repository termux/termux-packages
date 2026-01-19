#!/usr/bin/env bash
# TDOC — Repository Security Logic
# Return:
#   0 = OK
#   1 = BROKEN

REPO_FILE="$PREFIX/etc/apt/sources.list"
KEYRING="$PREFIX/share/keyrings/termux-archive-keyring.gpg"
APT_LISTS="$PREFIX/var/lib/apt/lists"

scan_repo_security() {
    [[ ! -f "$REPO_FILE" ]] && return 1
    [[ ! -f "$KEYRING" ]] && return 1
    [[ ! -d "$APT_LISTS" ]] && return 1

    local broken=0

    while IFS= read -r line; do
        [[ "$line" =~ ^# || -z "$line" ]] && continue

        local url
        url=$(echo "$line" | awk '{print $2}')
        [[ "$url" =~ ^https?:// ]] || continue

        local host
        host=$(echo "$url" | awk -F/ '{print $3}')

        local release
        release=$(ls "$APT_LISTS" 2>/dev/null | grep "$host" | grep "_Release$" | head -n1)

        [[ -z "$release" ]] && broken=1 && continue

        release="$APT_LISTS/$release"
        sig="${release}.gpg"

        [[ ! -f "$sig" ]] && broken=1 && continue

        gpg --keyring "$KEYRING" --verify "$sig" "$release" \
            >/dev/null 2>&1 || broken=1

    done < "$REPO_FILE"

    return "$broken"
}
