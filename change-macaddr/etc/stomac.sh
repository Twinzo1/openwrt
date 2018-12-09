#!/bin/sh
#Cpyright by Twizo<1282055288@qq.com>

stochastic(){
	echo `dd if=/dev/urandom bs=1 count=32 2>/dev/null | md5sum | cut -b 0-12 | sed 's/\(..\)/\1:/g; s/.$//'`
}

sto(){ 
	local stom=$("stochastic")
	uci set mac.@mac[0].macaddr="$stom"
	uci commit
}

sto