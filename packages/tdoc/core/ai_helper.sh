#!/usr/bin/env bash
# ==============================
# TDOC — AI Helper Engine (Offline)
# ==============================
# Fully offline AI-like diagnostics and explanations
# Language: English
# Fully compliant with Termux-packages

# -----------------------------
# Diagnosing common Termux issues
# -----------------------------
ai_diagnose() {
  local item="$1"

  case "$item" in
    Storage)
      cat <<EOF
Problem:
• Termux storage permission not granted

Possible Causes:
• 'termux-setup-storage' not executed
• Permission revoked by Android

Recommended Fix:
→ Run: termux-setup-storage

Confidence: 90%
EOF
      ;;
    Repository)
      cat <<EOF
Problem:
• Package repository misconfigured

Possible Causes:
• Default repo unreachable
• Mirror outdated

Recommended Fix:
→ Run: termux-change-repo

Confidence: 88%
EOF
      ;;
    NodeJS)
      cat <<EOF
Problem:
• NodeJS not installed or binary missing

Possible Causes:
• Package not installed
• Installation interrupted

Recommended Fix:
→ Run: pkg install nodejs

Confidence: 92%
EOF
      ;;
    Python)
      cat <<EOF
Problem:
• Python binary missing or corrupted

Possible Causes:
• Installation interrupted
• Repository mismatch

Recommended Fix:
→ Run: pkg reinstall python

Confidence: 85%
EOF
      ;;
    Git)
      cat <<EOF
Problem:
• Git not installed or repository out of sync

Possible Causes:
• Git package missing
• Local repository not updated

Recommended Fix:
→ Run: pkg install git
→ Run: git pull

Confidence: 87%
EOF
      ;;
    *)
      cat <<EOF
Problem:
• Unknown issue

Recommended Fix:
→ Manual inspection required

Confidence: 40%
EOF
      ;;
  esac
}

# -----------------------------
# Explaining issues in detail
# -----------------------------
ai_explain() {
  local item="$1"

  case "$item" in
    Storage)
      cat <<EOF
🔍 Storage Explanation:

Termux requires storage access to read/write files in /storage/shared.

Common Issues:
• User has not run 'termux-setup-storage'
• Permission revoked by Android

How it works:
• 'termux-setup-storage' creates symlinks in \$HOME/storage
• Ensures access to internal shared storage and SD card

Recommended:
→ Run: termux-setup-storage
EOF
      ;;
    Repository)
      cat <<EOF
🔍 Repository Explanation:

Package repositories are sources for 'pkg' and 'apt'.

Common Issues:
• Main or mirror repositories not available
• Repository outdated or mismatched for architecture

How it works:
• Repositories are listed in \$PREFIX/etc/apt/sources.list
• 'apt update' refreshes package lists from repositories

Recommended:
→ Run: termux-change-repo
EOF
      ;;
    NodeJS)
      cat <<EOF
🔍 NodeJS Explanation:

NodeJS is required for running JavaScript applications and npm packages.

Common Issues:
• NodeJS not installed
• Binary missing or corrupted

How it works:
• Official Termux package installation via 'pkg install nodejs'

Recommended:
→ Run: pkg install nodejs
EOF
      ;;
    Python)
      cat <<EOF
🔍 Python Explanation:

Python is required for running Python scripts and applications.

Common Issues:
• Python not installed
• Binary corrupted or version mismatch

How it works:
• Installed via Termux package manager
• Binary located at \$PREFIX/bin/python

Recommended:
→ Run: pkg reinstall python
EOF
      ;;
    Git)
      cat <<EOF
🔍 Git Explanation:

Git is used for version control and repository management.

Common Issues:
• Git not installed
• Local repository not up-to-date

How it works:
• 'git status' shows local changes
• 'git pull' updates repository from remote

Recommended:
→ Run: pkg install git
→ Run: git pull
EOF
      ;;
    *)
      cat <<EOF
🔍 Unknown Issue

No static explanation available.
Manual inspection required.

Recommended:
→ Check Termux logs
→ Inspect binaries and \$PREFIX path
EOF
      ;;
  esac
}
