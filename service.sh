#!/bin/bash
#Set PATH

resName="wyx176"
serviceFile=/etc/opt/ss5/service.sh
newVersionMsg=`curl -s -L  https://raw.githubusercontent.com/${resName}/Socks5/master/update.txt`

echo ""
echo "1.启动"
echo "2.停止"
echo "3.重启"
echo "4.状态"
echo "5.更新"
echo "6.卸载"
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
