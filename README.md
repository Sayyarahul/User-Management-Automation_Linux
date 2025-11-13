User Management Automation Script (WSL-Compatible)

This project automates user onboarding using a Bash script.
It reads user information from an input file, creates user accounts, assigns groups, generates passwords, and organizes home directories — all from one command.

Fully compatible with Windows Subsystem for Linux (WSL).

Features

Automated user creation

Group assignment

Auto-generated 12-character passwords

Separate password files per user

Organized home directories

Central logging

Simple Project Architecture

employees.txt
     │
     ▼
create_users.sh
     │
     ├── Creates users  → fake_users.db
     ├── Creates groups → fake_groups.db
     ├── Creates home folders → wsl_users/<username>/
     ├── Generates passwords → passwords/<username>.pass
     └── Logs actions → user_management.log

Easy to extend

 Folder Structure
 
user-management/
│
├── create_users.sh
├── employees.txt
├── user_management.log
│
├── passwords/
│     ├── light.pass
│     ├── rahul.pass
│     └── akki.pass
│
└── wsl_users/
      ├── light/
      ├── rahul/
      └── akki/

 Input File Format

employees.txt

username; group1,group2,group3


Example:

light; sudo,dev,www-data
rahul; sudo
akki; dev,www-data

How to Run the Script

1. Navigate to project folder
cd /home/rahul_sayya/user-management

2.Open in VS Code
code .

3. Make script executable
chmod +x create_users.sh

4. Run
./create_users.sh

Check Outputs
Passwords
ls passwords/
cat passwords/light.pass

Logs
cat user_management.log

Home directories
ls ~/wsl_users/

How It Works

Reads each line from employees.txt

Extracts username and group list

Creates a home directory in ~/wsl_users/

Generates a strong random password

Saves it in: passwords/<username>.pass

Logs all actions in user_management.log

Example Output
[INFO] Created user: light
[INFO] Added light to group: sudo
[INFO] Added light to group: dev
[INFO] Added light to group: www-data
[INFO] Password saved: passwords/light.pass

[INFO] Created user: rahul
[INFO] Added rahul to group: sudo
[INFO] Password saved: passwords/rahul.pass

[INFO] Created user: akki
[INFO] Added akki to group: dev
[INFO] Added akki to group: www-data
[INFO] Password saved: passwords/akki.pass

Password Storage

Each user receives a unique 12-character password

Stored in separate files (<username>.pass)

Easy for administrators to manage

Secure, readable, and organized

 Future Enhancements

User deletion script

Reset password tool

Export users to CSV

Colorful terminal UI

Real Linux system user creation (VM/Server)

Author

Rahul Sayya
User & Group Management Automation
