#!/bin/bash
# clean-Linux.sh - Remove unused files from /tmp directories
# @author: Saddam ZEMMALI
 
# ------------- Here are Default Configuration --------------------
# CRUNCHIFY_TMP_DIRS - List of directories to search
# DEFAULT_FILE_AGE - # days ago (rounded up) that file was last accessed
# DEFAULT_LINK_AGE - # days ago (rounded up) that symlink was last accessed
# DEFAULT_SOCK_AGE - # days ago (rounded up) that socket was last accessed
 
CRUNCHIFY_TMP_DIRS="/tmp /var/tmp /usr/src/tmp /mnt/tmp"
DEFAULT_FILE_AGE=+2
DEFAULT_LINK_AGE=+2
DEFAULT_SOCK_AGE=+2
 
# Make EMPTYFILES true to delete zero-length files
EMPTYFILES=false
#EMPTYFILES=true
 
cd
/tmp/log "cleantmp.sh[$$] - Begin cleaning tmp directories"
 

# Delete any tmp files that are more than 2 days old
echo ""
echo "delete any tmp files that are more than 2 days old"
/usr/bin/find $CRUNCHIFY_TMP_DIRS  -depth -type f -a -ctime $DEFAULT_FILE_AGE   -print -delete
echo ""
 
 
 
# Delete any old tmp symlinks
echo "delete any old tmp symlinks"
/usr/bin/find $CRUNCHIFY_TMP_DIRS  -depth   -type l -a -ctime $DEFAULT_LINK_AGE  -print -delete
echo ""
 

# Delete any empty files
if /usr/bin/$EMPTYFILES ;
then
echo "delete any empty files"
/usr/bin/find $CRUNCHIFY_TMP_DIRS  -depth  -type f -a -empty  -print -delete
fi
 
# Delete any old Unix sockets 
echo "Delete any old Unix sockets"
/usr/bin/find $CRUNCHIFY_TMP_DIRS   -depth    -type s -a -ctime $DEFAULT_SOCK_AGE -a -size 0 -print -delete
echo""
 
# Delete any empty directories (other than lost+found)
echo "delete any empty directories (other than lost+found)"
/usr/bin/find $CRUNCHIFY_TMP_DIRS  -depth -mindepth 1 -type d -a -empty -a ! -name 'lost+found'  -print -delete
echo ""
 
/usr/bin/logger "cleantmp.sh[$$] - Done cleaning tmp directories"
 
# send out an email about diskcleanup action
mail -s "Disk cleanup has been performed successfully." you@email.com
 
echo ""
echo "Diskcleanup Script Successfully Executed"
exit 0
