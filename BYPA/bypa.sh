#!/bin/sh
# 定时命令
# */1 * * * * /usr/bin/bypa.sh check
LOGFILE="/tmp/log/bypa.log"
# 获取旁路由mac地址，必填
# BYP_MAC=`uci get byp.@bpy[0].macaddr 2>/dev/null`
BYP_MAC=""

# 获取旁路由ipv4地址
# BYP_IP4=`uci get byp.@bpy[0].ipaddr 2>/dev/null`
BYP_IP4=""
[ -z $BYP_IP4 ] && BYP_IP4=`cat /proc/net/arp | grep -i "$BYP_MAC" | awk -F " " '{print $1}' 2>/dev/null`

# 获取旁路由ipv6地址
BYP_IP6=`ip -6 neighbor show | grep -i "$BYP_IP4" | sed -n '1p' | awk -F " " '{print $1}' 2>/dev/null`

# 添加dhcp_option
add_dhcp()
{
  uci add_list dhcp.lan.dhcp_option= "3,$BYP_IP4"
  uci add_list dhcp.lan.dhcp_option= "6,$BYP_IP4"
  uci add_list dhcp.lan.dns="$BYP_IP6"
  uci commit dhcp
  /etc/init.d/network restart
}

# 删除dhcp_option
del_dhcp()
{
  uci del_list dhcp.lan.dhcp_option= "3,$BYP_IP4" 2>/dev/null
  uci del_list dhcp.lan.dhcp_option= "6,$BYP_IP4" 2>/dev/null
  uci del_list dhcp.lan.dns="$BYP_IP6"
  uci commit dhcp
  /etc/init.d/network restart
}
# 检测旁路由是否上线
byp_online()
{
	tries=0
	while [[ $tries -lt 3 ]]
	do
        	if /bin/ping -c 1 $BYP_IP4 >/dev/null
        	then
                	al_online=`uci show | grep $BYP_IP4`
            		[ -n "$al_online" ] || { add_dhcp && echo "旁路由上线，开始调整dhcp选项" >>  $LOG_FILE}
                exit 0
     		fi
        	tries=$((tries+1))
	done
	echo "旁路由下线，开始调整dhcp选项" >>  $LOG_FILE
  	del_dhcp
}

[ "$1" = "check" ] && byp_online || echo "参数错误" >>  $LOG_FILE
