{ ... }: {
  home.file = {
    ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";
    ".config/zellij/config.kdl".text = ''
      keybinds {
          normal {
          }
          locked {
      	bind "Ctrl g" { SwitchToMode "Normal"; }
          }
          resize {
      	bind "Ctrl n" { SwitchToMode "Normal"; }
      	bind "h" "Left" { Resize "Increase Left"; }
      	bind "j" "Down" { Resize "Increase Down"; }
      	bind "k" "Up" { Resize "Increase Up"; }
      	bind "l" "Right" { Resize "Increase Right"; }
      	bind "H" { Resize "Decrease Left"; }
      	bind "J" { Resize "Decrease Down"; }
      	bind "K" { Resize "Decrease Up"; }
      	bind "L" { Resize "Decrease Right"; }
      	bind "=" "+" { Resize "Increase"; }
      	bind "-" { Resize "Decrease"; }
          }
          pane {
      	bind "Ctrl p" { SwitchToMode "Normal"; }
      	bind "h" "Left" { MoveFocus "Left"; }
      	bind "l" "Right" { MoveFocus "Right"; }
      	bind "j" "Down" { MoveFocus "Down"; }
      	bind "k" "Up" { MoveFocus "Up"; }
      	bind "p" { SwitchFocus; }
      	bind "n" { NewPane; SwitchToMode "Normal"; }
      	bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
      	bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
      	bind "x" { CloseFocus; SwitchToMode "Normal"; }
      	bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
      	bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
      	bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
      	bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
      	bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0;}
          }
          move {
      	bind "Ctrl h" { SwitchToMode "Normal"; }
      	bind "n" "Tab" { MovePane; }
      	bind "p" { MovePaneBackwards; }
      	bind "h" "Left" { MovePane "Left"; }
      	bind "j" "Down" { MovePane "Down"; }
      	bind "k" "Up" { MovePane "Up"; }
      	bind "l" "Right" { MovePane "Right"; }
          }
          tab {
      	bind "Ctrl t" { SwitchToMode "Normal"; }
      	bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
      	bind "h" "Left" "Up" "k" { GoToPreviousTab; }
      	bind "l" "Right" "Down" "j" { GoToNextTab; }
      	bind "n" { NewTab; SwitchToMode "Normal"; }
      	bind "x" { CloseTab; SwitchToMode "Normal"; }
      	bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
      	bind "b" { BreakPane; SwitchToMode "Normal"; }
      	bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
      	bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
      	bind "1" { GoToTab 1; SwitchToMode "Normal"; }
      	bind "2" { GoToTab 2; SwitchToMode "Normal"; }
      	bind "3" { GoToTab 3; SwitchToMode "Normal"; }
      	bind "4" { GoToTab 4; SwitchToMode "Normal"; }
      	bind "5" { GoToTab 5; SwitchToMode "Normal"; }
      	bind "6" { GoToTab 6; SwitchToMode "Normal"; }
      	bind "7" { GoToTab 7; SwitchToMode "Normal"; }
      	bind "8" { GoToTab 8; SwitchToMode "Normal"; }
      	bind "9" { GoToTab 9; SwitchToMode "Normal"; }
      	bind "Tab" { ToggleTab; }
          }
          scroll {
      	bind "Ctrl s" { SwitchToMode "Normal"; }
      	bind "e" { EditScrollback; SwitchToMode "Normal"; }
      	bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
      	bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
      	bind "j" "Down" { ScrollDown; }
      	bind "k" "Up" { ScrollUp; }
      	bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
      	bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
      	bind "d" { HalfPageScrollDown; }
      	bind "u" { HalfPageScrollUp; }
      	// uncomment this and adjust key if using copy_on_select=false
      	// bind "Alt c" { Copy; }
          }
          search {
      	bind "Ctrl s" { SwitchToMode "Normal"; }
      	bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
      	bind "j" "Down" { ScrollDown; }
      	bind "k" "Up" { ScrollUp; }
      	bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
      	bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
      	bind "d" { HalfPageScrollDown; }
      	bind "u" { HalfPageScrollUp; }
      	bind "n" { Search "down"; }
      	bind "p" { Search "up"; }
      	bind "c" { SearchToggleOption "CaseSensitivity"; }
      	bind "w" { SearchToggleOption "Wrap"; }
      	bind "o" { SearchToggleOption "WholeWord"; }
          }
          entersearch {
      	bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
      	bind "Enter" { SwitchToMode "Search"; }
          }
          renametab {
      	bind "Ctrl c" { SwitchToMode "Normal"; }
      	bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
          }
          renamepane {
      	bind "Ctrl c" { SwitchToMode "Normal"; }
      	bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
          }
          session {
      	bind "Ctrl o" { SwitchToMode "Normal"; }
      	bind "Ctrl s" { SwitchToMode "Scroll"; }
      	bind "d" { Detach; }
      	bind "w" {
      	    LaunchOrFocusPlugin "session-manager" {
      		floating true
      		move_to_focused_tab true
      	    };
      	    SwitchToMode "Normal"
      	}
          }
          tmux {
      	bind "[" { SwitchToMode "Scroll"; }
      	bind "Ctrl b" { Write 2; SwitchToMode "Normal"; }
      	bind "\"" { NewPane "Down"; SwitchToMode "Normal"; }
      	bind "%" { NewPane "Right"; SwitchToMode "Normal"; }
      	bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
      	bind "c" { NewTab; SwitchToMode "Normal"; }
      	bind "," { SwitchToMode "RenameTab"; }
      	bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
      	bind "n" { GoToNextTab; SwitchToMode "Normal"; }
      	bind "Left" { MoveFocus "Left"; SwitchToMode "Normal"; }
      	bind "Right" { MoveFocus "Right"; SwitchToMode "Normal"; }
      	bind "Down" { MoveFocus "Down"; SwitchToMode "Normal"; }
      	bind "Up" { MoveFocus "Up"; SwitchToMode "Normal"; }
      	bind "h" { MoveFocus "Left"; SwitchToMode "Normal"; }
      	bind "l" { MoveFocus "Right"; SwitchToMode "Normal"; }
      	bind "j" { MoveFocus "Down"; SwitchToMode "Normal"; }
      	bind "k" { MoveFocus "Up"; SwitchToMode "Normal"; }
      	bind "o" { FocusNextPane; }
      	bind "d" { Detach; }
      	bind "Space" { NextSwapLayout; }
      	bind "x" { CloseFocus; SwitchToMode "Normal"; }
          }
          shared_except "locked" {
      	bind "Ctrl g" { SwitchToMode "Locked"; }
      	bind "Ctrl q" { Quit; }
      	bind "Alt n" { NewPane; }
      	bind "Alt i" { MoveTab "Left"; }
      	bind "Alt o" { MoveTab "Right"; }
      	bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
      	bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
      	bind "Alt j" "Alt Down" { MoveFocus "Down"; }
      	bind "Alt k" "Alt Up" { MoveFocus "Up"; }
      	bind "Alt =" "Alt +" { Resize "Increase"; }
      	bind "Alt -" { Resize "Decrease"; }
      	bind "Alt [" { PreviousSwapLayout; }
      	bind "Alt ]" { NextSwapLayout; }
          }
          shared_except "normal" "locked" {
      	bind "Enter" "Esc" { SwitchToMode "Normal"; }
          }
          shared_except "pane" "locked" {
      	bind "Ctrl p" { SwitchToMode "Pane"; }
          }
          shared_except "resize" "locked" {
      	bind "Ctrl n" { SwitchToMode "Resize"; }
          }
          shared_except "scroll" "locked" {
      	bind "Ctrl s" { SwitchToMode "Scroll"; }
          }
          shared_except "session" "locked" {
      	bind "Ctrl o" { SwitchToMode "Session"; }
          }
          shared_except "tab" "locked" {
      	bind "Ctrl t" { SwitchToMode "Tab"; }
          }
          shared_except "move" "locked" {
      	bind "Ctrl h" { SwitchToMode "Move"; }
          }
          shared_except "tmux" "locked" {
      	bind "Ctrl b" { SwitchToMode "Tmux"; }
          }
      }

      plugins {
          tab-bar location="zellij:tab-bar"
          status-bar location="zellij:status-bar"
          strider location="zellij:strider"
          compact-bar location="zellij:compact-bar"
          session-manager location="zellij:session-manager"
          welcome-screen location="zellij:session-manager" {
      	welcome_screen true
          }
          filepicker location="zellij:strider" {
      	cwd "/"
          }
      }

      themes {
           tokyo-night {
      	fg 169 177 214
      	bg 26 27 38
      	black 56 62 90
      	red 249 51 87
      	green 158 206 106
      	yellow 224 175 104
      	blue 122 162 247
      	magenta 187 154 247
      	cyan 42 195 222
      	white 192 202 245
      	orange 255 158 100
          }
      }

      theme "tokyo-night"
    '';
    ".bashrc".text = ''
      case $- in
      *i*) ;;
      *) return ;;
      esac
      export OSH='/home/jhonatan/.oh-my-bash'
      OSH_THEME="lambda"
      OMB_USE_SUDO=true
      completions=(
      	git
      	composer
      	ssh
      )
      aliases=(
      	general
      )
      plugins=(
      	git
      	bashmarks
      	sudo
      )
      source "$OSH"/oh-my-bash.sh
      eval "$(zellij setup --generate-auto-start bash)"
    '';
  };
}