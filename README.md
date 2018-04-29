# Socks5
Socks5代理服务器搭建

本文以Socks5 3.8.9.8为例

1、首先，编译安装SS5需要先安装一些依赖组件

yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel

2、去官网http://ss5.sourceforge.net/ 下载SS5最新版本的源代码

   ss5-3.8.9-8下载地址
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
    
5、在ss5.conf中找到auth和permit两行，按照下面的格式进行修改
#auth       0.0.0.0/0       -         -
#permit  -  0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
把前面的#号去掉就能使用了，ss5 默认使用1080端口，并允许任何人使用

6、如果要修改默认端口，请修改  /etc/sysconfig/ss5

在/etc/sysconfig/ss5这个文件中，添加下面这一行命令，-b后面的参数代表监听的ip地址和端口号(一定要记得配置安全组开放SS5监听的端口)
# Add startup option here
SS5_OPTS=" -u root -b 0.0.0.0:8080"

7、启动ss5
  service ss5 start
  
8、功能指令列表
启动 service ss5 start
停止 service ss5 stop
状态 service ss5 status
重启 service ss5 restart
卸载 service ss5 reload

#######################################
#下面是添加访问权限()
#######################################
a、开启用户名密码验证机制 /etc/opt/ss5/ss5.conf

  在ss5.conf中找到auth和permit两行，按照下面的格式进行修改

  auth       0.0.0.0/0       -         u
  permit  u  0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -

b 、设置用户名和密码 /etc/opt/ss5/ss5.passwd
   一行一个账号，用户名和密码之间用空格间隔，例如：

   user1 123
   user2 234
   
c、重启服务生效

   service ss5 restart
