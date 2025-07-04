{
  pkgs,
  lib,
  ...
}: {
  vim = {
    globals.mapleader = ",";

    options = {
      number = true;
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

      # Completion
      complete = ".,w,t";

      # Display
      # background = "dark";
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
        "<leader>v" = {
          action = ":vsplit $MYVIMRC<CR>";
          silent = true;
        };

        # Buffer navigation
        "<C-g>" = {
          action = ":bn<CR>";
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
        theme = "nord";
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

    autocomplete.nvim-cmp.enable = true;
    lsp.enable = true;

    languages = {
      enableTreesitter = true;
      lua.enable = true;
      markdown.enable = true;
      nix.enable = true;
      sql.enable = true;
      ts.enable = true;
      python.enable = true;
      rust.enable = true;
    };
  };
}
