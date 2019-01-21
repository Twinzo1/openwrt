-- Copyright (C) 2019 Twinzo1 <1282055288@qq.com>

local m, s
local fs = require "nixio.fs"
local sys = require "luci.sys"

local running = (luci.sys.call("pidof dogcom > /dev/null") == 0)
if running then	

	m = Map("dogcom", translate("DRCOM Client"), "<b><font color=\"green\">The Client is running</font></b>")

else
	m = Map("dogcom", translate("DRCOM Client"), "<b><font color=\"red\">The Client is not running</font></b>")

end

m = Map("dogcom", translate("DRCOM Client"),translate(" ")..
"<br />"
..[[<br /><strong>]]
..[[<a href="https://github.com/Twinzo1/openwrt/tree/master/dogcom-openwrt" target="_blank">]]
..translate("本项目在GitHub的项目地址")
..[[</a>]]
..[[</strong><br />]])

s = m:section(TypedSection, "dogcom")
-- 这里的dogcom对应config里面的option
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("Start client"))

version=s:option(ListValue,"version",translate("Please choose the Drcom version"))
version:value("P",translate("Version P"))
version:value("D",translate("Version D"))
version.default="P"

enabledial = s:option(Flag, "enabledial", translate("Enable the PPPoE dial"))
enabledial.depends({version="P"})

interface = s:option(ListValue, "interface", translate("Interface"), translate("Please choose the Dial-up interface.(Usually WAN/wan)"))
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

user = s:option(Value, "user", translate("User"),translate("Dial-up in version P with an escape character'r\n' before the account")
user:depends("enabledial", "1")
user.default = "\\r\\n"

pswd = s:option(Value, "pwd", translate("Password"))
pwd:depends("enabledial", "1")
pwd.password = true

macaddr = s:option(Value, "macaddr", translate("Mac address"))
macaddr.depends({version="P"})
macaddr.datatype="macaddr"

remote_server = s:option(Value, "server", translate("Authentication server address"))
remote_server.datatype = "ip4addr"

pppoe_flag = s:option(Value, "pppoe_flag", translate("pppoe_flag"))
pppoe_flag.depends({version="P"})
keep_alive2_flag = s:option(Value, "keep_alive2_flag", translate("keep_alive2_flag"))

username = s:option(Value, "username, translate("User"))
username.depends({version="D"})
username.default = "123"
password = s:option(Value, "password", translate("Password"))
password.depends({version="D"})
password.datatype = "maxlength(16)"
password.password = true
password.default = "123"
host_name = s:option(Value, "host_name", translate("host-name"))
host_name.depends({version="D"})
host_name.datatype = "maxlength(32)"
host_name.default = "HP"
host_os = s:option(Value, "host_os", translate("Host Operating System"))
host_os.depends({version="D"})
host_os.datatype = "maxlength(32)"
host_os.default = "DOS"
host_ip = s:option(Value, "host_ip", translate("Host-IP"))
host_ip.depends({version="D"})
host_ip.datatype = "ip4addr"
host_ip.default = "0.0.0.0"
dhcp_server = s:option(Value, "dhcp_server", translate("DHCP-Server"))
dhcp_server.depends({version="D"})
dhcp_server.datatype = "ip4addr"
dhcp_server.default = "0.0.0.0"
mac = s:option(Value, "mac", translate("Binding the MAC-Address"))
mac.depends({version="D"})
mac.default = "0xaabbccddeeff"
PRIMARY_DNS = s:option(Value, "PRIMARY_DNS", translate("PRIMARY_DNS"))
PRIMARY_DNS.depends({version="D"})
PRIMARY_DNS.default = "114.114.114.114"
AUTH_VERSION = s:option(Value, "AUTH_VERSION", translate("AUTH_VERSION"))
AUTH_VERSION.depends({version="D"})
AUTH_VERSION.default = "\x0a\x00"
KEEP_ALIVE_VERSION = s:option(Value, "KEEP_ALIVE_VERSION", translate("KEEP_ALIVE_VERSION"))
KEEP_ALIVE_VERSION.depends({version="D"})
KEEP_ALIVE_VERSION.default = "\xdc\x02"
CONTROLCHECKSTATUS = s:option(Value, "CONTROLCHECKSTATUS", translate("CONTROLCHECKSTATUS"))
CONTROLCHECKSTATUS.depends({version="D"})
CONTROLCHECKSTATUS.default = "\x20"
ADAPTERNUM = s:option(Value, "ADAPTERNUM", translate("ADAPTERNUM"))
ADAPTERNUM.depends({version="D"})
ADAPTERNUM.default = "\x01"
IPDOG = s:option(Value, "IPDOG", translate("IPDOG"))
IPDOG.depends({version="D"})
IPDOG.default = "\x01"
local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/dogcom restart")
end
return m