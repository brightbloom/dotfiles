local rt = require("rust-tools")

rt.setup({
	tools = {
		autoSetHints = false,
		cache = true,
	},
	server = {
		cmd = {
			"rustup",
			"run",
			"stable",
			"rust-analyzer",
		},
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					experimental = true,
				},
			},
		},
	},
})
