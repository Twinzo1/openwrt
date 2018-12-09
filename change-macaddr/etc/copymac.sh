#!/bin/sh
#Cpyright by Twizo<1282055288@qq.com>

find(){  
	echo `uci get mac.@mac[0].ipaddr`
}
#寻找发出请求的IP

get_mac(){
	local mac=$("find")
	echo `cat /proc/net/arp | grep "$mac" | cut -b 42-58`
}

copy(){
	local copym=$("get_mac")
	uci set mac.@mac[0].macaddr="$copym"
	uci commit
}

copy