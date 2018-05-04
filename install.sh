#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

service ss5 stop
rm -rf ss5-3.8.9
rm -rf /etc/opt/ss5
rm -f /usr/local/bin/s5
clear
echo "清理旧环境成功！"
echo ""
echo "安装Socks5所依赖的组件,请稍等..."
yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
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
	
	apt-get install git unzip wget -y
	
fi
if [[ ${OS} == CentOS ]];then
	
	yum install git unzip wget -y
   
fi
if [[ ${OS} == Debian ]];then
	
	apt-get install git unzip wget -y
    
fi
echo ""
echo "下载Socks5服务中..."
#wget https://sourceforge.net/projects/ss5/files/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz

wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/Socks5/master/ss5-3.8.9-8.tar.gz
wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/Socks5/master/ss5.tar.gz



echo ""
echo "解压文件中..."
tar zxvf ./ss5-3.8.9-8.tar.gz

echo ""
rm ss5-3.8.9-8.tar.gz
echo "安装中1..."
cd ss5-3.8.9

ls

echo "安装中2..."
./configure

echo "安装中3..."
make

echo "安装中4..."
make install

cd /root
mv ss5.tar.gz /etc/opt/ss5/
cd /etc/opt/ss5/
tar -xzvf ss5.tar.gz
rm ss5.tar.gz

cd /etc/opt/ss5/
git clone https://github.com/wyx176/Socks5
chmod -R 777 /etc/opt/ss5/Socks5
cd /etc/opt/ss5/Socks5

mv s5 /usr/loacl/bin/
mv service.sh /etc/opt/ss5/
mv user.sh /etc/opt/ss5/
#rm -rf /etc/opt/ss5/Socks5
chmod +x /usr/local/bin/s5

echo "开机启动添加成功"
chmod +x /etc/init.d/ss5
chkconfig --add ss5
chkconfig --level 345 ss5 on

cd /root
rm install.sh

service ss5 start

echo ""
echo "Socks5安装成功！"

echo ""
echo "默认用户名123456"
echo "默认密码654321"
echo "默认端口1080"
echo ""
echo "请按照文档进行配置！"

echo ""

