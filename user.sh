#!/bin/bash
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
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
elif [ ! -z "$(grep 'Arch Linux' /etc/issue)" ];then
    OS=Ubuntu
else
echo "Does not support this OS, Please contact the author! "
kill -9 $$
fi

userfile=/etc/opt/ss5/user.sh
passwdFile=/etc/opt/ss5/ss5.passwd
confFile=/etc/opt/ss5/ss5.conf
portFile=/etc/sysconfig/ss5
unIptablesFile=/etc/opt/ss5/unIptables.sh

Tcp_On(){
	Iptab=""
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $port -j ACCEPT
	echo "iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $port -j ACCEPT" > $unIptablesFile
	if [[ $CentOS_RHEL_version == 7 ]];then
	Iptab=`service iptables save`
		systemctl restart iptables.service
	else
	Iptab=`/etc/init.d/iptables save`
		/etc/init.d/iptables restart
	fi
	
	if [[ $Iptab =~ "OK" ]] ;then
		echo "OK"
	 else
		echo "NO"
	 fi
}

echo ""
echo "*******************************"
cat $confFile | while read line
do
if  [[ $line =~ "permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-" ]] ;then
echo  "@帐号验证：已开启@"
break
fi

if  [[ $line =~ "permit -	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-" ]] ;then
echo "@帐号验证：已关闭@"
break
fi
done
echo "*******************************"
echo "1.查看用户"
echo "2.添加用户"
echo "3.删除用户"
echo "4.开启账号验证"
echo "5.关闭账号验证"
echo "6.修改端口"
echo "0.返回"
while :; do echo
	read -p "请选择： " choice
	if [[ ! $choice =~ ^[0-6]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done
if [[ $choice == 0 ]];then
s5
fi

if [[ $choice == 1 ]];then
clear
echo "用户名	密码"
cat $passwdFile | while read line
do
echo "$line" #输出整行内容
#echo "$line" | awk '{print $1}' #输出每行第一个字
done
bash $userfile
fi

if [[ $choice == 2 ]];then
clear
cd /etc/opt/ss5

read -p "输入用户名： " uname
echo ""
read -p "输入密码： " upasswd
echo ""
echo -e $uname $upasswd >> ss5.passwd
echo "*添加用户成功*"
bash $userfile
fi

if [[ $choice == 3 ]];then
clear
read -p "输入用户名：" uname
echo ""
sed -i -e "/$uname/d" $passwdFile
echo "      执行成功,重启s5后生效"
bash $userfile
fi
if [[ $choice == 4 ]];then
clear
sed -i '87c auth    0.0.0.0/0               -               u' $confFile
sed -i '203c permit u	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile
echo ""
var=`service ss5 restart`
if [[ $var =~ "OK" ]] ;then
 echo "开启账户验证成功"
 else
 echo "设置失败,请重试"
 fi
bash $userfile
fi

if [[ $choice == 5 ]];then
clear
sed -i '87c auth    0.0.0.0/0               -               -' $confFile
sed -i '203c permit -	0.0.0.0/0	-	0.0.0.0/0	-	-	-	-	-' $confFile
echo ""
var=`service ss5 restart`
if [[ $var =~ "OK" ]] ;then
 echo "账户验证关闭成功！"
 else
 echo "设置失败,请重试"
 fi
bash $userfile
fi

if [[ $choice == 6 ]];then
clear
read -p "请输入新端口：" port
sed -i '2c SS5_OPTS="-u root -b 0.0.0.0:' $portFile
sed -i "/0.0.0:/ s/$/$port\"/" $portFile
isIptab=$(Tcp_On)
echo ""
var=`service ss5 restart`
if [[ $var =~ "OK" ]] && [[ $isIptab =~ "OK" ]]  ;then
	echo "端口修改成功"
 else
	echo "设置失败,请重试"
 fi
	bash $userfile
fi

