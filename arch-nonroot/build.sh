#!/usr/bin/env bash
# Generate a minimal filesystem for archlinux (requires root)

# codekoala/docker-arch
# Copyright (c) 2014-2016 Josh VanderLinden

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# valorad/va-docka/arch-nonroot
# Copyright (c) 2018 Valorad the Oneiroseeker

set -e

hash docker &>/dev/null || {
  echo "Could not find dcoker. Uh oh are you serious? Run pacman -S docker"
  exit 1
}

hash pacstrap &>/dev/null || {
  echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
  exit 1
}

hash expect &>/dev/null || {
  echo "Could not find expect. Run pacman -S expect"
  exit 1
}

DATE=$(date +"%Y.%m.%d")

echo Building Arch Linux container at ${DATE}...

ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-archlinux-XXXXXXXXXX)
chmod 755 $ROOTFS

# packages to ignore for space savings
PKGIGNORE=(
  dhcpcd
  groff
  iproute2
  jfsutils
  linux
  lvm2
  man-db
  man-pages
  mdadm
  nano
  netctl
  openresolv
  pciutils
  pcmciautils
  reiserfsprogs
  s-nail
  usbutils
  xfsprogs
)
IFS=','
PKGIGNORE="${PKGIGNORE[*]}"
unset IFS

expect <<EOF
  set send_slow {1 .1}
  proc send {ignore arg} {
      sleep .1
      exp_send -s -- \$arg
  }
  set timeout 60
  spawn pacstrap -c -d -G -i $ROOTFS base sudo haveged git --ignore $PKGIGNORE
  expect {
      -exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
      -exact "(default=all): " { send -- "\r"; exp_continue }
      -exact "upgrade? \[y/N\]" { send -- "y\r"; exp_continue }
      -exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
  }
EOF

arch-chroot $ROOTFS /bin/bash -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate archlinux; pkill gpg-agent"

# repo manipulations
mkdir -p $ROOTFS/root/.gnupg
touch $ROOTFS/root/.gnupg/dirmngr_ldapservers.conf
# arch-chroot $ROOTFS /bin/bash -c "pkill dirmngr; pkill gpg-agent"
arch-chroot $ROOTFS /bin/bash -c "ln -sf /usr/share/zoneinfo/UTC /etc/localtime"
echo 'LANG=en_US.UTF-8' > $ROOTFS/etc/locale.conf
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen
arch-chroot $ROOTFS /bin/bash -c 'echo "Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'

# remove locale information
# arch-chroot $ROOTFS /bin/bash -c 'pacman -Sy --noconfirm localepurge && sed -i "/NEEDSCONFIGFIRST/d" /etc/locale.nopurge && localepurge && pacman -R --noconfirm localepurge'

# clean up downloaded packages
rm -rf $ROOTFS/var/cache/pacman/pkg/*

# clean up manpages and docs
rm -rf $ROOTFS/usr/share/{man,doc}
# udev doesn't work in containers, rebuild /dev
DEV=$ROOTFS/dev
rm -rf $DEV
mkdir -p $DEV
mknod -m 666 $DEV/null c 1 3
mknod -m 666 $DEV/zero c 1 5
mknod -m 666 $DEV/random c 1 8
mknod -m 666 $DEV/urandom c 1 9
mkdir -m 755 $DEV/pts
mkdir -m 1777 $DEV/shm
mknod -m 666 $DEV/tty c 5 0
mknod -m 600 $DEV/console c 5 1
mknod -m 666 $DEV/tty0 c 4 0
mknod -m 666 $DEV/full c 1 7
mknod -m 600 $DEV/initctl p
mknod -m 666 $DEV/ptmx c 5 2
ln -sf /proc/self/fd $DEV/fd

# make systemd a bit happier (disable everything except journald)
find $ROOTFS -type l -iwholename "*.wants*" -delete
SYSD=/usr/lib/systemd/system
ln -sf $SYSD/systemd-journald.socket $SYSD/sockets.target.wants/
ln -sf $SYSD/systemd-journald.service $SYSD/sysinit.target.wants/

echo "Compressing filesystem..."
UNTEST=arch-rootfs-untested.tar.xz
tar -f - --numeric-owner --xattrs --acls -C $ROOTFS -c . | xz -c -z - --threads=0 > $UNTEST
rm -rf $ROOTFS

echo "Testing filesystem..."
xzcat $UNTEST | docker import - archtest
docker run -t --rm archtest echo Success.
docker rmi archtest

echo "Approving filesystem..."
mv $UNTEST ./dist/arch-rootfs-${DATE}.tar.xz