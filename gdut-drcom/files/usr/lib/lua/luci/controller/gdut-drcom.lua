module("luci.controller.gdut-drcom", package.seeall)

function index()
	entry({"admin", "network", "gdut-drcom"}, cbi("gdut-drcom"), _("广东工业大学客户端"), 100)
	end
