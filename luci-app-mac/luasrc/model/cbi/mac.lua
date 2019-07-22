-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Cpyright by Twizo<1282055288@qq.com>
-- Licensed to the public under the Apache License 2.0.

local m, s, o
local fs = require "nixio.fs"
local sys = require "luci.sys"

m = Map("mac", translate("Mac地址"),
	translate("克隆Wan口地址")
	..[[<br /><strong>]]
	..[[<a href="https://github.com/Twinzo1/openwrt/tree/master/luci-app-mac" target="_blank">]]
	..translate("项目地址")
	..[[</a>]]
	..[[</strong><br />]])

s = m:section(TypedSection, "mac")
-- 这里对应config里面的option
s.addremove = false
s.anonymous = true

os = s:option(Value,"mac",translate(""))
os.template ="mac"

enable=s:option(Flag,"enable",translate("定时修改Mac"))
enable.rmempty = false
enable.default=0

week=s:option(ListValue,"week",translate("周/天"))
week:value(0,translate("每天"))
week:value(1,translate("周一"))
week:value(2,translate("周二"))
week:value(3,translate("周三"))
week:value(4,translate("周四"))
week:value(5,translate("周五"))
week:value(6,translate("周六"))
week:value(7,translate("周日"))
week.default=0
week:depends({enable="1"})

hour=s:option(Value,"hour",translate("小时"))
hour.datatype = "range(0,23)"
hour.default=0
hour:depends({enable="1"})

pass=s:option(Value,"minute",translate("分钟"))
pass.datatype = "range(0,59)"
pass.default=0
pass:depends({enable="1"})

os = s:option(Value,"macc")
os.datatype="macaddr"
os:depends({enable="4"})

local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/mac start")
end


return m
