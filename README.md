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
- 添加账户，删除用户，开启账户验证，关闭账户验证，一键修改端口
- 支持傻瓜式用户添加,小白也可以用
- 自动修改防火墙规则
- 输入 s5 即可启动控制面板

## 一键安装或更新到最新 ##
 <pre><code>wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/Socks5/master/install.sh && bash install.sh</code></pre>



## 相关文件路径 ##
- 1.端口文件<br>
 /etc/sysconfig/ss5<br>
- 2.访问授权配置文件<br>
 /etc/opt/ss5/ss5.conf<br>
- 3.用户账号信息文件<br>
 /etc/opt/ss5/ss5.passwd<br>
- 4.部分文件修改后需要重启ss5<br>
 重启命令:service ss5 restart<br>

## 写在最后 ##
如果发现版本bug，请及时发E-mail：wyx176@gmail.com，本人会尽快修复!<br>
Telegram交流群:https://t.me/Socks55555
