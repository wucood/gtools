#!/bin/bash

## Author: wuhaomiao                    
## Mail: wuhaomiao@xhd.cn               
## Date: 2022-09-01                
## 安装网站组tomcat日志分割

# 脚本目录
SHELL_DIR=/server/scripts/crontab
FILE_NAME=tomcat_cron_logs.sh

# 检查是否已安装tomcat日志切割
[ ! -z "$(cat /var/spool/cron/root|grep -Ev '^#'|grep $FILE_NAME)" ] && { echo 'Tomcat crontab for logs Installed allready!'; exit 1; }
# 创建脚本存放目录
[ ! -d "$SHELL_DIR" ] && mkdir -p $SHELL_DIR
# 创建脚本文件
[ -e "$SHELL_DIR/$FILE_NAME" ] && mv $SHELL_DIR/$FILE_NAME $SHELL_DIR/${FILE_NAME}_bak
wget -O $SHELL_DIR/$FILE_NAME https://raw.githubusercontent.com/wucood/gtools/main/scripts/tomcat_logs/tomcat_cron_logs.sh --no-check-certificate

# 添加定时任务
if [ echo $? -ne 0 ];then
    echo "0 0 * * * bash /server/scripts/crontab/$FILE_NAME > /dev/null 2>&1" >> /var/spool/cron/root
    echo "tomcat crontab logs Installed success"
else
    echo "Download crontab shell script Failed, Please try again!"
    exit 1
fi
