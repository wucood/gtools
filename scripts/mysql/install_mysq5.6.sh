#!/bin/bash

## Author: wuhaomiao                    
## Mail: wucood@gmail.com
## Date: 2022-09-07
## cmake编译安装mysql5.6

installTempDir=/usr/src/wucood/src

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

# 安装依赖
yum install pcre pcre-devel openssl openssl-devel gcc-c++ ncurses-devel -y
# docker容器里安装，没有perl，安装perl
cmmand -v perl
[ $? -ne 0 ] && yum install perl perl* -y

function DownloadMySQL(){
    echo "Start download MySQL."
    [ ! -d "${installTempDir}" ] && mkdir -p ${installTempDir}
    cd ${installTempDir}
    command -v wget
    [ $? -ne 0  ] && yum install wget -y 

    wget -cq ${mysqlDownloadUrl}
    [ $? -ne 0 ] && { echo "Download MySQL Failed, please check again!"; exit 1; }
    echo "Download MySQL success!"
}


function JemallocInstall(){
    [ ! -z "$(ls /usr/local/bin | grep "jemalloc.sh")" ] && { echo "Jemalloc allready installed!"; return 1; }
    cd ${installTempDir}
    echo "Start install jemalloc"
    wget -cq ${jemallocDownloadUrl}
    [ $? -ne 0 ] && { echo "Download jemalloc Failed, please check again!"; exit 1; }
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
    mysqlRootPWD="eleven2022"
    [ -e "${mysqlInstallDir}/bin/mysql" ] && { echo "MySQL allready installed, please check it!"; exit 1; }
    cd ${installTempDir}  # 可以忽略，download时已经进入此目录
    echo "Start install Mysql${mysqlVersion}"
    sleep 2

    id -u mysql >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -M -s /sbin/nologin mysql

    [ ! -d ${mysqlInstallDir} ] && mkdir -p ${mysqlInstallDir}
    [ ! -d ${mysqlDataDir} ] && mkdir -p ${mysqlDataDir}

    # install cmake
    command -v cmake
    if [ $? -ne 0 ]; then
        echo "Start instatll camke"
        wget -cq ${cmakeDownloadUrl}
        [ $? -ne 0 ] && { echo "Download cmake Failed, please check again!"; exit 1; }
        tar xf ${cmakeVersion}.tar.gz
        ${installTempDir}/${cmakeVersion}/bin/cmake -version > /dev/null 2>&1
        [ $? -ne 0 ] && { echo "Install cmake Failed, please check again!"; exit 1; }
        # cmake=${installTempDir}/${cmakeVersion}/bin/cmake
         mv ${installTempDir}/${cmakeVersion} /usr/local/cmake
        ln -s /usr/local/cmake/bin/cmake /usr/bin/cmake
        . /etc/profile
        echo "Install cmake success!"
        sleep 1
    fi


    tar xf ${mysqlVersion}.tar.gz
    cd ${mysqlVersion}
    cmake . -DCMAKE_INSTALL_PREFIX=${mysqlInstallDir} \
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
    echo "cmake MySQL success!"
    sleep 1
    cp ${mysqlInstallDir}/support-files/mysql.server /etc/init.d/mysqld     # 添加mysqld服务
    sed -i "s@^basedir=.*@basedir=${mysqlInstallDir}@" /etc/init.d/mysqld
    sed -i "s@^datadir=.*@datadir=${mysqlDataDir}@" /etc/init.d/mysqld
    echo "export PATH=${mysqlInstallDir}/bin:\$PATH" >> /etc/profile         # 添加环境变量
    chown mysql.mysql -R ${mysqlDataDir}

    [ ! -e "/etc/my.cnf" ] && touch /etc/my.cnf
    cat > /etc/my.cnf << EOF
[client]
port = 3306
socket = ${mysqlDataDir}/mysql.sock

[mysql]
prompt="MySQL [\d]> "
no-auto-rehash

[mysqld]
port = 3306
socket = ${mysqlDataDir}/mysql.sock

basedir = ${mysqlInstallDir}
datadir = ${mysqlDataDir}
pid-file = ${mysqlDataDir}/mysql.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1

init-connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4

skip-name-resolve
#skip-networking
back_log = 300

max_connections = 3278
max_connect_errors = 6000
open_files_limit = 65535
table_open_cache = 1024
max_allowed_packet = 500M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 128M

read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
key_buffer_size = 256M

thread_cache_size = 64

query_cache_type = 1
query_cache_size = 64M
query_cache_limit = 2M

ft_min_word_len = 4

log_bin = mysql-bin
binlog_format = mixed
expire_logs_days = 7

log_error = ${mysqlDataDir}/mysql-error.log
slow_query_log = 1
long_query_time = 1
slow_query_log_file = ${mysqlDataDir}/mysql-slow.log

performance_schema = 0
explicit_defaults_for_timestamp

lower_case_table_names = 1

skip-external-locking

default_storage_engine = InnoDB
#default-storage-engine = MyISAM
innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 1024M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 0
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120

bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 64M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1

interactive_timeout = 28800
wait_timeout = 28800

[mysqldump]
quick
max_allowed_packet = 500M

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
EOF

    # 动态配置my.cnf
    Mem=`free -m | awk '/Mem:/{print $2}'`

    sed -i "s@max_connections.*@max_connections = $((${Mem}/3))@" /etc/my.cnf
    if [ ${Mem} -gt 1500 -a ${Mem} -le 2500 ]; then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 16@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 16M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 128M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 32M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 256@' /etc/my.cnf
    elif [ ${Mem} -gt 2500 -a ${Mem} -le 3500 ]; then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 32@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 32M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 32M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 512M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 64M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 512@' /etc/my.cnf
    elif [ ${Mem} -gt 3500 ]; then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 64@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 64M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 256M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 1024M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 128M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 1024@' /etc/my.cnf
    fi

    ${mysqlInstallDir}/scripts/mysql_install_db --basedir=${mysqlInstallDir} --datadir=${mysqlDataDir} --user=mysql     # 初始化mysql

    /etc/init.d/mysqld start
    [ $? -ne 0 ] && { echo "MySQL start failed, please check again!"; exit 1; }
    echo "MySQL install success!"

    # ${mysqlInstallDir}/bin/mysqladmin -u root password ${mysqlRootPWD}  # 设置root密码
    ${mysqlInstallDir}/bin/mysql -e "grant all privileges on *.* to root@'127.0.0.1' identified by \"${mysqlRootPWD}\" with grant option;"
    ${mysqlInstallDir}/bin/mysql -e "grant all privileges on *.* to root@'localhost' identified by \"${mysqlRootPWD}\" with grant option;"
    ${mysqlInstallDir}/bin/mysql -uroot -p${mysqlRootPWD} -e "delete from mysql.user where Password='' and User not like 'mysql.%';"
    ${mysqlInstallDir}/bin/mysql -uroot -p${mysqlRootPWD} -e "delete from mysql.db where User='';"
    ${mysqlInstallDir}/bin/mysql -uroot -p${mysqlRootPWD} -e "delete from mysql.proxies_priv where Host!='localhost';"
    ${mysqlInstallDir}/bin/mysql -uroot -p${mysqlRootPWD} -e "drop database test;"
    ${mysqlInstallDir}/bin/mysql -uroot -p${mysqlRootPWD} -e "reset master;"
    sleep 1
}

function main(){
    DownloadMySQL
    JemallocInstall
    MysqlInstall
    # 清除目录
    rm -fr ${installTempDir}
    echo "MySQL root password is ${mysqlRootPWD}"
}

main