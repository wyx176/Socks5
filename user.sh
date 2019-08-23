#!/bin/bash
#Set PATH
userfile=/etc/opt/ss5/user.sh
passwdFile=/etc/opt/ss5/ss5.passwd
confFile=/etc/opt/ss5/ss5.conf
portFile=/etc/sysconfig/ss5

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
echo ""
var=`service ss5 restart`
if [[ $var =~ "OK" ]] ;then
 echo "端口修改成功"
 else
 echo "设置失败,请重试"
 fi
bash $userfile
fi