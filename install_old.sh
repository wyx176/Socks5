#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi

#Install Basic Tools
if [[ ${OS} == Ubuntu ]];then
	echo ""
	echo "***********************"
	echo "*目前不支持Ubuntu系统！*"
	echo "*请使用CentOS搭建     *"
	echo "**********************"
	exit 0
	apt-get install git unzip wget -y
	
fi
if [[ ${OS} == CentOS ]];then
	
	yum install git unzip wget -y
   
fi
if [[ ${OS} == Debian ]];then
	echo "***********************"
	echo "*目前不支持Debian系统！*"
	echo "*请使用CentOS搭建     *"
	echo "**********************"
	apt-get install git unzip wget -y
    
fi

#1.清理旧环境和配置新环境
Clear(){
service ss5 stop
rm -rf /run/ss5
rm -f 	/run/lock/subsys/ss5
rm -rf /etc/opt/ss5
rm -f /usr/local/bin/s5
rm -rf 	/usr/lib/ss5
rm -f /usr/sbin/ss5
rm -rf /usr/share/doc/ss5
rm -rf /root/ss5-3.8.9
rm -f /etc/sysconfig/ss5
rm -f /etc/rc.d/init.d/ss5
rm -f /etc/pam.d/ss5
rm -rf /var/log/ss5
clear
echo "旧环境清理完毕！"
echo ""
echo "安装Socks5所依赖的组件,请稍等..."
yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
yum update -y nss curl libcurl 

}

#2.下载Socks5服务
Download()
{
echo ""
echo "下载Socks5服务中..."
cd  /root
git clone https://github.com/wyx176/Socks5
}


#3.安装Socks5服务程序
InstallSock5()
{
echo ""
echo "解压文件中..."
cd  /root/Socks5
tar zxvf ./ss5-3.8.9-8.tar.gz

echo "安装中..."
cd /root/Socks5/ss5-3.8.9
./configure
make
make install
}

#4.安装控制面板配置参数
InstallPanel()
{
#cd  /root/Socks5
mv /root/Socks5/service.sh /etc/opt/ss5/
mv /root/Socks5/user.sh /etc/opt/ss5/
mv /root/Socks5/ss5 /etc/sysconfig/
mv /root/Socks5/s5 /usr/local/bin/
chmod +x /usr/local/bin/s5

#设置默认用户名、默认开启帐号验证
uname="123456"
upasswd="654321"
confFile=/etc/opt/ss5/ss5.conf
echo -e $uname $upasswd >> /etc/opt/ss5/ss5.passwd
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile


#添加开机启动
chmod +x /etc/init.d/ss5
chkconfig --add ss5
chkconfig --level 345 ss5 on

#判断ss5文件夹是否存在、
if [ ! -d "/var/run/ss5/" ];then
mkdir /var/run/ss5/
echo "create ss5 success!"
else
echo "/ss5/ is OK!"
fi
}

#5.检测是否安装完整
check(){
cd /root
rm -rf /root/Socks5
rm -rf /root/install.sh
if [ ! -f "/usr/local/bin/s5" ] || [ ! -f "/etc/opt/ss5/service.sh" ]; then
  echo ""
  echo "缺失文件，安装失败！！！"
  echo "发送邮件反馈bug ：wyx176@gmail.com"
  echo "或者添加Telegram群反馈"
  echo "Telegram群：t.me/Socks55555"
  exit 0

else
clear
echo ""
service ss5 start
echo ""
echo "Socks5安装成功！"
echo ""
echo "输入"s5"启动Socks5控制面板"
echo ""
echo "Socks5服务可能不会随系统开机启动"
echo ""
echo "默认用户名: 123456"
echo "默认密码  : 654321"
echo "默认端口  : 5555"
echo ""
echo "添加Telegram群组@Socks55555及时获取更新"
echo ""
fi
}


Clear
Download
InstallSock5
InstallPanel
check
