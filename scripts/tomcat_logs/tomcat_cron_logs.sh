#!/bin/bash

## Author: wuhaomiao                    
## Mail: wuhaomiao@xhd.cn               
## Date: 2022-09-01                
## 网站组tomcat日志分割


TOMCAT_DIR=/usr/local/ProgramData
LOGS_DIR=/usr/local/ProgramData/logs

function moveLogs(){
    logDirName=$(echo $1 | awk -F "/" '{print $5}')
    logDir=$LOGS_DIR/$logDirName
    [ ! -d "$logDir" ] && mkdir -p $logDir
    cd $i/logs  # 进入项目logs目录
    cp -r ./* $logDir/
    echo "" > catalina.out   # 清空catalina.out日志
    rm -f $(ls | grep -v "catalina.out")
    cd $logDir  # 进入日志备份目录
    zip -q ${logDirName}_$(date +%Y-%m-%d).zip $(ls |grep -Ev "*.zip")
    rm -fr $(ls $logDir | grep -Ev "*.zip")
}

function main(){
    for i in $TOMCAT_DIR/tomcat7_*
    do
        if [ -d "$i" ]; then
            moveLogs $i
        fi
    done

    # 删除7天日志
    find $LOGS_DIR  -type f -mtime +7 -name "*.zip" -exec rm -f {} \;
}

main