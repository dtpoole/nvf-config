profile: {lib, ...}: let
  # Full profile includes LSP, completion, etc
  isFull = profile == "full";
in {
  vim = {
    globals.mapleader = ",";

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
        "jj" = {
          action = "<Esc>";
          silent = true;
        };
      };

      normal = {
        # Window navigation
        "<C-j>" = {
          action = "<C-w><C-j>";
          silent = true;
        };
        "<C-k>" = {
          action = "<C-w><C-k>";
          silent = true;
        };
        "<C-l>" = {
          action = "<C-w><C-l>";
          silent = true;
        };
        "<C-h>" = {
          action = "<C-w><C-h>";
          silent = true;
        };

        # Movement improvements
        "j" = {
          action = "gj";
          silent = true;
        };
        "k" = {
          action = "gk";
          silent = true;
        };

        # Leader mappings
        "<leader>/" = {
          action = ":nohlsearch<CR>";
          silent = true;
        };
        "<leader><leader>" = {
          action = "<C-^>";
          silent = true;
        };
        "<leader>l" = {
          action = ":set list!<CR>";
          silent = true;
        };
        "<leader>n" = {
          action = ":set number!<CR>";
          silent = true;
        };

        # Buffer navigation
        "<C-g>" = {
          action = ":bn<CR>";
          silent = true;
        };

        "<C-d>" = {
          action = ":NvimTreeToggle<CR>";
          silent = true;
        };

        "_$" = {
          action = ":%s/\\s\\+$//e<CR>";
          silent = true;
        };

        "_=" = {
          action = ":lua if next(vim.lsp.get_clients()) then vim.lsp.buf.format({ async = false }) else vim.cmd('normal! gg=G``') end<CR>";
          silent = true;
        };
      };
    };

    theme = {
      enable = true;
      name = "nord";
      style = "dark";
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
      enable = true;
      mappings = {
        buffers = "<leader>b";
        findFiles = "<leader>f";
        gitBranches = "<leader>gb";
        gitCommits = "<leader>gc";
        gitStatus = "<leader>gs";
      };
    };

    filetree = {
      nvimTree = {
        enable = true;
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
      lua.enable = true;
      markdown.enable = true;
      nix = {
        enable = true;
        format.enable = isFull;
      };
      python.enable = true;
      rust.enable = isFull;
      sql.enable = true;
      ts.enable = isFull;
      yaml.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = true;
    };
  };
}
