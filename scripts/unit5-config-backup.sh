#!/bin/bash

# 1. Declare the variable that will store the report with a timestamp format 
timestamp=$(date +"%Y-%m-%d%_%H%M%S") 
BACKUPDIR=~/linux-plus-study/backups/unit5_$timestamp
ARCHIVE=$BACKUPDIR/config_backup_$timestamp.tar.gz
CHECKSUM=$BACKUPDIR/config_backup_$timestamp.sha256
MANIFEST=$BACKUPDIR/config_backup_$timestamp\_manifest.txt

# 2.Target files
CONFIG_FILES=(
    /etc/hostname
    /etc/hosts
    /etc/fstab
    /etc/passwd
    /etc/group
    /etc/sudoers
    /etc/ssh/sshd_config
    /etc/crontab
)

# 3. Create bkp directory
mkdir -p "$BACKUPDIR"

# 4. Separete readable files from unreadable

READABLE_FILES=()
WARNINGS=()

for file in "${CONFIG_FILES[@]}"; do
    if [ ! -e "$file" ]; then
        # File doesn't exist at all
        WARNINGS+=("$file - skipped (file not found)")
    elif [ ! -r "$file" ]; then
        # File exists but current user cannot read it
        WARNINGS+=("$file - skipped (permission denied)")
    else
        # File is readable — add to archive list
        READABLE_FILES+=("$file")
    fi
done

# 5. Create the compressed archive

echo "Creating archive..."
tar -czvf "$ARCHIVE" "${READABLE_FILES[@]}" > /tmp/tar_output.tmp 2>&1
TAR_EXIT=$?


# 6. Generate CKSUM
if [ $TAR_EXIT -eq 0 ]; then
    echo "Generating checksum..."
    sha256sum "$ARCHIVE" > "$CHECKSUM"
else
    echo "WARNING: tar exited with code $TAR_EXIT — checksum skipped"
fi


# 7Verify the archive

if [ -f "$CHECKSUM" ]; then
    sha256sum -c "$CHECKSUM" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        VERIFY_RESULT="PASSED"
    else
        VERIFY_RESULT="FAILED — archive may be corrupted"
    fi
else
    VERIFY_RESULT="SKIPPED — no checksum file generated"
fi


# 8. Build the manifest

{
echo "=== Unit 5 Project: Automated Configuration Backup & Integrity System ==="
echo ""
echo "Backup Date:        $(date '+%Y-%m-%d %H:%M:%S')"
echo "Hostname:           $HOSTNAME"
echo "Archive Name:       $(basename $ARCHIVE)"
echo "Archive Size:       $(du -sh $ARCHIVE 2>/dev/null | cut -f1)"
echo "Compression:        gzip"
echo "Checksum Algorithm: SHA-256"
echo "Checksum File:      $(basename $CHECKSUM)"
echo ""
echo "--- Files Archived ---"
cat /tmp/tar_output.tmp
echo ""

# Print any warnings collected during pre-flight check
if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo "--- Warnings ---"
    for warn in "${WARNINGS[@]}"; do
        echo "  $warn"
    done
    echo ""
fi

echo "--- Verification ---"
echo "  Result: $VERIFY_RESULT"
echo ""
echo "=== End of Manifest ==="
} > "$MANIFEST"


#9 Final summary

echo ""
echo "Backup complete."
echo "  Archive:    $ARCHIVE"
echo "  Checksum:   $CHECKSUM"
echo "  Manifest:   $MANIFEST"
echo "  Verification: $VERIFY_RESULT"
echo ""
echo "--- Manifest Preview ---"
tail -20 "$MANIFEST"

# Cleanup temp file
rm -f /tmp/tar_output.tmp

