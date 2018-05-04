#!/bin/bash
#Set PATH
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
	service ss5 start
	bash /etc/opt/ss5/service.sh
fi

if [[ $choice == 2 ]];then
	service ss5 stop
	bash /etc/opt/ss5/service.sh
fi

if [[ $choice == 3 ]];then
	service ss5 restart
	bash /etc/opt/ss5/service.sh
fi

if [[ $choice == 4 ]];then
	service ss5 status
	bash /etc/opt/ss5/service.sh
fi

if [[ $choice == 5 ]];then
  echo "确定要卸载Socks5服务吗？"
  echo "输入‘886’开始卸载,其它则取消卸载！"
  read -p "请输入： " T
  if [[ ! $T ==886 ]]; then
	service ss5 stop
	rm -rf ss5-3.8.9
	rm -rf /etc/opt/ss5
	rm -f /usr/local/bin/s5
	clear
	echo "Socks5服务卸载完毕！"
	exit 0
	
	else
	bash /etc/opt/ss5/service.sh
fi
