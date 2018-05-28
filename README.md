# Socks5服务一键搭建脚本
- [x] 稳定版V1.1.2

## 介绍 ##
一个Shell脚本，集成ss5搭建，管理，启动，添加账号等基本操作。是一个基于Socks5官方的辅助脚本。方便用户操作，并且支持快速构建ss5服务环境。

- 请谨慎使用，出问题概不负责！！！！

## 系统支持 ##
* CentOS 6
* CentOS 7

## 功能 ##
 全自动无人值守安装，服务端部署只需一条命令，您和ss5都是如此的优雅：）
- 一键开启、关闭ss5服务
- 添加账户，开启账户验证，关闭账户验证
- 支持傻瓜式用户添加,小白也可以用
- 自动修改防火墙规则
- 输入 s5 即可启动控制面板

## 一键安装或更新到最新 ##
 <pre><code>wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/Socks5/master/install.sh && bash install.sh</code></pre>



## 修改默认端口 ##
 脚本还没有加入一键修改端口功能，如需要修改端口，请按照以下骚操作：)<br>
 搭建完毕后默认端口：5555<br>
- 1.打开如下文件夹中的ss5文件<br>
 /etc/sysconfig/ss5<br>
- 2.打开后能看到如下<br>
 S5_OPTS=" -u root -b 0.0.0.0:5555<br>
- 2.修改端口5555，其它的不要变(一定要记得配置安全组开放SS5监听的端口)<br>
 S5_OPTS=" -u root -b 0.0.0.0:6666<br>
 表示修改端口为6666<br>
- 3.重启ss5服务生效<br>
 service ss5 restart<br>

## 写在最后 ##
如果发现版本bug，请及时发E-mail：wyx176@gmail.com，本人会尽快修复!<br>
Telegram交流群:https://t.me/Socks55555
