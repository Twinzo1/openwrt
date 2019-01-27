-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local m, s
local fs = require "nixio.fs"
local sys = require "luci.sys"

m = Map("dogcom_log", translate("日志"))

s = m:section(TypedSection, "dogcom_log")
-- 这里的dogcom_log对应config里面的option
s.addremove = false
s.anonymous = true

view_cfg = s:option(TextValue, "1", nil)
	view_cfg.rmempty = false
	view_cfg.rows = 50

	function view_cfg.cfgvalue()
		return nixio.fs.readfile("/tmp/dogcom.log")or ""
	end

return m
