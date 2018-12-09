module("luci.controller.mac", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/config/mac") then
		return
	end

	local page

	page = entry({"admin", "services", "mac"}, cbi("mac"), _("MAC地址"), 45)
	page.i18n = "修改mac地址"
	page.dependent = true
end
