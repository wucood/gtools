### Shell脚本记录

> 记录shell脚本的一些出错。

#### 1. 判断字符串不为空

```
[ ! -z "$(cat /var/spool/cron/root|grep -Ev '^#'|grep $FILE_NAME)" ] && { echo 'Tomcat crontab for logs Installed allready!'; exit 1; }
```

- `"$( command )"`在使用判断时，一定要加引号：`[ ! -z "$(cat /var/spool/cron/root|grep -Ev '^#'|grep $FILE_NAME)" ]`

- `grep -E`支持使用正则。`grep -v`排除指定内容。

#### 2. 变量加`{}`

```
[ -e "$SHELL_DIR/$FILE_NAME" ] && mv $SHELL_DIR/$FILE_NAME $SHELL_DIR/${FILE_NAME}_bak
```

上面shell中，`${FILE_NAME}_bak`，如果不加`{}`，即为: `$FILE_NAME_bak`，这是另外一个变量了，需要注意。

#### 3. wget不显示输出

```
wget -q -O $SHELL_DIR/$FILE_NAME https://raw.githubusercontent.com/wucood/gtools/main/scripts/tomcat_logs/tomcat_cron_logs.sh --no-check-certificate
```

`-q`不显示输出。`-O`保存至指定目录文件。`--no-check-certificate`取消ssl认证，似乎没用。

#### 4. 判断上个命令执行是否成功

```
if [ $(echo $?) -ne 0 ];then
    echo "Download crontab shell script Failed, Please try again!"
    exit 1
else
    echo "0 0 * * * bash /server/scripts/crontab/$FILE_NAME > /dev/null 2>&1" >> /var/spool/cron/root
    echo "tomcat crontab logs Installed success"
fi
```

#### 5. 函数传参

函数可以直接传参，`$1`为接收到的第1个参数。

