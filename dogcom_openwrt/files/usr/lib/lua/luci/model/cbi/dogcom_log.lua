-- Copyright (C) 2019 Twinzo1 <1282055288@qq.com>

local fs = require "nixio.fs"
local sys = require "luci.sys"
local m,s,o
m = Map("dogcom", translate("Running Log"))
s = m:section(TypedSection, "dogcom")
s.anonymous=true

dogcom_log.template = "cbi/tvalue"
dogcom_log.rows = 20
dogcom_log.wrap = "off"
function dogcom_log.cfgvalue(self, section)
return fs.readfile("/tmp/dogcom.log") or ""
end

dogcom_log.rmempty = true
