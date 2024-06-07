{ ... }:
let
  nvim-config = {
    enable = true;
    colorschemes.tokyonight.enable = true;

    globals.mapleader = " ";

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
    };

    keymaps = [
      {
        key = ";";
        action = ":";
      }
      {
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>cd";
        action = "<cmd>Telescope diagnostics<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>cs";
        action = "<cmd>Telescope treesitter<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>t";
        action = "<cmd>ToggleTerm<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        key = "<leader>e";
        action = "<cmd>CHADopen<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
    ];

    plugins = {
      chadtree.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      telescope = {
        enable = true;
        extensions = { fzf-native = { enable = true; }; };
      };
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true; # TS/JS
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          astro.enable = true; # AstroJS
          svelte.enable = false; # Svelte
          vuels.enable = false; # Vue
          pyright.enable = true; # Python
          marksman.enable = true; # Markdown
          nil_ls.enable = true; # Nix
          dockerls.enable = true; # Docker
          bashls.enable = true; # Bash
          clangd.enable = true; # C/C++
          csharp-ls.enable = true; # C#
        };
      };
      nvim-autopairs.enable = true;
      toggleterm = {
        enable = true;
        settings = {
          hide_numbers = false;
          autochdir = true;
          close_on_exit = true;
          direction = "horizontal";
        };
      };
    };
  };
in { programs.nixvim = nvim-config; }
