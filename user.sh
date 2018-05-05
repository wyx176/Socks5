#!/bin/bash
#Set PATH
echo ""
echo "Socks5默认开启账户验证"
echo "关闭账户验证后帐号密码将失效"
echo ""
echo "1.查看用户"
echo "2.添加用户"
echo "3.删除用户"
echo "4.开启账户验证"
echo "5.关闭账户验证"
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
echo ""
echo "用户名	密码"
myFile=/etc/opt/ss5/ss5.passwd
cat $myFile | while read line
do
echo "$line" #输出整行内容
#echo "$line" | awk '{print $1}' #输出每行第一个字
done
echo ""
echo ""
bash /etc/opt/ss5/user.sh
fi

if [[ $choice == 2 ]];then
echo ""
cd /etc/opt/ss5

read -p "输入用户名： " uname
echo ""
read -p "输入密码： " upasswd
echo ""
echo -e $uname $upasswd >> ss5.passwd
echo "*添加用户成功*"
echo  ""
bash /etc/opt/ss5/user.sh
fi

if [[ $choice == 4 ]];then
cd /etc/opt/ss5/
tar -xzvf uss5.tar.gz
echo "开启账户验证成功"
echo ""
bash /etc/opt/ss5/user.sh
fi

if [[ $choice == 5 ]];then
cd /etc/opt/ss5/

if [ ! -f "unss5.conf" ];then
echo "当前未开启账户验证！"
echo ""
bash /etc/opt/ss5/user.sh
else
mv -f unss5.conf ss5.conf
echo "账户验证关闭成功！"
echo ""
bash /etc/opt/ss5/user.sh
fi

fi

