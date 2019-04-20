#!/bin/sh
#Cpyright by Twizo<1282055288@qq.com>

find(){  
	echo `logread | grep uhttpd | grep from | tail -1 | tr " " "\n" | tail -1`
}
#Ñ°ÕÒ·¢³öÇëÇóµÄIP

get_mac(){
	local mac=$("find")
	 echo `cat /proc/net/arp | grep "192.168.1.230" | sed 's/[ ]*[ ]/ /g' | tr " " "\n" | head -4 | tail -1`
}

copy(){
	local copym=$("get_mac")
	uci set mac.@mac[0].macaddr="$copym"
	uci commit
}

copy
