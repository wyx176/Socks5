#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

echo ""

echo "安装SS5所依赖的组件,请稍等..."
a=`yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel`
