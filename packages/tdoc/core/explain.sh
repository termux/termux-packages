#!/usr/bin/env bash
# ==============================
# TDOC — Explanation Runner
# ==============================

# Load AI explanations
source "$TDOC_ROOT/core/ai_explain.sh"

echo -e "🧠 Termux Doctor — Explanation Mode\n"

# Check STATE_FILE exists
if [ ! -f "$STATE_FILE" ]; then
    echo "❌ STATE_FILE not found: $STATE_FILE"
    exit 1
fi

# Loop through the state file
while IFS='=' read -r key value; do
    # Skip OK items
    if [ "$value" = "OK" ]; then
        continue
    fi

    echo -e "🔹 Issue Detected: $key\n"

    # Call ai_explain for each key
    case "$key" in
        Repository)
            ai_explain "Repository"
            ;;
        Storage)
            ai_explain "Storage"
            ;;
        Python)
            ai_explain "Python"
            ;;
        NodeJS)
            ai_explain "NodeJS"
            ;;
        Git)
            ai_explain "Git"
            ;;
        TermuxVersion)
            ai_explain "TermuxVersion"
            ;;
        *)
            ai_explain "Unknown"
            ;;
    esac

    echo "--------------------------------"
done < "$STATE_FILE"

echo -e "\n✅ All explanations processed."
