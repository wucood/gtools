#!/bin/bash

## Author: wuhaomiao                    
## Mail: wucood@gmail.com
## Date: 2022-09-07
## cmake编译安装mysql5.6

installTempDir=/usr/src/wuhaomiao/src

mysqlVersion=mysql-5.6.51
mysqlInstallDir=/usr/local/mysql
mysqlDownloadUrl=https://mirrors.aliyun.com/mysql/MySQL-5.6/${mysqlVersion}.tar.gz
# 数据目录
mysqlDataDir=/data/mysql

# cmake相关
cmakeVersion=cmake-3.24.1-linux-x86_64
cmakeDownloadUrl=https://github.com/Kitware/CMake/releases/download/v3.24.1/${cmakeVersion}.tar.gz

# jemalloc 内存管理
jemallocVersion=jemalloc-5.3.0
jemallocDownloadUrl=https://github.com/jemalloc/jemalloc/releases/download/5.3.0/${jemallocVersion}.tar.bz2



[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
[ -e "${mysqlInstallDir}/bin/mysql" ] && { echo "MySQL allready installed, please check it!"; exit 1; }


function DownloadMySQL(){
    echo "开始下载安装包..."
    [ ! -d "${installTempDir}" ] && mkdir -p ${installTempDir}
    cd ${installTempDir}
    command -v wget
    [ $? -ne 0  ] && yum install wget -y 

    wget -cq ${mysqlDownloadUrl}
    [ $? -ne 0 ] && { echo "Download Failed, please check again!"; exit 1; }
    echo "Download success!"
}


function JemallocInstall(){
    [ -z "$(ls /usr/local/bin | grep "jemalloc.sh")" ] && {echo "Jemalloc allready installed!";}
    cd ${installTempDir}
    echo "Start install jemalloc"
    wget -cq ${jemallocDownloadUrl}
    yum install bzip2 -y
    tar jxf ${jemallocVersion}.tar.bz2
    cd ${jemallocVersion}
    ./configure
    make && make install
    [ $? -ne 0 ] && { echo "Install jemalloc Failed, please check again!"; exit 1; }
    echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
    ldconfig
    echo "jemalloc install success!"
    sleep 1
}


function MysqlInstall(){
    [ -e "${mysqlInstallDir}/bin/mysql" ] && { echo "MySQL allready installed, please check it!"; exit 1; }
    cd ${installTempDir}  # 可以忽略，download时已经进入此目录
    echo "Start install Mysql${mysqlVersion}"
    sleep 2
    # 安装依赖
    yum install pcre pcre-devel openssl openssl-devel gcc-c++ ncurses-devel -y

    id -u mysql >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -M -s /sbin/nologin mysql

    [ ! -d ${mysqlInstallDir} ] && mkdir -p ${mysqlInstallDir}
    [ ! -d ${mysqlDataDir} ] && mkdir -p ${mysqlDataDir}

    # install cmake
    echo "Start instatll camke"
    wget -cq ${cmakeDownloadUrl}
    [ $? -ne 0 ] && { echo "Download cmake Failed, please check again!"; exit 1; }
    tar xf ${cmakeVersion}.tar.gz
    ${installTempDir}/${cmakeVersion}/bin/cmake -version > /dev/null 2>&1
    [ $? -ne 0 ] && { echo "Install cmake Failed, please check again!"; exit 1; }
    cmake=${installTempDir}/${cmakeVersion}/bin/cmake
    echo "Install cmake success!"
    sleep 1

    tar xf ${mysqlVersion}.tar.gz
    cd ${mysqlVersion}
    ${cmake} . -DCMAKE_INSTALL_PREFIX=${mysqlInstallDir} \
    -DMYSQL_DATADIR=${mysqlDataDir} \
    -DSYSCONFDIR=/etc \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_EMBEDDED_SERVER=1 \
    -DENABLE_DTRACE=0 \
    -DENABLED_LOCAL_INFILE=1 \
    -DDEFAULT_CHARSET=utf8mb4 \
    -DDEFAULT_COLLATION=utf8mb4_general_ci \
    -DEXTRA_CHARSETS=all \
    -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc'
    make && make install
    [ $? -ne 0 ] && { echo "cmake MySQL failed, please check again!"; exit 1; }
}


DownloadMySQL
# 安装jemalloc内存管理
JemallocInstall
MysqlInstall
