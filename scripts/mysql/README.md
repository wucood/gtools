### MySQL安装





#### 配置文件说明

prompt命令可以在mysql提示符中显示当前用户、数据库、时间等信息

```
# 登录的时候设置
mysql -uroot -p --prompt="\u@\h:\d \r:\m:\s>" 

# 配置文件中设置
[mysql] 
prompt=mysql(\u@\h:\d)> 
default-character-set=utf8 
\u:连接用户
\h:连接主机
\d:连接数据库
\r:\m:\s:显示当前时间
```

General_log会记录所有到达Mysql的日志，包括select，日志量大，一般不开启。

```
general_log = ON
general_log_file = /usr/local/mysql/logs/mysql.log
```



配置文件说明

```
[client]
port = 3306
socket = /data/mysql/mysql.sock

[mysql]
prompt="MySQL [\d]> "	# 显示database名
no-auto-rehash				# 命令自动补全

[mysqld]
port = 3306
socket = /data/mysql/mysql.sock

basedir = /usr/local/mysql
datadir = /data/mysql
pid-file = /data/mysql/mysql.pid	
user = mysql
bind-address = 0.0.0.0
server-id = 1

init-connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4

skip-name-resolve	# 参数的目的是再也不进行反解析（ip不反解成域名），这样能够加快数据库的反应时间。
#skip-networking
back_log = 300		# 要求 MySQL 能有的连接数量

max_connections = 3278	
max_connect_errors = 6000	# 最大连接请求错误次数
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
expire_logs_days = 7	# 保留binlog日志7天

log_error = /data/mysql/mysql-error.log
slow_query_log = 1		# 开启慢查询
long_query_time = 3		# 超过3秒写入慢查询日志
slow_query_log_file = /data/mysql/mysql-slow.log

performance_schema = 0	# mysql性能监测
explicit_defaults_for_timestamp

#lower_case_table_names = 1 # 表名存储在磁盘是小写的，但是比较的时候是不区分大小写

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
```



#### 配置文件

```
[client]
port = 3306
socket = /data/mysql/mysql.sock

[mysql]
prompt="MySQL [\d]> "
no-auto-rehash

[mysqld]
port = 3306
socket = /data/mysql/mysql.sock

basedir = /usr/local/mysql
datadir = /data/mysql
pid-file = /data/mysql/mysql.pid
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

log_error = /data/mysql/mysql-error.log
slow_query_log = 1
long_query_time = 1
slow_query_log_file = /data/mysql/mysql-slow.log

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
```

