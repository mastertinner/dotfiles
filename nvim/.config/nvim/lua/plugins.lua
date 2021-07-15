-- Install Packer if it's not installed yet
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    vim.api.nvim_command('packadd packer.nvim')
end

return require('packer').startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Color scheme
    use {'~/vim-quantum', config = function() require('quantum').setup() end}

    -- Fuzzy finding
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- File tree
    use {'preservim/nerdtree', opt = true, cmd = {'NERDTreeToggle'}}
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeIgnore = {'.DS_Store', '.git$'}

    -- Git integration
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }

    -- Detect indentation settings
    use 'tpope/vim-sleuth'

    -- Edit surrounds
    use 'tpope/vim-surround'

    -- Toggle commenting
    use 'tpope/vim-commentary'

    -- Allow to repeat plugin commands
    use 'tpope/vim-repeat'

    -- Autoclose pairs
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup() end
    }

    -- Diff directories
    use {'will133/vim-dirdiff', opt = true, cmd = {'DirDiff'}}
    vim.g.DirDiffExcludes = '.git,node_modules,vendor,dist,.DS_Store,.*.swp'

    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = {enable = true}
            }
        end
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local lsp = require('lspconfig')
            lsp.gopls.setup {}
            lsp.rust_analyzer.setup {}
            lsp.terraformls.setup {}
            lsp.tflint.setup {}
            lsp.tsserver.setup {}
        end
    }

    -- Autocompletions
    use {
        'hrsh7th/nvim-compe',
        config = function()
            require('compe').setup {
                enabled = true,
                source = {path = true, buffer = true, nvim_lsp = true}
            }
        end
    }
    vim.opt.completeopt = {'menuone', 'noselect'}

    -- Linting and auto fixing
    use 'dense-analysis/ale'
    local ale_fixers = {}
    ale_fixers['*'] = {'remove_trailing_lines', 'trim_whitespace'}
    ale_fixers['javascript'] = {'prettier', 'eslint'}
    ale_fixers['typescript'] = {'prettier', 'eslint'}
    ale_fixers['json'] = {'prettier'}
    ale_fixers['html'] = {'prettier'}
    ale_fixers['vue'] = {'prettier'}
    ale_fixers['css'] = {'prettier'}
    ale_fixers['less'] = {'prettier'}
    ale_fixers['scss'] = {'prettier'}
    ale_fixers['graphql'] = {'prettier'}
    ale_fixers['markdown'] = {'prettier'}
    ale_fixers['yaml'] = {'prettier'}
    ale_fixers['go'] = {'goimports'}
    ale_fixers['rust'] = {'rustfmt'}
    ale_fixers['terraform'] = {'terraform'}
    ale_fixers['lua'] = {'lua-format'}
    vim.g.ale_sign_error = '●'
    vim.g.ale_sign_warning = '●'
    vim.g.ale_fixers = ale_fixers
    vim.g.ale_fix_on_save = 1

    -- Distraction free writing
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                window = {
                    backdrop = 1,
                    options = {
                        signcolumn = "no",
                        number = false,
                        relativenumber = false
                    }
                }
            }
        end
    }
    use {
        "folke/twilight.nvim",
        config = function() require("twilight").setup {} end
    }
end)
