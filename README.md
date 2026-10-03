

Overview

This project documents Day 1 of my hands-on DevOps learning journey, focused on building practical Linux command-line, Bash scripting, system administration, and troubleshooting skills.

Rather than only memorising commands, the objective of this lab was to understand how Linux commands behave, inspect their output, deliberately introduce faults, identify root causes, and verify fixes.

The main deliverable is a Bash system-information script that collects basic information about the Linux environment and provides visibility into system resources.

Project Objectives

The objectives for Day 1 were to:

Navigate and manage the Linux filesystem

Create and manipulate files and directories

Understand absolute and relative paths

Work with Linux file permissions

Create and execute Bash scripts

Inspect memory, disk, uptime, and processes

Use pipes, redirection, variables, and command substitution

Understand Linux command exit codes

Practise structured troubleshooting

Begin managing the project with Git

Follow basic security practices before publishing code

Environment

This lab was completed using:

Windows with WSL2

Linux command-line environment

Bash

Git

Nano text editor

The kernel reported during the lab was:

6.18.40.1-microsoft-standard-WSL2

Directory Structure

The Day 1 workspace is organised approximately as follows:

day-01-linux/
├── .git/
├── .gitignore
├── README.md
├── application.log
├── backup/
├── logs/
│   └── system-info-output.txt
└── scripts/
    └── system-info.sh

Directory Purpose

Path

Purpose

scripts/

Contains Bash scripts created during the lab

scripts/system-info.sh

Main system-information script

logs/

Stores generated command/script output

logs/system-info-output.txt

Saved output from the system-information script

backup/

Used for file copy, move, and backup exercises

application.log

File used while practising Linux file operations

.gitignore

Used to prevent unwanted or sensitive files from being tracked

README.md

Project documentation

Linux Concepts Practised

Filesystem Navigation

I practised commands including:

pwd
cd
ls
ls -l
ls -la
find

These helped me understand:

My current working directory

Parent and child directories

Hidden files

Relative paths

Absolute paths

Directory structures

File Management

I practised creating and managing files with commands such as:

touch
cp
mv
rm
cat
less

This included creating files, copying them, renaming them, inspecting their contents, and deleting files safely.

Output Redirection

I practised the difference between:

>

and:

>>

> redirects output and overwrites the destination file.

>> appends output to the end of an existing file.

This is useful when generating configuration files, writing logs, and automating Linux tasks.

Searching Text

I used grep to search files and command output.

Examples included:

grep "Warning" application.log

and case-insensitive searches with line numbers.

This is particularly useful when investigating application and system logs.

Linux Permissions

One of the main concepts explored during this lab was Linux file permissions.

Linux permissions are represented using:

r = read
w = write
x = execute

Permissions apply to:

owner | group | others

I used chmod to modify permissions.

For example:

chmod +x scripts/system-info.sh

adds execute permission to the script.

I also deliberately removed permissions to understand how Linux responds:

chmod -x scripts/system-info.sh

and:

chmod 000 scripts/system-info.sh

Attempting to execute the script without execute permission produced:

-bash: ./scripts/system-info.sh: Permission denied

This demonstrated the relationship between file permissions and executable programs.

System Information Script

The main Day 1 build is:

scripts/system-info.sh

The script uses standard Linux utilities to inspect the current environment.

It gathers information including:

Current date and time

Current user

Hostname

Kernel version

System uptime

Memory utilisation

Swap utilisation

Root filesystem disk utilisation

Running processes ordered by memory consumption

The lab also included a disk-usage threshold check.

The root filesystem percentage is extracted using:

disk_usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

The value is then compared against an 80% threshold.

Conceptually:

Root disk usage
      ↓
Extract percentage
      ↓
Remove %
      ↓
Store numeric value
      ↓
Compare against 80
      ↓
Warning / acceptable

The conditional logic tested was:

if [ "$disk_usage" -ge 80 ]; then
    echo "WARNING: root disk usage is ${disk_usage}%"
else
    echo "Disk usage is within the acceptable range: ${disk_usage}%"
fi

During the lab, root disk usage was:

1%

so the result was:

Disk usage is within the acceptable range: 1%

Running the Script

Move into the project directory:

cd ~/devops-journey/day-01-linux

Check the script permissions:

ls -l scripts/system-info.sh

If necessary, give the script execute permission:

chmod +x scripts/system-info.sh

Run it:

./scripts/system-info.sh

Saving the Output

The script output can be displayed in the terminal and saved simultaneously using tee:

./scripts/system-info.sh | tee logs/system-info-output.txt

Here:

|

passes the output from the script to another command.

tee then:

Displays the output in the terminal

Writes the same output into a file

This creates:

logs/system-info-output.txt

Example Output

The following is output produced from my WSL2 environment during the lab:

Sat Oct  3 12:33:22 BST 2026
Shukurah
Shukurah
6.18.40.1-microsoft-standard-WSL2
up 5 hours, 28 minutes

               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       494Mi       7.1Gi       4.0Mi       207Mi       7.1Gi
Swap:          2.0Gi          0B       2.0Gi

Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  3.9G  952G   1% /

USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         271  0.0  0.4 123484 32640 ?        Ssl  07:05   0:00 /usr/bin/python3 ...
root         195  0.0  0.3  44112 29744 ?        Ss   07:05   0:00 /usr/bin/python3 ...
root          71  0.0  0.2  50440 17012 ?        S<s  07:04   0:00 /usr/lib/systemd/systemd-journald
root           1  0.0  0.1  24280 15440 ?        Ss   07:04   0:01 /sbin/init
systemd+     113  0.0  0.1  22428 14424 ?        Ss   07:05   0:00 /usr/lib/systemd/systemd-resolved

The values will change between executions because memory usage, uptime, processes, and other system information are dynamic.

Exit Codes

After running the script, I checked its exit status with:

echo $?

The result was:

0

In Linux:

0        = successful execution
non-zero = error or another failure condition

Exit codes are particularly important in DevOps because automation and CI/CD systems use them to determine whether a command, test, build, or deployment succeeded.

Troubleshooting Lessons

A major objective of this project was learning to investigate failures rather than immediately searching for a solution.

My troubleshooting approach was:

Observe the error
        ↓
Read the message
        ↓
Inspect the current state
        ↓
Form a hypothesis
        ↓
Make one controlled change
        ↓
Run the command again
        ↓
Verify the result

Issue 1 — Unbound Variable

During development, the script initially produced:

./scripts/system-info.sh: line 5: date: unbound variable

After correcting that issue and running the script again, another error appeared:

./scripts/system-info.sh: line 6: whoami: unbound variable

Lesson

There is an important difference between:

A command

A shell variable

Command substitution

For example:

date

runs the date command.

Whereas:

$date

asks Bash to expand a variable named date.

When set -u is enabled, attempting to use a variable that has not been defined produces an unbound variable error.

When command output needs to be captured, command substitution can be used:

current_date=$(date)

This troubleshooting exercise helped reinforce the difference between executing commands and referencing variables.

Issue 2 — Permission Denied

I deliberately removed execute permission:

chmod -x scripts/system-info.sh

Running:

./scripts/system-info.sh

then produced:

-bash: ./scripts/system-info.sh: Permission denied

I restored execute permission using:

chmod +x scripts/system-info.sh

and successfully executed the script again.

Lesson

When receiving:

Permission denied

I should inspect permissions before changing anything:

ls -l scripts/system-info.sh

The troubleshooting process should therefore be:

Permission denied
        ↓
Inspect permissions
        ↓
Identify missing permission
        ↓
Change only required permission
        ↓
Retest

Issue 3 — Removing All Permissions

I also deliberately ran:

chmod 000 scripts/system-info.sh

This removes read, write, and execute permissions from:

Owner

Group

Others

Attempting to execute the script again produced:

Permission denied

Lesson

Linux permissions directly determine what operations users can perform on a file.

chmod should therefore be used carefully, especially with numeric permission modes.

Issue 4 — Command Formatting

While creating .gitignore, I initially entered:

nano.gitignore

which resulted in:

nano.gitignore: command not found

The correct command was:

nano .gitignore

The space is significant.

Lesson

The shell interprets the first word as the command name.

Therefore:

nano .gitignore

means:

command  = nano
argument = .gitignore

while:

nano.gitignore

is interpreted as the name of a completely different command.

This reinforced the importance of reading command syntax carefully.

Git Repository

After completing the Linux exercises, I initialised the project as a Git repository:

git init

I then renamed the primary branch to:

git branch -M main

The project can therefore be developed incrementally while Git records changes to scripts and documentation.

This is the beginning of integrating Linux administration skills with a standard DevOps version-control workflow.

Useful Commands from Day 1

# Show current directory
pwd

# List files
ls -la

# Find directories
find . -maxdepth 2 -type d

# Create a file
touch filename

# Display file contents
cat filename

# Search within text
grep "pattern" filename

# Copy a file
cp source destination

# Move or rename a file
mv source destination

# Remove a file
rm filename

# Check permissions
ls -l filename

# Add execute permission
chmod +x filename

# Display memory usage
free -h

# Display disk usage
df -h

# Display uptime
uptime

# Inspect processes
ps aux

# Sort processes by memory
ps aux --sort=-%mem

# Check previous command exit status
echo $?

# Find files
find . -name "filename"

# Run the system-information script
./scripts/system-info.sh

Security

This project does not require or intentionally store any:

Passwords

AWS access keys

API keys

Authentication tokens

SSH private keys

Database credentials

Other secrets

No credentials are committed as part of this project.

A .gitignore file is included to support safe repository management and to prevent files that should not be version-controlled from being committed.

Before future commits, I will inspect repository changes using:

git status

and:

git diff

Sensitive information should never be hard-coded into Bash scripts or committed to a Git repository.

For future projects that require credentials, secrets will be provided through appropriate mechanisms such as environment variables or dedicated secret-management systems rather than being stored directly in source code.

Key Learning Outcomes

By completing Day 1, I gained practical experience with:

Linux filesystem navigation

File and directory management

Linux permissions

Bash scripting

Shell variables

Command substitution

Conditional logic

Pipes and output redirection

Systematic troubleshooting

The more useful skill is being able to:

observe → investigate → understand → change → verify

This troubleshooting mindset will be applied throughout the rest of my DevOps learning journey.
