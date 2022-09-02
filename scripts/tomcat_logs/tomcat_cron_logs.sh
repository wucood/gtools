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
    mv $i/logs/* $logDir/
    touch $i/logs/catalina.out
    zip $logDir/$logDirName_$(date +%Y-%m-%d).zip $logDir/* -x "$logDir/*.zip"
    rm $(ls $logDir | grep -v *.zip)
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
    
