#!/bin/bash
# Execute the up-coming commands on behalf of a specific user
# By default, we try to do this with the user of UID=1000. Can also be overriden.
# If userid exists, we will use this existing user and ignores the username/userpasswd
# Otherwise, we will create a new user based on the given userid, username and userpasswd

userpasswd=$EXEC_PASSWD
userid=$EXEC_USER_ID
username=$EXEC_USER_NAME

: ${userid:=1000}
: ${username:="notroot"}
: ${userpasswd:="please_change"}

# Check if userid exists
if id "$userid" >/dev/null 2>&1; then
  username=$(id -nu $userid)
  echo "Waking up $username ..."
else
  echo "Summoning $username - UID:$userid ..."
  # Add user
  useradd -m -s /bin/bash -G sudo -u $userid $username
  # Change password
  echo "$username:$userpasswd" | chpasswd
fi

exec sudo -u $username "$@"