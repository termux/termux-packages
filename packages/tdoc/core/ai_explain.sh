#!/usr/bin/env bash
# ==============================
# TDOC — AI Explain Engine (Offline, English)
# ==============================
# Static, local explanations for common Termux issues
# Fully compliant with Termux-packages
# Usage:
#   source core/ai_explain.sh
#   ai_explain <item>
# ==============================

# -----------------------
# Disclaimer
# -----------------------
# NOTE: This is a static explanation helper.
# It provides guidance based on predefined knowledge.
# It is NOT a real AI; all explanations are local and offline.
# -----------------------

ai_explain() {
  local item="$1"

  case "$item" in

    Storage)
      cat <<EOF
🔍 Storage Explanation

Termux requires storage permission to read/write files in /storage/shared.

Common Issues:
• User did not run 'termux-setup-storage'
• Permission revoked by Android

How it works:
• 'termux-setup-storage' creates symlinks in \$HOME/storage
• Allows access to internal shared storage and SD card directories

Recommended Action:
→ Run: termux-setup-storage
EOF
      ;;

    Repository)
      cat <<EOF
🔍 Repository Explanation

Termux package repository is the source of all 'pkg' and 'apt' packages.

Common Issues:
• Main repo or mirror not reachable
• Repository outdated or not compatible with architecture

How it works:
• Repositories listed in \$PREFIX/etc/apt/sources.list
• 'apt update' fetches package lists from these repositories
• Ensure repository signatures are valid using Termux keyring

Recommended Action:
→ Run: termux-change-repo
EOF
      ;;

    NodeJS)
      cat <<EOF
🔍 NodeJS Explanation

NodeJS is required to run JavaScript apps and npm packages.

Common Issues:
• NodeJS not installed
• Binary missing or corrupted

How it works:
• NodeJS package is official from Termux
• Install via: 'pkg install nodejs'

Recommended Action:
→ Run: pkg install nodejs
EOF
      ;;

    Python)
      cat <<EOF
🔍 Python Explanation

Python is required for scripts and Python apps in Termux.

Common Issues:
• Python not installed
• Binary missing, corrupted, or from wrong repository

How it works:
• Install official Python package via pkg
• Binary path: \$PREFIX/bin/python

Recommended Action:
→ Run: pkg reinstall python
EOF
      ;;

    Git)
      cat <<EOF
🔍 Git Explanation

Git is used for version control and repository management.

Common Issues:
• Git not installed
• Local repository not in sync with remote

How it works:
• 'git status' shows local changes
• 'git pull' updates local repository from remote

Recommended Action:
→ Run: pkg install git
→ Run: git pull
EOF
      ;;

    TermuxVersion)
      cat <<EOF
🔍 Termux Version Explanation

Termux may be outdated, causing compatibility issues.

Common Issues:
• Old version installed from Play Store or F-Droid
• Repository misconfigured

How it works:
• Run 'pkg update && pkg upgrade' to update Termux packages
• Ensure Termux itself is latest version

Recommended Action:
→ Update Termux from official source
→ Run: pkg update && pkg upgrade
EOF
      ;;

    *)
      cat <<EOF
🔍 Unknown Issue

No static explanation available.
Manual inspection required.

Recommended Action:
→ Check Termux logs
→ Inspect binaries and \$PREFIX path
EOF
      ;;
  esac
}

# -----------------------
# Optional interactive helper
# -----------------------
ai_explain_interactive() {
  echo "Available explanation items:"
  echo "1) Storage"
  echo "2) Repository"
  echo "3) NodeJS"
  echo "4) Python"
  echo "5) Git"
  echo "6) TermuxVersion"
  echo
  read -rp "Select item to explain: " choice
  case "$choice" in
    1) ai_explain "Storage" ;;
    2) ai_explain "Repository" ;;
    3) ai_explain "NodeJS" ;;
    4) ai_explain "Python" ;;
    5) ai_explain "Git" ;;
    6) ai_explain "TermuxVersion" ;;
    *) echo "Invalid selection" ;;
  esac
}

# End of ai_explain.sh
