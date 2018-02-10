#!/bin/sh
# This file is used to change permission for a normal user on docker container run.

# start nginx as root
nginx -g 'pid /tmp/nginx.pid; daemon off;'
# when exited, continue sh shell as non-root

# Adding a local user
username=$EXEC_USER
userid=$EXEC_USER_ID

# Check if user exists
if id "$username" >/dev/null 2>&1; then
  echo "Waking up $username ..."
else
  echo "Summoning $username - UID:$userid ..."
  # Add user
  adduser $username -u $userid -D -s /bin/sh
  chown -R $username /workspace/www
  chmod -R 755 /workspace/www
fi

su-exec $username "$@"