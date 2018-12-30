local fs = require "nixio.fs"
local sys = require "luci.sys"
local macaddr

m = Map("mac", translate("修改WAN口MAC地址"),translate(" ")..
"<br />"
..[[<br /><strong>]]
..[[<a href="https://github.com/Twinzo1/openwrt/tree/master/change-macaddr" target="_blank">]]
..translate("本项目在GitHub的项目地址")
..[[</a>]]
..[[</strong><br />]])
s = m:section(TypedSection, "mac")
s.anonymous = false
s.anonymous = true

macaddr = s:option(Value, "macaddr", translate("MAC地址"),translate("一般格式为ad:fd:cc:55:a9:99"))
macaddr.datatype="macaddr"

local ipaddr
ipaddr = s:option(Value, "ipaddr", translate("本机IP地址"),translate("选择与下方相同的IP地址，方可克隆本机MAC地址"))
ipaddr.datatype="ipaddr"
ipaddr.optional = false
luci.sys.net.ipv4_hints(function(e,t)
ipaddr:value(e,"%s (%s)"%{e,t})
end)

ipaddr = s:option(Value, "ipaddr", translate("         "))
ipaddr.template="mac"

stoma = s:option (Button, "stoma", translate("保存IP设置"),translate("手机不会显示IP地址"))
stoma.inputtitle = translate ( "点击保存")
stoma.inputstyle = "apply"
stoma.write = function (self, section, value)
end

localmac = s:option (Button, "localmac", translate("获取当前WAN口MAC地址"))
localmac.inputtitle =translate ( "点击获取")
localmac.inputstyle = "apply" 
localmac.write = function (self, section, value)
	local localmacc = sys.exec("uci get network.wan.macaddr")
    	sys.exec("uci set mac.@mac[0].macaddr=%s" % localmacc)
	sys.call("uci commit mac")
end

stomac = s:option (Button, "stomac", translate("随机生成WAN口MAC地址"))
stomac.inputtitle = translate ( "点击生成")
stomac.inputstyle = "apply"
stomac.write =function(self, section, value)
	luci.sys.call ( "/etc/stomac.sh > /dev/null")
end

copymac = s:option (Button, "copymac", translate("克隆WAN口MAC地址"),translate("如需克隆手机MAC地址，需正确选择手机IP地址"))
copymac.inputtitle = translate ( "点击克隆")
copymac.inputstyle = "apply"
function copymac.write (self, section, value)
	sys.call("uci commit mac")
	sys.call("/etc/copymac.sh > /dev/null")
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/mac restart")
end

return m
