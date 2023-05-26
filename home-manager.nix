# Reference: https://mipmip.github.io/home-manager-option-search/

{ config, lib, pkgs, ... }:
{
  # install packages to /etc/profiles instead of ~/.nix-profile
  home-manager.useUserPackages = true;
  # use global pkgs instance for evaluation (faster)
  home-manager.useGlobalPkgs = true;

  home-manager.users.josh = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [];
    services.dunst = {
      enable = true;
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        aws.disabled = true;
        package.disabled = true;
      python.symbol = " ";
      rust.symbol = " ";
      nix_shell.symbol = "❄️ ";
      };
    };
    programs.zellij = {
      enable = false;
      enableZshIntegration = true;
      settings = {
        "keybinds" = {
        # "keybinds clear-defaults = true" = {
	  normal = {
	    "bind \"Ctrl Alt Shift p\"" = {
		MoveFocus = "Up";
	    };
	  };
	};
        pane_frames = false;
        themes =  {
          catppuccin-latte = {
            bg = "#acb0be"; # Surface2
            fg = "#acb0be"; # Surface2
            red = "#d20f39";
            green = "#40a02b";
            blue = "#1e66f5";
            yellow = "#df8e1d";
            magenta = "#ea76cb"; # Pink
            orange = "#fe640b"; # Peach
            cyan = "#04a5e5"; # Sky
            black = "#4c4f69"; # Text
            white = "#dce0e8"; # Crust
         };
         catppuccin-frappe = {
           bg = "#626880"; # Surface2
           fg = "#c6d0f5";
           red = "#e78284";
           green = "#a6d189";
           blue = "#8caaee";
           yellow = "#e5c890";
           magenta = "#f4b8e4"; # Pink
           orange = "#ef9f76"; # Peach
           cyan = "#99d1db"; # Sky
           black = "#292c3c"; # Mantle
           white = "#c6d0f5";
         };
         catppuccin-macchiato = {
           bg = "#5b6078"; # Surface2
           fg = "#cad3f5";
           red = "#ed8796";
           green = "#a6da95";
           blue = "#8aadf4";
           yellow = "#eed49f";
           magenta = "#f5bde6"; # Pink
           orange = "#f5a97f"; # Peach
           cyan = "#91d7e3"; # Sky
           black = "#1e2030"; # Mantle
           white = "#cad3f5";
         };
         catppuccin-mocha = {
           bg = "#585b70"; # Surface2
           fg = "#cdd6f4";
           red = "#f38ba8";
           green = "#a6e3a1";
           blue = "#89b4fa";
           yellow = "#f9e2af";
           magenta = "#f5c2e7"; # Pink
           orange = "#fab387"; # Peach
           cyan = "#89dceb"; # Sky
           black = "#181825"; # Mantle
           white = "#cdd6f4";
	 };
	};
      theme = "catppuccin-macchiato";
      };
    };
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = false;
          activeBorderColor = [ "blue" "bold" ];
          inactiveBorderColor = [ "black" ];
          # selectedLineBgColor = [ "default" ];
        };
	git.paging = {
	  colorArg = "always";
	  pager = "delta --paging=never";
	};
      };
    };
    programs.kitty = {
      # enable = true;
    };
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        -- Pull in the wezterm API
        local wezterm = require 'wezterm'

        local config = {}

        -- Use config_builder if available
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.color_scheme = 'Catppuccin Macchiato'
        config.window_background_opacity = 0.9
        config.hide_tab_bar_if_only_one_tab = true

        return config
      '';
    };
    programs.exa = {
      enable = true;
      enableAliases = true;
      extraOptions = ["--git" "--icons"];
    };
    programs.zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [
        "vi-mode"
	"direnv"
      ];
      initExtraFirst =
''
# Use user environment, ZSH autocompletion, and aliases in `sudo`
alias sudo='nocorrect sudo -E '

# Command auto-correction
ENABLE_CORRECTION=true
VI_MODE_SET_CURSOR=true
COMPLETION_WAITING_DOTS=true
# Tab-complete works the same for space and hyphen
HYPHEN_INSENSITIVE=true
# Makes git integration much faster
DISABLE_UNTRACKED_FILES_DIRTY=true

setopt AUTO_PARAM_SLASH # add trailing slashes to dirs on completion
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' squeeze-slashes true

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list "" \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
#  'r:|?=** m:{a-z\-}={A-Z\_}'
'';
      initExtra =
''
# Eliminate delay going to vim normal mode
KEYTIMEOUT=1
# Bind escape so it doesn't block in normal mode
noop () {}
zle -N noop
bindkey -M vicmd '\e' noop
'';
      autocd = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "viins";
      shellAliases = {
        lg = "lazygit";
      };
    };
    # TODO: Try this out!
    # wayland.windowManager.sway = {
    #   enable = true;
    #   config = rec {
    #     modifier = "Mod4";
    #     # Use wezterm as default terminal
    #     terminal = "wezterm";
    #     startup = [
    #       # Launch Firefox on start
    #       {command = "firefox";}
    #     ];
    #   };
    # };
  };
}
