#!/bin/bash
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

systemctl restart iptables.service >/dev/null
/etc/init.d/iptables restart >/dev/null