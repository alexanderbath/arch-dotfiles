require("config.lazy")

-- Colourscheme
vim.cmd.colorscheme "catppuccin"

-- Spellcheck for markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "setlocal spell",
})
vim.o.spelllang = "en_gb"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- Line Wrap
vim.o.linebreak = true

-- Colour column
vim.opt.colorcolumn = "79"

-- Tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Fast Move
vim.keymap.set('n', 'H', '8h')
vim.keymap.set('n', 'L', '8l')
vim.keymap.set('n', 'J', '8j')
vim.keymap.set('n', 'K', '8k')

-- Obsidian bindings
vim.keymap.set('n', '<leader>n', ':ObsidianNew<cr>')
vim.keymap.set('n', '<leader>d', ':ObsidianToday<cr>')
vim.keymap.set('n', '<leader>ld', ':ObsidianDailies<cr>')

-- Syntax highlighting inside markdown code blocks.
vim.g.markdown_fenced_languages = {'html', 'css', 'python', 'c', 'go', 'sql'}

-- Splits
vim.keymap.set('n', '<leader>v', ':vsplit<cr>')

-- Telescope bindings.
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { 
      "node_modules" 
    }
  }
}

-- Lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Completion
local cmp = require('cmp')
cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
	vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

	-- For `mini.snippets` users:
	-- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
	-- insert({ body = args.body }) -- Insert at cursor
	-- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
	-- require("cmp.config").set_onetime({ sources = {} })
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'buffer' },
})
})

-- LSP Servers
require("mason").setup()
require("mason-lspconfig").setup()

-- Obsidian config
vim.wo.conceallevel = 2
require('obsidian').setup {
	workspaces = {
		{
			name="second-brain",
			path="~/Vault/second-brain",
		}
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},

	daily_notes = {
		folder = 'dailies',
		date_format = '%d-%m-%Y'
	},

	-- Optional, configure key mappings. These are the defaults. If you don't want to set any keymapings this
  	-- way then set 'mappings = {}'.
  	mappings = {
    		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    		["gf"] = {
      			action = function()
        		return require("obsidian").util.gf_passthrough()
      			end,
      			opts = { noremap = false, expr = true, buffer = true },
    		},
    		-- Toggle check-boxes.
    		["<leader>ch"] = {
      			action = function()
        		return require("obsidian").util.toggle_checkbox()
      			end,
      			opts = { buffer = true },
    		},
    		-- Smart action depending on context, either follow link or toggle checkbox.
    		["<cr>"] = {
      			action = function()
        		return require("obsidian").util.smart_action()
      			end,
      			opts = { buffer = true, expr = true },
    		}
  	},

	picker = {
    		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
    		name = "telescope.nvim",
    		-- Optional, configure key mappings for the picker. These are the defaults.
    		-- Not all pickers support all mappings.
   		 note_mappings = {
     			 -- Create a new note from your query.
     			 new = "<C-x>",
     			 -- Insert a link to the selected note.
      			insert_link = "<C-l>",
   		 },
	    	tag_mappings = {
	      		-- Add tag(s) to current note.
	      		tag_note = "<C-x>",
	      		-- Insert a tag at the current location.
	      		insert_tag = "<C-l>",
	    	},
	  },

  	-- Optional, sort search results by "path", "modified", "accessed", or "created".
  	-- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
  	-- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
  	sort_by = "modified",
  	sort_reversed = true,

 	-- Set the maximum number of lines to read from notes on disk when performing certain searches.
 	search_max_lines = 1000,

 	-- Optional, determines how certain commands open notes. The valid options are:
 	-- 1. "current" (the default) - to always open in the current window
	-- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
	-- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
	open_notes_in = "current",

	-- Optional, define your own callbacks to further customize behavior.
	callbacks = {
    		-- Runs at the end of `require("obsidian").setup()`.
    		---@param client obsidian.Client
    		post_setup = function(client) end,

    		-- Runs anytime you enter the buffer for a note.
   		 ---@param client obsidian.Client
   		 ---@param note obsidian.Note
   		 enter_note = function(client, note) end,

    		-- Runs anytime you leave the buffer for a note.
   		 ---@param client obsidian.Client
   		 ---@param note obsidian.Note
   		 leave_note = function(client, note) end,

   		 -- Runs right before writing the buffer for a note.
    		---@param client obsidian.Client
    		---@param note obsidian.Note
   		 pre_write_note = function(client, note) end,

    		-- Runs anytime the workspace is set/changed.
   		---@param client obsidian.Client
   		---@param workspace obsidian.Workspace
   		post_set_workspace = function(client, workspace) end,
  	},

  	-- Optional, configure additional syntax highlighting / extmarks.
  	-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
 	 ui = {
   		enable = false,  -- set to false to disable all additional syntax features
    		update_debounce = 200,  -- update delay after a text change (in milliseconds)
    		max_file_length = 5000,  -- disable UI features for files with more than this many lines
    		-- Define how various check-boxes are displayed
    		checkboxes = {
     			-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      			[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      			["x"] = { char = "", hl_group = "ObsidianDone" },
			[">"] = { char = "", hl_group = "ObsidianRightArrow" },
      			["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      			["!"] = { char = "", hl_group = "ObsidianImportant" },
      			-- Replace the above with this if you don't have a patched font:
      			-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
     			-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

     			 -- You can also add more custom ones...
    		},
		-- Use bullet marks for non-checkbox lists.
		bullets = { char = "•", hl_group = "ObsidianBullet" },
		external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		-- Replace the above with this if you don't have a patched font:
		-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		reference_text = { hl_group = "ObsidianRefText" },
		highlight_text = { hl_group = "ObsidianHighlightText" },
		tags = { hl_group = "ObsidianTag" },
		block_ids = { hl_group = "ObsidianBlockID" },
		hl_groups = {
			-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
			ObsidianTodo = { bold = true, fg = "#f78c6c" },
			ObsidianDone = { bold = true, fg = "#89ddff" },
			ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
			ObsidianTilde = { bold = true, fg = "#ff5370" },
			ObsidianImportant = { bold = true, fg = "#d73128" },
			ObsidianBullet = { bold = true, fg = "#89ddff" },
			ObsidianRefText = { underline = true, fg = "#c792ea" },
			ObsidianExtLinkIcon = { fg = "#c792ea" },
			ObsidianTag = { italic = true, fg = "#89ddff" },
			ObsidianBlockID = { italic = true, fg = "#89ddff" },
			ObsidianHighlightText = { bg = "#75662e" },
		},
	},

	---@param url string
    follow_url_func = function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"open", url})  -- Mac OS
            -- vim.fn.jobstart({"xdg-open", url})  -- linux
            -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
            -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,
}
