# arch-nonroot
[![Docker Pulls](https://img.shields.io/docker/pulls/valorad/arch-nonroot.svg?style=flat-square)](https://hub.docker.com/r/valorad/arch-nonroot/)

从0开始制作的Arch linux，能够以非root用户运行，可以使用systemd。

## 用途
比如作为增强版的Windows Linux Subsystem？😏

## 运行
``` powershell
# Powershell:
docker run -it `
 --name arch-c1 `
 # 加入这句话，如果您要使用systemd
 --cap-add SYS_ADMIN  `
 -e EXEC_USER=$USER -e EXEC_PASSWD=[YOUR PASSWORD] -e EXEC_USER_ID=$UID `
 # 加入这句话，如果您要使用systemd
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro `
 # （下面两个-v可选）
 -v /workspace/workbench:/workspace/workbench ` 
 -v /workspace/downloadCenter/_docking:/workspace/docking `
 valorad/arch-nonroot /usr/bin/init
```
其中`$USER`换成您的用户名

`[YOUR PASSWORD]`换为您希望设置的密码，特殊字符记得转义。

`$UID`为Linux用户ID（一般是1000）

如果在linux环境下运行docker容器，您可以不必设置 `$USER` 和 `$UID`。

两个`-v`匿名卷挂载（`/workspace/workbench` 和 `/workspace/downloadCenter`）是可选的。前者作为以前Windows的Linux子系统的工作文件夹（比如用来放代码、放服务器配置等等），后者是和外界的交换空间（比如用来传递容器内文件）。

国内的小伙伴们可以选择加挂`/path/2/here/goodies/mirrorlist:/etc/pacman.d/mirrorlist` 来换成国内源，或者通过`docking`文件夹拷入容器内。

## 创建
首先以root用户运行build.sh

然后手动更改`dockerfile`，把`arch-rootfs-2018.02.22.tar.xz`后面的日期改为上一步实际生成的日期。

接下来运行：
``` bash
docker build . -t arch-nonroot
```