# Troubleshooting Notes

## Incident 1 — Permission Denied

### Problem
The Bash script could not be executed.

### Error observed
```text
Permission denied

Investigation commands
ls -l scripts/system-info.sh

Root cause
The script did not have execute permission.

Fix
chmod +x scripts/system-info.sh

Verification
ls -l scripts/system-info.sh
./scripts/system-info.sh

How to prevent it
Check file permissions before executing scripts directly with ./script.sh.

Incident 2 — Command Not Found

Problem
A command inside the script was misspelled.

Error observed
command not found

Investigation commands
command -v hostname
command -v hostnme

Root cause
The command name was incorrect.

Fix
Correct the spelling of the command.

Verification
Run the script again and confirm the command executes successfully.

How to prevent it
Check command spelling and use command -v to verify that a command exists

Incident 3 — Incorrect Relative Path

Problem
The script could not be found when run from a different directory.

Investigation commands
pwd
find ~/devops-journey -name "system-info.sh"

Root cause
The relative path ./scripts/system-info.sh was being resolved from the wrong current directory.

Fix
Either move to the repository root:
cd ~/devops-journey/day-01-linux
./scripts/system-info.sh

or use the absolute path:
~/devops-journey/day-01-linux/scripts/system-info.sh

Verification
Confirm the script runs successfully.

How to prevent it
Always check the current working directory with pwd before using relative paths.
