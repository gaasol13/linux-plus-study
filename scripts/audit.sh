#!/bin/bash

# Filesystem and permissions audit
# Linux+ Units 3 and 4 practice project

REPORT=~/linux-plus-study/reports/audit_$(date +%Y%m%d).txt

# Start report - creates the file fresh each run
echo "=== AUDIT REPORT: $(date) ===" > $REPORT

# 1: Disk usage (Unit 4: FHS awareness)
echo "" >> $REPORT
echo "--- Disk usage ---" >> $REPORT
df -h >> $REPORT

# 2: Recent changes in /etc (unit 4 - find -mtime)
echo "" >> $REPORT
echo "--- Files changed in /etc last 24h ---" >> $REPORT
find /etc -mtime -1 -type f 2>/dev/null > $REPORT

# 3: World-writable files (Unit 3 - permission audit)
echo "" >> $REPORT
echo "--- World writable files ---" >> $REPORT
find / -perm -o+w -not -path "/proc/*" -type f 2>/dev/null >> $REPORT

# 4: SUID files (unit 3 - special permissions)
echo "" >> $REPORT
echo "--- SUID files ---" >> $REPORT
find / -perm /4000 -type f 2>/dev/null >> $REPORT

# 5: Check critical file permissions (unit3)
echo "" >> $REPORT
echo "--- /etc/passwd and /etc/shadow permissions ---" >> $REPORT
ls -la /etc/passwd /etc/shadow >> $REPORT

# 6: Recent auth failures (Unit 4 - grep + pipes)
echo "" >> $REPORT
echo "--- Recent auth failures ---" >> $REPORT
grep -i "failed" /var/log/auth.log 2>/dev/null | tail -10 >> $REPORT

# Done
echo "" >> $REPORT
echo "=== AUDIT COMPLETE ===" >> $REPORT
chmod 600 $REPORT
echo "Report saved to: $REPORT"

