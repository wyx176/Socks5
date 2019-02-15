#!/bin/bash
#Set PATH
serviceFile=/etc/opt/ss5/service.sh
echo ""
echo "1.启动"
echo "2.停止"
echo "3.重启"
echo "4.状态"
echo "5.卸载"
echo "0.返回"
while :; do echo
	read -p "请选择： " choice
	if [[ ! $choice =~ ^[0-5]$ ]]; then
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
