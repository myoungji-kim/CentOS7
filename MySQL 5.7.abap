1. wget 설치
[root@localhost ~]# yum install wget

2. util 폴더 및 mysql 폴더 생성
[root@localhost ~]# mkdir util
[root@localhost ~]# cd util
[root@localhost util]# mkdir mysql
[root@localhost util]# cd mysql

3. mysql 설치
[root@localhost mysql]# wget http://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.20.tar.gz
[root@localhost mysql]# tar xvfz mysql-5.7.20.tar.gz

4. MySQL 컴파일 설치를 위한 라이브러리 설치
[root@localhost mysql]$ wget http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
[root@localhost mysql]$ tar xvfz boost_1_59_0.tar.gz

5. 컴파일 설치를 위한 패키지 설치
[root@localhost mysql]$ sudo yum install cmake ncurses ncurses-devel
* sudo는 root가 아닌 사용자가 root에 준하는 능력으로 sudo 다음에 나오는 명령을 실행하게 하는 명령어

6. 컴파일 설치를 후 my.cnf파일을 수정
[root@localhost ~]# yum install gcc-c++
* install 안 할 경우 아래와 같은 에러 발생
* ERROR: "CMAKE_CXX_COMPILER-NOTFOUND" was not found => 구성 요소의 부재

[root@localhost mysql-5.7.20]$ cmake \
-DCMAKE_INSTALL_PREFIX=/home/root/util/mysql \
-DWITH_EXTRA_CHARSETS=all \
-DMYSQL_DATADIR=/home/root/util/mysql/mysql_data \
-DENABLED_LOCAL_INFILE=1 \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=../boost_1_59_0 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DSYSCONFDIR=/etc \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all 

[root@localhost mysql-5.7.20]$ make && make install
[root@localhost mysql-5.7.20]$ make clean

7. my.cnf 파일 수정
[root@localhost mysql-5.7.20]$ sudo vi /etc/my.cnf

* ===== Before =====
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
* =====================

* ===== After =====
[client]
default-character-set = utf8
port = 3306
socket = /tmp/mysql.sock
default-character-set = utf8
 
 
[mysqld]
socket=/tmp/mysql.sock
datadir=/home/root/util/mysql/mysql_data
basedir = /home/root/util/mysql
user = root
bind-address = 0.0.0.0
skip-external-locking
key_buffer_size = 384M
max_allowed_packet = 1M
table_open_cache = 512
sort_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 64M
thread_cache_size = 8
query_cache_size = 32M
 
skip-name-resolve
 
max_connections = 1000
max_connect_errors = 1000
wait_timeout= 60
 
explicit_defaults_for_timestamp
 
symbolic-links=0
 
log-error=/home/root/util/mysql/mysql_data/mysqld.log
pid-file=/tmp/mysqld.pid
 
character-set-client-handshake=FALSE
init_connect = SET collation_connection = utf8_general_ci
init_connect = SET NAMES utf8
character-set-server = utf8
collation-server = utf8_general_ci
 
symbolic-links=0
 
default-storage-engine = myisam
key_buffer_size = 32M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
* =====================

8. mysql 설치
[root@localhost etc]$ cd /home/root/util/mysql/bin
[root@localhost bin]$ ./mysql_install_db --user=root --datadir=/home/root/util/mysql/mysql_data

* 에러 메시지 (무시해도 됨)
[WARNING] mysql_install_db is deprecated. Please consider switching to mysqld --initialize

9. 설치 되었는지 확인
[root@localhost ~] ls -l /home/root/util/mysql/mysql_data

10. mysql 실행을 위한 설정 후, mysql 실행
[root@localhost bin]$ cd /home/root/util/mysql/support-files
[root@localhost support-files]$ sudo cp mysql.server /usr/bin
[root@localhost support-files]$ mysql.server start
Starting MySQL. SUCCESS!

11. mysql 명령 복사
[root@localhost support-files]$ cd /home/root/util/mysql/bin
[root@localhost bin]$ sudo cp mysql /usr/bin

12. mysql 시작 및 비밀번호 설정
[root@localhost bin]$ ./mysql_secure_installation
mysql_secure_installation: [ERROR] unknown variable 'default-character-set=utf8'
 
Securing the MySQL server deployment.
 
Connecting to MySQL server using password in '/home/root/.mysql_secret'
 
VALIDATE PASSWORD PLUGIN can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD plugin?
 
Press y|Y for Yes, any other key for No: yes
 
There are three levels of password validation policy:
 
LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file
 
Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 1
Using existing password for root.
 
Estimated strength of the password: 100
Change the password for root ? ((Press y|Y for Yes, any other key for No) : yes
 
New password: (비밀번호)
 
Re-enter new password: (비밀번호)
 
Estimated strength of the password: 100
Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : yes
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.
 
Remove anonymous users? (Press y|Y for Yes, any other key for No) : yes
Success.
 
 
Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.
 
Disallow root login remotely? (Press y|Y for Yes, any other key for No) : yes
Success.
 
By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.
 
 
Remove test database and access to it? (Press y|Y for Yes, any other key for No) : yes
 - Dropping test database...
Success.
 
 - Removing privileges on test database...
Success.
 
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.
 
Reload privilege tables now? (Press y|Y for Yes, any other key for No) : yes
Success.

All done!

13. mysql 접속
[root@localhost ~]$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.20
 
Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.
 
Oracle is a registered trademark of Oracle Corporation and/or itsㅡㅛ
affiliates. Other names may be trademarks of their respective
owners.
 
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

14. db 확인하기 (초기에 비밀번호 세팅 필요)
mysql> show databases;
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
mysql> SET PASSWORD = PASSWORD('MT990412mt!');
Query OK, 0 rows affected, 1 warning (0.01 sec)
 
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

15. 종료하기
mysql > exit
Bye
