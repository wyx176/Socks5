#!/bin/bash
#Set PATH

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

resName="wyx176"
serviceFile=/etc/opt/ss5/service.sh
unIptablesFile=/etc/opt/ss5/unIptables.sh
newVersionMsg=`curl -s -L  https://raw.githubusercontent.com/${resName}/Socks5/master/update.txt`

echo ""
echo "1.启动"
echo "2.停止"
echo "3.重启"
echo "4.状态"
echo "5.更新"
echo "6.卸载"
echo "7.清理iptables规则"
echo "0.返回"
while :; do echo
	read -p "请选择： " choice
	if [[ ! $choice =~ ^[0-7]$ ]]; then
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
if [ ! -d "/var/run/ss5/" ];then
mkdir /var/run/ss5
fi
service ss5 start
  bash $serviceFile
fi

if [[ $choice == 2 ]];then
	clear
	service ss5 stop
	bash $serviceFile
fi

if [[ $choice == 3 ]];then
	clear
	service ss5 restart
	bash $serviceFile
fi

if [[ $choice == 4 ]];then
	clear
	service ss5 status
	bash $serviceFile
fi


if [[ $choice == 5 ]];then
	clear
	echo "更新到最新版本将丢失所有数据,请提前备份！"
	echo " "
	echo "最新版本："
	echo -e ${newVersionMsg}
	echo " "
	read -p "输入123开始更新,其它则取消： " c
	if [[ "$c" == "123" ]];then
	wget -q -N --no-check-certificate https://raw.githubusercontent.com/${resName}/Socks5/master/install.sh && bash install.sh
	exit 0
	else
		clear
		bash $serviceFile
	fi
fi



if [[ $choice == 6 ]];then
	clear
	echo "你在做什么？你真的这么狠心吗？"
	read -p "输入886开始卸载,其它则取消： " c
	if [[ "$c" == "886" ]];then
	bash $unIptablesFile
	if [[ $CentOS_RHEL_version == 7 ]];then
	Iptab=`service iptables save`
		systemctl restart iptables.service
	else
	Iptab=`/etc/init.d/iptables save`
		/etc/init.d/iptables restart
	fi
	
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
	echo "Socks5服务卸载完毕！"
	exit 0
	else
		bash $serviceFile
	fi
fi

if [[ $choice == 7 ]];then
	clear
	echo "更换端口会产生新的iptables规则,不需要可手动删除,影响不大"
	echo 
	read -p "输入123开始开始清理,其它则取消： " c
	if [[ "$c" == "123" ]];then
	bash $unIptablesFile
		if [[ $CentOS_RHEL_version == 7 ]];then
	Iptab=`service iptables save`
		systemctl restart iptables.service
	else
	Iptab=`/etc/init.d/iptables save`
		/etc/init.d/iptables restart
	fi
	
	if [[ $Iptab =~ "OK" ]] ;then
		echo "" > $unIptablesFile
		echo "清理成功,如果S5无网络,请重新修改端口！"
	 else
		echo "清理失败,请稍候重试！"
	 fi
	fi
	bash $serviceFile
fi
