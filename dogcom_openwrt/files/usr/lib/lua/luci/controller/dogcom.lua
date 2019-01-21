--[[
# Copyright (c) 2014-2016, latyas <latyas@gmail.com>
# Edit by Twinzo <1282055288@qq.com>
]]--

module("luci.controller.dogcom", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/config/dogcom") then
		return
	end

	local page
	
	entry({"admin", "services", "dogcom"},alias("admin", "services", "dogcom","page1"),_("DROCM Client")).dependent = true
	entry({"admin", "services", "dogcom","page1"}, cbi("dogcom"),_("General Setting"),10).leaf = true
	entry({"admin", "services", "dogcom","page2"}, cbi("dogcom_log"),_("Running Log"),20).leaf = true
	
end
