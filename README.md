# User Management Automation Script — WSL/Linux

## Overview
This project automates the onboarding of new users in a Linux environment.  
It reads a list of usernames and their group memberships from a text file and automatically performs the following:

- Creates users and assigns them to groups  
- Sets up home directories with correct ownership and permissions  
- Generates secure random passwords  
- Logs all actions for auditing  
- Stores credentials securely in protected system directories  

This script demonstrates real-world **SysOps automation** skills used in DevOps and Linux administration.

---

## Project Purpose
Manually creating users and assigning permissions is slow and error-prone.  
This project solves that by providing a reusable Bash script — `create_users.sh` — that performs user management tasks automatically with security, logging, and error handling.

---

## Project Structure
~/user-management/
├── create_users.sh # Main Bash script
├── employees.txt # Input file containing users and groups
└── README.md # Documentation (this file)

### System Files Created by Script
| File / Directory | Purpose |
|------------------|----------|
| `/var/log/user_management.log` | Stores detailed logs of actions (success, errors, skips) |
| `/var/secure/user_passwords.txt` | Stores usernames and randomly generated passwords |
| `/home/<username>` | Home directory created for each new user |
| `/etc/passwd` | System record of all Linux users |
| `/etc/group` | System record of all user groups |

---

## Input File Format (`employees.txt`)
The script reads from `employees.txt`, which contains usernames and their assigned groups.

### Example:

 Notes:
- Each line = `username;group1,group2,group3`
- Lines starting with `#` are ignored (comments)
- Whitespace is automatically ignored

---

## How It Works (Step-by-Step)

1. **Setup Secure Directories**
   - Creates `/var/log` and `/var/secure` if they don’t exist  
   - Ensures strict permissions (`chmod 600`)  

2. **Read Input File**
   - Reads `employees.txt` line by line  
   - Skips comments and blank lines  

3. **Parse Each Line**
   - Extracts `username` and `group` values using `cut` and `tr`

4. **Create Primary Group**
   - If the primary group doesn’t exist, it creates it with:
     ```bash
     sudo groupadd <username>
     ```

5. **Create User**
   - Creates the user, assigns groups, and defines the shell:
     ```bash
     sudo useradd -m -g <username> -G <groups> -s /bin/bash <username>
     ```

6. **Create Home Directory**
   - Ensures `/home/<username>` exists and applies correct ownership and permissions.

7. **Generate Password**
   - Creates a 12-character secure password:
     ```bash
     tr -dc A-Za-z0-9 </dev/urandom | head -c 12
     ```

8. **Set Password**
   - Applies it to the user using:
     ```bash
     echo "username:password" | sudo chpasswd
     ```

9. **Save Password Securely**
   - Appends `username : password` to `/var/secure/user_passwords.txt`

10. **Log Activity**
    - Every action (success, warning, or error) is logged to `/var/log/user_management.log`

11. **Handle Duplicates**
    - Existing users and groups are skipped gracefully with log entries.

---

## Commands Used in the Project

```bash
# Step 1: Create project folder
mkdir -p ~/user-management
cd ~/user-management

# Step 2: Create input file
cat > employees.txt <<EOF
# Employee onboarding list
rahul; sudo,dev,www-data
akki; sudo
EOF

# Step 3: Create and edit the script
nano create_users.sh

# Step 4: Make it executable
chmod +x create_users.sh

# Step 5: Run as root
sudo ./create_users.sh

# Step 6: Verify results
getent passwd rahul akki
groups rahul
groups akki

# Step 7: View logs and passwords
sudo cat /var/log/user_management.log
sudo cat /var/secure/user_passwords.txt

Log File (/var/log/user_management.log)
[INFO] Created group: rahul
[SUCCESS] Created user: rahul with groups: sudo,dev,www-data
[INFO] Created home directory for rahul
[INFO] Created group: akki
[SUCCESS] Created user: akki with groups: sudo

Password File (/var/secure/user_passwords.txt)
rahul : Xy8Bz2LpRk7A
akki : Dt5Gh3KsPp9W

Security Considerations

Must be run with sudo privileges

Sensitive data stored in /var/secure/user_passwords.txt (permissions 600)

Logs restricted to root access (600)

Passwords are randomly generated and not stored in plaintext beyond that file

To safely delete sensitive data:

sudo shred -u /var/secure/user_passwords.txt

 Error Handling
 
Scenario	Script Behavior
Comment or empty line	Ignored
User already exists	Logs a warning and skips
Group already exists	Reuses the existing group
Permission denied	Displays error and logs it
Invalid input format	Skips line and logs error

 Testing Scenarios

Test Case	Expected Result
Add new users (rahul, akki)	Created successfully
Re-run script	Existing users skipped
Check /var/log	Shows creation logs
Check /var/secure	Passwords stored securely
Run without sudo	Fails with permission error

 Tools & Commands Used
 
Command	Purpose
nano, cat	File creation and editing
chmod, mkdir, touch	File and directory setup
useradd, groupadd	User and group creation
chpasswd	Set passwords
tee	Logging output
getent, groups, id	Verify users and groups
sudo	Run privileged operations

 Cleanup Commands (Optional)

If you want to remove created users and logs:

sudo userdel -r rahul
sudo userdel -r akki
sudo rm -f /var/secure/user_passwords.txt /var/log/user_management.log

 Summary

This project demonstrates:

Practical SysOps automation skills

Linux administration using Bash

Secure password management

Structured logging and auditing

Scalable user onboarding process

You can extend this script to integrate with Ansible, LDAP, or cloud IAM systems for enterprise use.

 Author

Rahul Sayya
SysOps Engineer | Linux Automation Enthusiast
 Project: User Management Automation (WSL/Linux)
 Completed: November 2025
