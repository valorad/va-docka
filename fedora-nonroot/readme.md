# arch-nonroot
[![Docker Stars](https://img.shields.io/docker/stars/valorad/fedora-nonroot.svg?style=flat-square)](https://hub.docker.com/r/valorad/fedora-nonroot/)

基于Fedora官方镜像制作，以非root用户运行。已经开启了rpmfusion源。

## 运行
``` bash
# bash:
docker run -it \
 --name fedora-c1 \
 -e EXEC_USER=$USER -e EXEC_PASSWD="[YOUR PASSWORD]" -e EXEC_USER_ID=$UID \
 -v /workspace/workbench:/workspace/workbench \
 -v /workspace/downloadCenter:/workspace/docking \
 valorad/fedora-nonroot
```
其中`$USER`换成您的用户名，`[YOUR PASSWORD]`换为您希望设置的密码（如果您的密码包含特殊字符请务必转义，外边加引号） `$UID`为Linux用户ID（一般是1000）

两个`-v`匿名卷挂载（`/workspace/workbench` 和 `/workspace/downloadCenter`）是可选的。

国内的小伙伴们可以选择加挂`/path/2/here/goodies/某个源文件夹:/etc/yum.repos.d/某个源.repo` 来换成国内源。或者也可以将文件通过`docking`匿名卷拷贝进容器的`/etc/yum.repos.d/`目录下。

## 创建
``` bash
docker build . -t fedora-nonroot
```