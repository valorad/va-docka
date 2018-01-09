#!/bin/bash

username=$EXEC_USER
userpasswd=$EXEC_PASSWD
userid=${EXEC_USER_ID}

# Check if user exists
if id "$username" >/dev/null 2>&1; then
  echo "Waking up $username ..."
else
  echo "Summoning $username - UID:$userid ..."
  # Add user
  useradd -m -G wheel -s /bin/bash -u $userid $username
  # Change password
  echo "$username:$userpasswd" | chpasswd
  # Assign sudo privillege
  echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo
fi

sudo -u $username /bin/bash