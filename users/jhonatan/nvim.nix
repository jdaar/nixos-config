{ pkgs, ... }: 
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

		autoCmd = [
			{
				event = "LspAttach";
				callback = {
					__raw = ''
						function(args)
							local bufnr = args.buf
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							if vim.tbl_contains({ 'null-ls' }, client.name) then  -- blacklist lsp
								return
							end
							require("lsp_signature").on_attach({
								bind = true,
								handler_opts = {
									border = "rounded"
								}
							}, bufnr)
						end
					'';
				};
			}
			{
				event = "FileType";
				pattern = [ "sql" "mysql" "plsql" ];
				callback = {
					__raw = ''
						function()
							require("cmp").setup.buffer({ sources = {{ name = "vim-dadbod-completion" }} })
						end
					'';
				};
			}
		];

		keymaps = [
			{
				key = ";";
				action = ":";
			}
			{
				key = "<leader>z";
				action = "<cmd>Twilight<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>ca";
				action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>q";
				action = "<cmd>DBUI<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>gt";
				action = "<cmd>Telescope lsp_type_definitions<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>ct";
				action = "<cmd>lua require('lsp_signature').toggle_float_win()<CR>";
				options = {
					silent = false;
					remap = false;
				};
			}
			{
				key = "<leader>gd";
				action = "<cmd>Telescope lsp_definitions<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>gr";
				action = "<cmd>Telescope lsp_references<CR>";
				options = {
					silent = true;
					remap = false;
				};
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
				key = "<leader>f";
				action = "<cmd>Telescope<CR>";
				options = {
					silent = true;
					remap = false;
				};
			}
			{
				key = "<leader>cd";
				action = "<cmd>Trouble diagnostics toggle<CR>";
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

		extraPlugins = with pkgs.vimPlugins; [
			lsp_signature-nvim
			vim-dadbod
			vim-dadbod-ui
			vim-dadbod-completion
		];

		plugins = {
			web-devicons.enable = true;
			fidget.enable = true;
			statuscol.enable = true;
			twilight.enable = true;
			cmp = {
				settings = {
					autoEnableSources = true;
					mapping = {
						"<C-Space>" = "cmp.mapping.complete()";
						"<Tab>" = "cmp.mapping.select_next_item()";
						"<S-Tab>" = "cmp.mapping.select_prev_item()";
						"<CR>" = "cmp.mapping.confirm({ select = true })";
					};
					sources = [
						{ name = "nvim_lsp"; }
						{ name = "path"; }
						{ name = "buffer"; }
					];
				};
				enable = true;
			};
			trouble.enable = true;
			chadtree.enable = true;
			lualine.enable = true;
			bufferline.enable = true;
			gitsigns = {
				enable = true;
				settings.current_line_blame = true;
			};
			telescope = {
				enable = true;
				extensions = { 
					fzf-native.enable = true;
					ui-select.enable = true;
				};
				settings.defaults.wrap_results = true;
			};
			treesitter = {
				enable = true;
			};
			lsp = {
				enable = true;
				servers = {
					ts_ls.enable = true; # TS/JS
					cssls.enable = true; # CSS
					svelte.enable = false;
					tailwindcss.enable = true; # TailwindCSS
					html.enable = true; # HTML
					nixd.enable = true; # Nix
					jsonls.enable = true; # Json
					pyright.enable = true; # Python
					marksman.enable = true; # Markdown
					dockerls.enable = true; # Docker
					bashls.enable = true; # Bash
					clangd.enable = true; # C/C++
				};
			};
			nvim-autopairs.enable = true;
			toggleterm = {
				enable = true;
				settings = {
					autochdir = true;
					close_on_exit = true;
					direction = "horizontal";
				};
			};
		};
	};
in { programs.nixvim = nvim-config; }
