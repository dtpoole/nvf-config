profile: {
  lib,
  pkgs,
  ...
}: let
  # Full profile includes LSP, completion, etc
  isFull = profile == "full";

  mkMap = action: {
    inherit action;
    silent = true;
  };
in {
  vim = {
    globals = lib.mkMerge [
      {
        mapleader = ",";
      }
      # Netrw settings for base profile
      (lib.mkIf (!isFull) {
        netrw_banner = 0;
        netrw_liststyle = 3;
        netrw_winsize = 35;
        netrw_browse_split = 4;
        netrw_altv = 1;
      })
    ];

    # Load nord theme manually so we can set options
    theme.enable = false;
    startPlugins = [pkgs.vimPlugins.nord-nvim];

    luaConfigRC = {
      nord-config = ''
        vim.g.nord_contrast = true
        vim.g.nord_borders = true
        vim.g.nord_disable_background = false
        vim.g.nord_italic = false
        vim.g.nord_uniform_diff_background = true
        vim.g.nord_bold = false
        require('nord').set()
      '';
    };

    viAlias = true;
    vimAlias = true;

    options = {
      number = false;
      relativenumber = false;
      cursorline = true;
      showmatch = true;
      ignorecase = true;
      smartcase = true;
      title = true;
      visualbell = true;
      splitright = true;
      splitbelow = true;
      linebreak = true;

      # Tabs and indentation
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      # List characters
      list = false;
      listchars = "eol:↲,tab:▸ ,trail:·";

      # Wild menu
      wildmode = "list:longest,list:full";
      wildignore = "*.swp,*.bak,*.pyc,*.class,.svn,.git";

      signcolumn = "auto";
      showmode = false;

      # Completion
      complete = ".,w,t";

      # Display
      termguicolors = true;
      ttyfast = true;
      laststatus = 1;
      fillchars = "vert:│,stl: ,stlnc:-";
    };

    # Key mappings
    maps = {
      insert = {
        "jj" = mkMap "<Esc>";
      };

      normal = {
        # Window navigation
        "<C-j>" = mkMap "<C-w><C-j>";
        "<C-k>" = mkMap "<C-w><C-k>";
        "<C-l>" = mkMap "<C-w><C-l>";
        "<C-h>" = mkMap "<C-w><C-h>";

        # Movement improvements
        "j" = mkMap "gj";
        "k" = mkMap "gk";

        # Leader mappings
        "<leader>/" = mkMap ":nohlsearch<CR>";
        "<leader><leader>" = mkMap "<C-^>";
        "<leader>l" = mkMap ":set list!<CR>";
        "<leader>n" = mkMap ":set number!<CR>";

        # Buffer navigation
        "<C-g>" = mkMap ":bn<CR>";

        "<C-d>" = mkMap (
          if isFull
          then ":NvimTreeToggle<CR>"
          else ":Lexplore<CR>"
        );

        "_$" = mkMap ":%s/\\s\\+$//e<CR>";

        "_=" = mkMap ":lua if next(vim.lsp.get_clients()) then vim.lsp.buf.format({ async = false }) else vim.cmd('normal! gg=G``') end<CR>";
      };
    };

    statusline = {
      lualine = {
        enable = true;

        sectionSeparator = {
          left = "";
          right = "";
        };

        setupOpts = {
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff"];
            lualine_c = ["filename" "diagnostics"];
            lualine_x =
              [
                "encoding"
                "filetype"
              ]
              ++ lib.optionals isFull [
                (lib.generators.mkLuaInline ''
                  function()
                    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                    if #clients == 0 then return "" end
                    local names = {}
                    for _, client in ipairs(clients) do
                      table.insert(names, client.name)
                    end
                    return "󰒋 " .. table.concat(names, " ")
                  end
                '')
              ];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };
    };

    telescope = {
      enable = isFull;
      mappings = lib.mkIf isFull {
        buffers = "<leader>b";
        findFiles = "<leader>f";
        gitBranches = "<leader>gb";
        gitCommits = "<leader>gc";
        gitStatus = "<leader>gs";
      };
    };

    filetree = {
      nvimTree = {
        enable = isFull;
        openOnSetup = false;
        setupOpts = {
          git.enable = true;
          view = {
            width = 40;
            side = "left";
          };
          renderer = {
            icons = {
              show = {
                git = true;
                folder = true;
                file = true;
              };
            };
          };
          filters = {
            exclude = ["node_modules"];
          };
        };
      };
    };

    autocomplete.nvim-cmp.enable = isFull;
    lsp.enable = isFull;

    languages = {
      enableTreesitter = true;
      bash.enable = true;
      lua.enable = isFull;
      markdown.enable = true;
      nix = {
        enable = true;
        format.enable = isFull;
      };
      python.enable = isFull;
      rust.enable = isFull;
      sql.enable = isFull;
      ts.enable = isFull;
      yaml.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = isFull;
    };
  };
}
