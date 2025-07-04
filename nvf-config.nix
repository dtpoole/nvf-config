{
  pkgs,
  lib,
  ...
}: {
  vim = {
    globals = {
      leader = ",";
    };

    # Key mappings
    maps = {
      # Insert mode mappings
      insert = {
        "jj" = {
          action = "<Esc>";
          silent = true;
        };
      };

      # Normal mode mappings
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
    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    lsp.enable = true;

    languages = {
      enableTreesitter = true;

      nix.enable = true;
      ts.enable = true;
      python.enable = true;
      rust.enable = true;
    };
  };
}
