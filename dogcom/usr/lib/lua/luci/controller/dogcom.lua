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

	page = entry({"admin", "services", "dogcom"}, cbi("dogcom"), _("DROCM客户端"), 45)
	page.i18n = "DROCM客户端"
	page.dependent = true
end
