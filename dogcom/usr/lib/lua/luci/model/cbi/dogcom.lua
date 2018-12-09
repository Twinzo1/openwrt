-- Copyright (C) 2017 fuyumi <280604399@qq.com>
-- Licensed to the public under the GNU Affero General Public License v3.

local m, s
local fs = require "nixio.fs"
local sys = require "luci.sys"

local running = (luci.sys.call("pidof dogcom > /dev/null") == 0)
if running then	

	m = Map("dogcom", translate("DRCOM客户端"), "<b><font color=\"green\">客户端运行中</font></b>")

else
	m = Map("dogcom", translate("DRCOM客户端"), "<b><font color=\"red\">客户端未运行</font></b>")

end

s = m:section(TypedSection, "dogcom")
-- 这里的dogcom对应config里面的option
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("开启客户端"))

enabledial = s:option(Flag, "enabledial", translate("启用PPPoE拨号"))

interface = s:option(ListValue, "interface", translate("Interface"), translate("请选择你的拨号接口. (通常是WAN/wan.)"))
interface:depends("enabledial", "1")

cur = luci.model.uci.cursor()
net = cur:get_all("network")
for k, v in pairs(net) do
	for k1, v1 in pairs(v) do
		if v1 == "interface" then
			interface:value(k)
			if k == "WAN" or k == "wan" then
				interface.default = k
			end
		end
	end
end

username = s:option(Value, "username", translate("Username"))
username:depends("enabledial", "1")

password = s:option(Value, "password", translate("Password"))
password:depends("enabledial", "1")
password.password = true

macaddr = s:option(Value, "macaddr", translate("Mac地址"))
macaddr.datatype="macaddr"
remote_server = s:option(Value, "server", translate("认证服务器地址"))
remote_server.datatype = "ip4addr"

pppoe_flag = s:option(Value, "pppoe_flag", translate("pppoe_flag"))
keep_alive2_flag = s:option(Value, "keep_alive2_flag", translate("keep_alive2_flag"))

local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/dogcom restart")
end

return m