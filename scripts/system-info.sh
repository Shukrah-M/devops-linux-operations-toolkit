
#!/usr/bin/env bash

set -u
date
whoami
hostname
uname -r
uptime -p
free -h
df -h /
ps aux --sort=-%mem
