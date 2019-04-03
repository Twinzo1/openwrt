--[[
 静态ARP绑定 Luci页面 CBI page
 Copyright (C) 2015 GuoGuo <gch981213@gmail.com>
]]--

local ipc = require "luci.ip"
local sys = require "luci.sys"
local ifaces = sys.net:devices()

m = Map("arpbind", translate("IP/MAC Binding"),
        translatef("ARP is used to convert a network address (e.g. an IPv4 address) to a physical address such as a MAC address.Here you can add some static ARP binding rules."))

s = m:section(TypedSection, "arpbind", translate("Rules"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

a = s:option(Value, "ipaddr", translate("IP Address"))
a.datatype = "ipaddr"
a.optional = false
sys.net.host_hints(function(mac, v4, v6, name)
	v6 = v6 and ipc.IPv6(v6)

	if v4 or (v6 and not v6:is6linklocal()) then
		a:value(tostring(v4 or v6), "%s (%s)" %{ tostring(v4 or v6), name or mac })
	end
end)


a = s:option(Value, "macaddr", translate("MAC Address"))
a.datatype = "macaddr"
a.optional = false
luci.sys.net.mac_hints(function(mac, name)
	 a:value(mac, "%s (%s)" %{ mac, name })
end)


a = s:option(ListValue, "ifname", translate("Interface"))
for _, iface in ipairs(ifaces) do
	if iface ~= "lo" then 
		a:value(iface) 
	end
end
a.default = "br-lan"
a.rmempty = false

return m
