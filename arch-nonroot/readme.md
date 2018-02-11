# arch-nonroot
[![Docker Pulls](https://img.shields.io/docker/pulls/valorad/arch-nonroot.svg?style=flat-square)](https://hub.docker.com/r/valorad/arch-nonroot/)

以非root用户运行的Arch Linux，基于Arch Linux官方镜像制作。

## 用途
比如作为增强版的Windows Linux Subsystem？😏

## 运行
``` powershell
# Powershell:
docker run -it `
 --name arch-c1 `
 -e EXEC_USER=$USER -e EXEC_PASSWD=[YOUR PASSWORD] -e EXEC_USER_ID=$UID `
 -v /workspace/workbench:/workspace/workbench `
 -v /workspace/docking:/workspace/docking `
 valorad/arch-nonroot
```
其中`$USER`换成您的用户名，`[YOUR PASSWORD]`换为您希望设置的密码 `$UID`为Linux用户ID（一般是1000）

两个`-v`匿名卷挂载（`/workspace/workbench` 和 `/workspace/docking`）是可选的。前者作为以前Windows的Linux子系统的工作文件夹（比如用来放代码、放服务器配置等等），后者是和外界的交换空间（比如用来传递容器内文件）。

国内的小伙伴们可以选择加挂`/path/2/here/goodies/mirrorlist:/etc/pacman.d/mirrorlist` 来换成国内源。

## 创建
``` bash
docker build . -t arch-nonroot
```