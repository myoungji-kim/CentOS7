1. gcc 및 관련 캐피지 파일을 설치
[root@localhost ~]# yum update -y
[root@localhost ~]# yum install -y gcc gcc-c++ expat-devel.x86_64 pcre-devel

2. pcre 파일을 다운로드하고 컴파일
[root@localhost ~]# cd /home/root/util/apache
[root@localhost apache]# wget https://sourceforge.net/projects/pcre/files/pcre/8.44/pcre-8.44.tar.gz
[root@localhost apache]# tar zxvf pcre-8.44.tar.gz

[root@localhost apache]# cd pcre-8.44
[root@localhost apache]# ./configure --prefix=/home/root/util/apache
[root@localhost apache]# make && make install

3. httpd.apache.org 사이트에서 apache 2.4, apr, apr-util 파일의 다운로드 링크 주소를 복사 후 apache(httpd), apr, apr-util 파일을 다운로드 및 압축 해제한 후 컴파일
[root@localhost apache]# wget https://downloads.apache.org/httpd/httpd-2.4.53.tar.gz
[root@localhost apache]# wget https://downloads.apache.org/apr/apr-1.7.0.tar.gz
[root@localhost apache]# wget https://downloads.apache.org/apr/apr-util-1.6.1.tar.gz

[root@localhost apache]# tar zxvf httpd-2.4.53.tar.gz
[root@localhost apache]# tar zxvf apr-1.7.0.tar.gz
[root@localhost apache]# tar zxvf apr-util-1.6.1.tar.gz

[root@localhost apache]# mv apr-1.7.0 ./httpd-2.4.53/srclib/apr
[root@localhost apache]# mv apr-util-1.6.1 ./httpd-2.4.53/srclib/apr-util

[root@localhost apache]# cd httpd-2.4.53
[root@localhost httpd-2.4.53]# ./configure \
--prefix=/home/root/util/apache \
--with-included-apr \
--with-pcre=/home/root/util/apache/bin/pcre-config
[root@localhost httpd-2.4.53]# make && make install 

4. httpd.conf 설정 파일에 ServerName을 추가
[root@localhost httpd-2.4.53]# vi /home/root/util/apache/conf/httpd.conf
# ServerName gives the name and port that the server uses to identify itself.
# This can often be determined automatically, but we recommend you specify
# it explicitly to prevent problems during startup.
#
# If your host doesn't have a registered DNS name, enter its IP address here.
#
# ServerName www.example.com:80
ServerName localhost

5. 방화벽(Firewall)이 활성화되어있을 경우 아파치 관련 http, https 트래픽이 차단될 수 있으므로, 방화벽에 서비스 허용하고 재시작
[root@localhost httpd-2.4.53]# firewall-cmd --permanent --add-service=http
[root@localhost httpd-2.4.53]# firewall-cmd --permanent --add-service=https
[root@localhost httpd-2.4.53]# firewall-cmd --reload

6. systemctl 서비스에 아파치 서비스를 등록하고, 부팅 시 아파치가 자동 실행되도록 설정
[root@localhost httpd-2.4.53]# vi /etc/systemd/system/apache.service
[Unit]
Description=Apache Service
[Service]
Type=forking
#EnvironmentFile=/home/root/util/apache/bin/envvars
PIDFile=/home/root/util/apache/logs/httpd.pid
ExecStart=/home/root/util/apache/bin/apachectl start
ExecReload=/home/root/util/apache/bin/apachectl graceful
ExecStop=/home/root/util/apache/bin/apachectl stop
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target

[root@localhost httpd-2.4.53]# systemctl daemon-reload
[root@localhost httpd-2.4.53]# systemctl enable apache
* 연결됨
* Created symlink from /etc/systemd/system/multi-user.target.wants/apache.service to /etc/systemd/system/apache.service
[root@localhost httpd-2.4.53]# systemctl start apache
