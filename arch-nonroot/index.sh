#!/bin/bash

username=$EXEC_USER
userpasswd=$EXEC_PASSWD
userid=${EXEC_USER_ID}

echo "Summoning $username - UID:$userid ..."
# Add user
useradd -m -G wheel -s /bin/bash -u $userid $username
# Change password
echo "$username:$userpasswd" | chpasswd
# Assign sudo privillege
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

sudo -u $username /bin/bash