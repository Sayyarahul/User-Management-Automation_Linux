#!/bin/bash
# ============================================================
# Script: create_users.sh (WSL-Safe Version)
# Purpose: Simulated Linux user management inside WSL
# ============================================================

INPUT_FILE="employees.txt"
FAKE_DB="fake_users.db"
FAKE_GROUP_DB="fake_groups.db"
LOG_FILE="user_management.log"
PASS_DIR="/home/rahul_sayya/user-management/passwords"
BASE_HOME="$HOME/wsl_users"

# Ensure directories exist
mkdir -p "$BASE_HOME" "$PASS_DIR"
touch "$FAKE_DB" "$FAKE_GROUP_DB" "$LOG_FILE"

# Clear log file each run
echo "" > "$LOG_FILE"

# Password generator
generate_password() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12
}

echo "=== WSL User Creation Started at $(date) ===" | tee -a "$LOG_FILE"

while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^# || -z "$line" ]] && continue

    clean_line=$(echo "$line" | tr -d '[:space:]')
    username=$(echo "$clean_line" | cut -d';' -f1)
    groups=$(echo "$clean_line" | cut -d';' -f2)

    # Check if user exists already
    if grep -q "^$username$" "$FAKE_DB"; then
        echo "[WARN] User $username already exists (fake)." | tee -a "$LOG_FILE"
        continue
    fi

    # Add user to fake DB
    echo "$username" >> "$FAKE_DB"
    echo "[INFO] Created fake user: $username" | tee -a "$LOG_FILE"

    # Create fake groups
    IFS=',' read -ra group_list <<< "$groups"
    for grp in "${group_list[@]}"; do
        if ! grep -q "^$grp$" "$FAKE_GROUP_DB"; then
            echo "$grp" >> "$FAKE_GROUP_DB"
            echo "[INFO] Created fake group: $grp" | tee -a "$LOG_FILE"
        fi
        echo "[INFO] Added $username to group: $grp" | tee -a "$LOG_FILE"
    done

    # Create fake home
    HOME_DIR="$BASE_HOME/$username"
    mkdir -p "$HOME_DIR"
    echo "[INFO] Created fake home: $HOME_DIR" | tee -a "$LOG_FILE"

    # Create separate password file
    password=$(generate_password)
    echo "$password" > "$PASS_DIR/$username.pass"
    echo "[INFO] Password saved: $PASS_DIR/$username.pass" | tee -a "$LOG_FILE"

done < "$INPUT_FILE"

echo "=== Script Completed at $(date) ===" | tee -a "$LOG_FILE"
