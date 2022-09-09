#!/bin/bash

## Author: wuhaomiao                    
## Mail: wucood@gmail.com
## Date: 2022-09-01

installTempDir=/usr/src/wucood/src

tengineVersion=2.3.3
tengineDownloadUrl=http://mirrors.linuxeye.com/oneinstack/src/tengine-2.3.3.tar.gz
tengineInstallDir=/usr/local/tengine

opensslVersion=1.1.1q
opensslDownloadUrl=http://mirrors.linuxeye.com/oneinstack/src/openssl-1.1.1q.tar.gz

pcreVersion=8.45
pcreDownloadUrl=http://mirrors.linuxeye.com/oneinstack/src/pcre-8.45.tar.gz


[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }


function TengineDownload(){
    [ ! -d "${installTempDir}" ] && mkdir -p ${installTempDir}
    cd ${installTempDir}

    command -v wget >/dev/null 2>&1
    [ $? -ne 0  ] && yum install wget -y 

    [ ! -e "tengine-${tengineVersion}.tar.gz" ] && wget -q ${tengineDownloadUrl} --no-check-certificate &&
    [ ! -e "openssl-${opensslVersion}.tar.gz" ] && wget -q ${opensslDownloadUrl} --no-check-certificate &&
    [ ! -e "pcre-${pcreVersion}.tar.gz" ] && wget -q ${pcreDownloadUrl} --no-check-certificate
    
    if [ ! -e "tengine-${tengineVersion}.tar.gz" ] || [ ! -e "openssl-${opensslVersion}.tar.gz" ] || [ ! -e "pcre-${pcreVersion}.tar.gz" ];then
        echo "Download failed, please try again!"
        exit 1
    else
        echo "Download success!"
    fi    
}

function TengineInstall(){
    runUser=www
    runGroup=www
    [ -e "${tengineInstallDir}/sbin/nginx" ] && { echo "Tengine allready installed, please check it!"; exit 1; }

    id -g ${runGroup} >/dev/null 2>&1
    [ $? -ne 0 ] && groupadd ${runGroup}
    id -u ${runUser} >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -g ${runGroup} -M -s /sbin/nologin ${runUser}

    tar xzf pcre-${pcreVersion}.tar.gz
    tar xzf tengine-${tengineVersion}.tar.gz
    tar xzf openssl-${opensslVersion}.tar.gz

    [ ! -d "${tengineInstallDir}" ] && mkdir -p ${tengineInstallDir}
    cd tengine-${tengineVersion}

    ./configure --prefix=${tengineInstallDir} --user=${runUser} --group=${runGroup} --with-http_v2_module --with-http_ssl_module --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-http_gzip_static_module --with-http_realip_module --with-http_flv_module --with-http_mp4_module --with-openssl=../openssl-${opensslVersion} --with-pcre=../pcre-${pcreVersion} --with-pcre-jit --with-jemalloc
    make && make install
    if [ $? -ne 0 ];then
        rm -fr ${tengineInstallDir}
        echo "Tengine Install Failed!"
        exit 1
    else
        echo "Tengine Install Success!"    
    fi
}


function main(){
    TengineDownload
    TengineInstall
}

main