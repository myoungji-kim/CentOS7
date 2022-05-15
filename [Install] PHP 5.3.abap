1. php 설치를 위한 패키지 설치
[root@localhost ~]# yum install -y wget perl patch pcre-devel lua-devel libxml2-devel ncurses-devel zlib zlib-devel curl openssl openssl-devel libtermcap-devel libc-client-devel bison gcc g++ cpp gcc-c++ freetype freetype-devel freetype-utils gd gd-devel libjpeg libjpeg-devel libpng libpng-devel curl curl-devel flex php-mbstring libexif-devel libmcrypt libmcrypt-devel


2. 컴파일 설치를 위한 libgd
* https://bitbucket.org/libgd/gd-libgd/downloads
[root@localhost ~]# cd /home/root/util/php *폴더생성 미리 해둠
[root@localhost php]# wget https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.1.tar.gz
[root@localhost php]# tar -zxvf libgd-2.1.1.tar.gz
* libgd = 동적이미지 생성 ANSI C라이브러리로서 PNG, JPEG, GIF등의 포맷으로된 이미지를 생성할 수 있는 툴

[root@localhost php]# cd libgd-2.1.1
[root@localhost libgd-2.1.1]# ./configure --prefix=/home --with-xpm=/home
[root@localhost libgd-2.1.1]# make && make install

3. PHP 다운로드
[root@localhost php]# wget https://www.php.net/distributions/php-5.3.27.tar.gz
[root@localhost php]# tar xvfpz php-5.3.27.tar.gz
[root@localhost php]# cd php-5.3.27

4. ./configure
[root@localhost php-5.3.27]# yum install httpd-devel
[root@localhost php-5.3.27]# vi /home/root/util/apache/bin/apxs
* == Before == (초기 설정 삭제)
!/replace/with/path/to/perl/interpreter -w 
* ============
* == After == (perl 실행 경로로 수정)
# !/usr/bin/perl -w 
* ============

[root@localhost php-5.3.27]# ./configure \
--prefix=/home/root/util/php \
--with-libdir=lib64 \
--with-config-file-path=/etc \
--with-apxs2=/home/root/util/apache/bin/apxs \
--with-mysql=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-curl \
--disable-debug \
--enable-safe-mode \
--enable-sockets \
--enable-sysvsem=yes \
--enable-sysvshm=yes \
--enable-ftp \
--enable-magic-quotes \
--with-ttf \
--enable-gd-native-ttf \
--enable-inline-optimization \
--enable-bcmath \
--with-zlib \
--with-gd \
--with-gettext \
--with-jpeg-dir=/home \
--with-png-dir=/home/lib \
--with-freetype-dir=/home \
--with-libxml-dir=/home \
--enable-exif \
--enable-sigchild \
--enable-mbstring \
--with-openssl

[root@localhost php-5.3.27]# make && make install

5. Apache 파일에 php 파일을 인식 시켜주기
[root@localhost ~]# vi /home/root/util/apache/conf/httpd.conf

AddType application/x-httpd-php .htm .html .php .ph php3 .php4 .phtml .inc
AddType application/x-httpd-php-source .phps
* 위에 두줄 중에서 확장자 추가해주기

6. php.ini 파일 복사.
cp /home/root/util/php/php-5.3.27/php.ini-development /home/root/util/apache/conf/php.ini

7. phpMyAdmin 설치
* apache > htdocs > 여기에 압축 풀기 (폴더명 phpMyAdmin으로 변경 (명령어 mv))
[root@localhost htdocs]# wget https://files.phpmyadmin.net/phpMyAdmin/2.11.11.3/phpMyAdmin-2.11.11.3-all-languages.tar.gz
[root@localhost htdocs]# tar xzvf phpMyAdmin-2.11.11.3-all-languages.tar.gz

[root@localhost phpMyAdmin]# cp config.sample.inc.php config.inc.php
[root@localhost phpMyAdmin]# vi config.inc.php
$cfg['Servers'][$i]['host'] = '(localhost or ip주소 or 도메인네임)';

+ apache > conf > httpd.conf에서 index.php 추가되어있는지 확인할 것

8. virtualhost 도메인 추가하고 싶을 경우
[root@localhost phpMyAdmin]# cd /home/root/util/apache/conf/extra
[root@localhost extra]# vi httpd-vhosts.conf
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/home/root/util/apache/htdocs/phpMyAdmin/index.php"
    ServerName myoungji22.com
    ErrorLog "logs/dummy-host2.example.com-error_log"
    CustomLog "logs/dummy-host2.example.com-access_log" common
</VirtualHost>

[root@localhost extra]# systemctl restart apache

* virtualhost 도메인 추가
경로> C:\Windows\System32\drivers\etc
* 관리자 권한으로 메모장 연 후, hosts 열어서 ip주소 및 도메인 네임 추가




