#SOCKS5代理服务器搭建

本文以Socks5 3.8.9.8为例

Centos 7 64-bit测试通过<br>
  一键安装指令：

  wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/Socks5/master/install.sh && bash install.sh

  #提醒#
  使用一键安装指令后可以直接跳到第8步<br>

  增加管理指令 "s5"<br>
  可方便管理Socks5服务,也可以一键添加用户，至于删除用户，还没有写23333，修改端口也没写(滑稽)，以后添加

  1、首先，编译安装SS5需要先安装一些依赖组件

  yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel

  2、去官网http://ss5.sourceforge.net/ 下载SS5最新版本的源代码
    ss5-3.8.9-8下载地址<br>
  wget https://sourceforge.net/projects/ss5/files/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz

  3、解压后开始编译安装：

  tar zxvf ./ss5-3.8.9-8.tar.gz
　cd ss5-3.8.9
  ./configure
  make
  make install

  4、让SS5随系统一起启动

    chmod +x /etc/init.d/ss5
    chkconfig --add ss5
    chkconfig --level 345 ss5 on
    
  5、在/etc/opt/ss5/ss5.conf中找到auth和permit两行，按照下面的格式进行修改<br>
  #auth       0.0.0.0/0       -         - <br>
  #permit  -  0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -<br>
  把前面的#号去掉就能使用了，ss5 默认使用1080端口，并允许任何人使用

<br>
下面是添加访问权限，使用一键搭建的可以不用管<br>
 <br>
a、开启用户名密码验证机制 /etc/opt/ss5/ss5.conf<br>

    在ss5.conf中找到auth和permit两行，按照下面的格式进行修改
    auth       0.0.0.0/0       -         u
    permit  u  0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -

  b 、设置用户名和密码 /etc/opt/ss5/ss5.passwd
     一行一个账号，用户名和密码之间用空格间隔，例如：<br>

 123456 654321<br>
 user2  234<br>


6、启动ss5<br>
service ss5 start<br>
  
7、功能指令列表<br>
  启动 service ss5 start<br>
  停止 service ss5 stop<br>
  状态 service ss5 status<br>
  重启 service ss5 restart<br>
  卸载 service ss5 reload<br>
  
8、如果要修改默认端口，(暂时需要手动修改)请修改  /etc/sysconfig/ss5

  在/etc/sysconfig/ss5这个文件中，添加下面这一行命令，-b后面的参数代表监听的ip地址和端口号(一定要记得配置安全组开放SS5监听的端口)<br>
S5_OPTS=" -u root -b 0.0.0.0:8080"<br> 

    
  c、重启服务生效<br>
service ss5 restart
<br>
#BUG<br>
如果发现版本bug，请及时发E-mail：wyx176@gmail.com，本人会尽快修复!
