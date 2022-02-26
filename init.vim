lua << EOF
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end
EOF

set cursorline
set isfname+=32,;
set isfname-=:
set hidden
colorscheme desert
set ic
set undofile
set ignorecase smartcase
set virtualedit=block

set tabstop=2
set shiftwidth=0
set expandtab
set nofixendofline
set spell
set inccommand=nosplit
set fileformat=unix
"for modifying quickfix list from telescope/vimgrep and reloading it with cgetbuffer
set errorformat=%f\|%l\ col\ %c\|\ %m

lua require('plugins')

lua << EOF
local null_ls = require('null-ls')
null_ls.setup{
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettier
    }
}
require('neoclip').setup{
  enable_persistent_history = true,
  db_path = vim.fn.stdpath("data") .. '\\databases\\neoclip.sqlite3',
}
EOF

lua << EOF
local actions = require('telescope.actions')
local actionSet = require('telescope.actions.set')
require('telescope').setup {
  pickers = {
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      mappings = {
        i = {
          ["<c-s>"] = actions.delete_buffer,
        },
        n = {
          ["<c-s>"] = actions.delete_buffer,
        }
      }
    },
    file_browser = {
      depth = 2,
      hidden = true,
    }
  },
  defaults = {
    mappings = {
      n = {
        [";f"] = actions.close,
      },
    }
  }
}
EOF

lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename(vim.fn.getreg(\'@"\'))<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  --buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  --buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "Qs", "<cmd>'<,'>lua vim.lsp.buf.range_formatting()<CR>", opts)
  buf_set_keymap("n", "Qa", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>dw", "<cmd>Telescope diagnostics<CR>", opts)
  buf_set_keymap("n", "<space>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
  buf_set_keymap("n", "<space>sd", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  buf_set_keymap("n", "<space>sw", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)
end

local pid = vim.fn.getpid()

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable the following language servers
local servers = { 'angularls', 'tsserver' }
for _, lsp in ipairs(servers) do
  if lsp == 'tsserver' then
    local old_on_attach = on_attach
    on_attach = function(client, bufnr)
      old_on_attach(client, bufnr)

      -- disable tsserver formatting
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      local ts_utils = require("nvim-lsp-ts-utils")
      -- defaults
      ts_utils.setup {
        eslint_bin='eslint_d',
        auto_inlay_hints=false,
        eslint_enable_diagnostics=true,
        enable_formatting=true,
        formatter='prettier',
      }
      ts_utils.setup_client(client)
    end
  end

  local dto = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }

  nvim_lsp[lsp].setup(dto)

end

EOF

set completeopt=menu,menuone,noselect
lua << EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
      { name = 'buffer' },
      { name = 'spell' },
      { name = 'calc' },
      { name = 'path' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


EOF

lua << EOF
require('telescope').load_extension('neoclip')
EOF

"Telescope
noremap <space>ff <cmd>Telescope find_files<cr>
noremap <space>fg <cmd>Telescope live_grep<cr>
noremap <space>fb <cmd>Telescope buffers<cr>
noremap <space>fh <cmd>Telescope help_tags<cr>
noremap <space>fj <cmd>Telescope jumplist<cr>
noremap <space>fo <cmd>Telescope oldfiles<cr>
noremap <space>fq <cmd>Telescope quickfix<cr>
noremap <space>fe <cmd>Telescope file_browser<cr>
noremap <space>fr <cmd>Telescope registers<cr>
noremap <space>fm <cmd>Telescope marks<cr>
noremap <space>ft <cmd>Telescope treesitter<cr>
noremap <space>fs <cmd>Telescope current_buffer_fuzzy_find<cr>
noremap <space>f; <cmd>Telescope command_history<cr>
noremap <space>f/ <cmd>Telescope search_history<cr>
noremap <space>f= <cmd>Telescope spell_suggest<cr>
noremap <space>f' <cmd>Telescope neoclip<cr>
noremap <space>fl <cmd>Telescope resume<cr>
noremap <space>fw <cmd>Telescope grep_string<cr>

noremap <space>ll <cmd>lcd %:p:h <bar> pwd<cr>
noremap <space>ls <cmd>lcd .. <bar> pwd<cr>
noremap <space>cc <cmd>cclose<cr>
noremap <space>co <cmd>copen<cr>
noremap <space>clo <cmd>lopen<cr>
noremap <space>cll <cmd>lclose<cr>
noremap <space>tl <cmd>e term://$SHELL \| startinsert<cr>
noremap <space>tvl <cmd>vs term://$SHELL \| startinsert<cr>
noremap <space>tsl <cmd>split term://$SHELL \| startinsert<cr>
noremap <C-6> <C-^>
nnoremap gp `[v`]
noremap <C-W>n <cmd>enew<cr>
noremap <space>wn <cmd>enew<cr>
noremap <space>ww <C-W>w
noremap <space>wp <C-W>p
noremap <space>wh <C-W>h
noremap <space>wj <C-W>j
noremap <space>wk <C-W>k
noremap <space>w= <C-W>=
noremap <space>wl <C-W>l
noremap <space>wc <C-W>c
noremap <space>wo <C-W>o
noremap <space>wv <C-W>v
noremap <space>wx <C-W>s
noremap <space>wL <C-W>L
noremap <space>wH <C-W>H
noremap <space>wJ <C-W>J
noremap <space>wK <C-W>K
noremap <space>ws <cmd>enew \| setlocal buftype=nofile<cr>
tnoremap <C-Escape> <C-\><C-n>
noremap <space>; :
noremap , <C-R>
noremap <C-s> <cmd>bd<cr>
noremap <space>cn <cmd>cn<cr>

command! FormatPrettier %!prettier --stdin-filepath %


"Lightspeed macro fix for now
map <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
map <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
map <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
map <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
