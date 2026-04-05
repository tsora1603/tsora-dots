require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

require("folder-rules"):setup()

require("projects"):setup({
    event = {
        save = {
            enable = true,
            name = "project-saved",
        },
        load = {
            enable = true,
            name = "project-loaded",
        },
        delete = {
            enable = true,
            name = "project-deleted",
        },
        delete_all = {
            enable = true,
            name = "project-deleted-all",
        },
        merge = {
            enable = true,
            name = "project-merged",
        },
    },
    save = {
        method = "yazi", -- yazi | lua
        yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
                            -- default value:
                            -- windows: "%APPDATA%/yazi/state/projects.json"
                            -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        update_before_quit = false,
        load_after_start = false,
    },
    merge = {
        event = "projects-merge",
        quit_after_merge = false,
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

require("bunny"):setup({
  hops = {
    { key = "/",          path = "/",                                    },
    { key = "t",          path = "/tmp",                                 },
    { key = "h",          path = "~",              desc = "Home"         },
    { key = "m",          path = "~/Music",        desc = "Music"        },
    { key = "g",          path = "~/Games",        desc = "Games"        },
    { key = "d",          path = "~/Documents",    desc = "Documents"    },
    { key = { "c", "c" }, path = "~/.config",      desc = "Config files" },
    { key = { "c", "h" }, path = "~/.config/hypr", desc = "Hypr config"  },
    { key = { "c", "y" }, path = "~/.config/yazi", desc = "Yazi config"  },
    { key = { "c", "n" }, path = "~/.config/noctalia", desc = "Noctalia config" },
    { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
    { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
    { key = { "l", "t" }, path = "~/.local/state", desc = "Local state"  },
    { key = { "u", "s" }, path = "/usr/share",     desc = "/usr/share"   },
    { key = { "u", "a" }, path = "/usr/share/applications", desc = "/usr/share/applications" },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

require("recycle-bin"):setup()

require("simple-status"):setup()

require("full-border"):setup()
