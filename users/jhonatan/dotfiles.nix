{ pkgs, ... }:
let
  oh-my-bash-source = pkgs.fetchFromGitHub {
    owner = "ohmybash";
    repo = "oh-my-bash";
    rev = "52a8fad4cc207c2f6d1de28788c2b2ae61756a7a";
    hash = "sha256-4uaDiQMcPdKAXgpN5dKNfYKfHqM8MsX0bWyT9OcK0bw=";
  };
in {
  home.file = {
    ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";
		".config/alacritty/alacritty.toml".text = ''
# You can set shell.program to the path of your favorite shell, e.g. /bin/zsh. Entries in shell.args are passed as arguments to the shell.
#
# Default:
#   Linux/BSD/macOS: `$SHELL` or the user's login shell, if `$SHELL` is unset
#   Windows: `"powershell"`
#
# Example:
#   ```
#   [shell]
#   program = "/bin/zsh"
#   args = ["-l"]
#   ```
#
# Schema: `"<string>" | { program = "<string>", args = ["<string>",] }`

# `$SHELL` or the user's login shell, if `$SHELL` is unset
# Windows: `"powershell"`
# shell = 

# Directory the shell is started in. When this is unset, or "None", the working directory of the parent process will be used.
#
# Default: "None"
#
# Schema: `"<string>" | "None"`

working_directory = "None"

# Live config reload (changes require restart)
#
# Default: true
#
# Schema: `true | false`

general.live_config_reload = true

# Offer IPC using `alacritty msg` (unix only)
#
# Default: true
#
# Schema: `true | false`

general.ipc_socket = true # (unix only)

#######
# ENV #
#######

# All key-value pairs in the [env] section will be added as environment variables for any process spawned by Alacritty, including its shell. Some entries may override variables set by alacritty itself.
#
# Example:
#   ```
#   [env]
#   WINIT_X11_SCALE_FACTOR = "1.0"
#   ```

[env]


##########
# WINDOW #
##########

# This section documents the [window] table of the configuration file.
#
# Example:
#   ```
#   [window]
#   padding = { x = 3, y = 3 }
#   dynamic_padding = true
#   opacity = 0.9
#   ```

[window]

# Window startup position.
#
# Specified in number of pixels.
#
# If the position is "None", the window manager will handle placement.
#
# Schema: `"None" | { x = <integer>, y = <integer> }`

position = "None"

# Blank space added around the window in pixels. This padding is scaled by DPI and the specified value is always added at both opposing sides.
#
# Schema: `{ x = <integer>, y = <integer> }`

padding = { x = 0, y = 0 }

# Spread additional padding evenly around the terminal content.
#
# Default: false
#
# Schema: `true | false`

dynamic_padding = false

# Window decorations.
#
# "Full"
#   Borders and title bar.
#
# "None"
#   Neither borders nor title bar.
#
# "Transparent" (macOS only)
#   Title bar, transparent background and title bar buttons.
#
# "Buttonless" (macOS only)
#   Title bar, transparent background and no title bar buttons.
#
# Default: "Full"
#
# Schema: `"Full" | "None" | "Transparent" | "Buttonless"`

decorations = "Full"

# Background opacity as a floating point number from 0.0 to 1.0. The value 0.0 is completely transparent and 1.0 is opaque.
#
# Default: 1.0
#
# Schema: `<float>`

opacity = 1.0

# Request compositor to blur content behind transparent windows.
#
# Default: false
#
# Schema: `true | false` # (works on macOS/KDE Wayland)

blur = false

# Startup mode (changes require restart)
#
# "Windowed"
#   Regular window.
#
# "Maximized"
#   The window will be maximized on startup.
#
# "Fullscreen"
#   The window will be fullscreened on startup.
#
# "SimpleFullscreen" (macOS only)
#   Same as Fullscreen, but you can stack windows on top.
#
# Default: "Windowed"
#
# Schema: `"Windowed" | "Maximized" | "Fullscreen" | "SimpleFullscreen"`

startup_mode = "Windowed"

# Window title.
#
# Default: "Alacritty"
#
# Schema: `"<string>"`

title = "Alacritty"

# Allow terminal applications to change Alacritty's window title.
#
# Default: true
#
# Schema: `true | false`

dynamic_title = true

# Window class (Linux/BSD only).
#
# On Wayland, "general" is used as app_id and "instance" is ignored.
#
# Default: { instance = "Alacritty", general = "Alacritty" }
#
# Schema: `{ instance = "<string>", general = "<string>" }`

class = { instance = "Alacritty", general = "Alacritty" }

# Override the variant of the System theme/GTK theme/Wayland client side decorations. Set this to "None" to use the system's default theme variant.
#
# Default: "None"
#
# Schema: `"Dark" | "Light" | "None"`

decorations_theme_variant = "None"

# Prefer resizing window by discrete steps equal to cell dimensions.
#
# Default: false
#
# Schema: `true | false`

resize_increments = false

# Make Option key behave as Alt (macOS only).
#
# Default: "None"
#
# Schema: `"OnlyLeft" | "OnlyRight" | "Both" | "None"`

option_as_alt = "None" # (macos only)

# Example:
#   ```
#   [window]
#   padding = { x = 3, y = 3 }
#   dynamic_padding = true
#   opacity = 0.9
#   ```

########
# FONT #
########

# This section documents the [font] table of the configuration file.

# Default:
#   Linux/BSD: { family = "monospace", style = "Regular" }
#   Windows: { family = "Consolas", style = "Regular" }
#   macOS: { family = "Menlo", style = "Regular" }
#
# Schema: `{ family = "<string>", style = "<string>" }`

[font.normal]
family = "GoMono Nerd Font" # Linux/BSD
# family = "Consolas" # Windows
# family = "Menlo" # macOS
style = "Regular"

# If the family is not specified, it will fall back to the value specified for the normal font.
#
# Default: { style = "Bold" }
#
# Schema: `{ family = "<string>", style = "<string>" }`

[font.bold]
style = "Bold"

# If the family is not specified, it will fall back to the value specified for the normal font.
#
# Default: { style = "Italic" }
#
# Schema: `{ family = "<string>", style = "<string>" }`

[font.italic]
style = "Italic"

# If the family is not specified, it will fall back to the value specified for the normal font.
#
# Default: { style = "Bold Italic" }
#
# Schema: `{ family = "<string>", style = "<string>" }`

[font.bold_italic]
style = "Bold Italic"

# Glyph offset determines the locations of the glyphs within their cells with the default being at the bottom. Increasing x moves the glyph to the right, increasing y moves the glyph upward.

#########
# COLORS #
#########

# This section documents the [colors] table of the configuration file.
#
# Colors are specified using their hexadecimal values with a `#` prefix: `#RRGGBB`.

[colors]

# This section documents the [colors.primary] table of the configuration file.

# Default: "#d8d8d8"
#
# Schema: `"<string>"`

primary.foreground = "#d8d8d8"

# Default: "#181818"
#
# Schema: `"<string>"`

primary.background = "#181818"

# If this is not set, the color is automatically calculated based on the foreground color.
#
# Default: "#828482"
#
# Schema: `"<string>"`

# primary.dim_foreground = "#828482"

# This color is only used when `draw_bold_text_with_bright_colors` is true.
#
# If this is not set, the normal foreground will be used.
#
# Default: "None"
#
# Schema: `"<string>"`

# primary.bright_foreground = "None"

# Colors which should be used to draw the terminal cursor.
#
# Allowed values are hexadecimal colors like #ff00ff, or CellForeground/CellBackground, which references the affected cell.
#
# Default: { text = "CellBackground", cursor = "CellForeground" }
#
# Schema: `{ text = "<string>", cursor = "<string>" }`

cursor = { text = "CellBackground", cursor = "CellForeground" }

# Colors for the cursor when the vi mode is active.
#
# Allowed values are hexadecimal colors like #ff00ff, or CellForeground/CellBackground, which references the affected cell.
#
# Default: { text = "CellBackground", cursor = "CellForeground" }
#
# Schema: `{ text = "<string>", cursor = "<string>" }`

vi_mode_cursor = { text = "CellBackground", cursor = "CellForeground" }

# This section documents the [colors.search] table of the configuration.
#
# Allowed values are hexadecimal colors like #ff00ff, or CellForeground/CellBackground, which references the affected cell.

[colors.search]

# Default: { foreground = "#181818", background = "#ac4242" }
#
# Schema: `{ foreground = "<string>", background = "<string>" }`

matches = { foreground = "#181818", background = "#ac4242" }

# Default: { foreground = "#181818", background = "#f4bf75" }
#
# Schema: `{ foreground = "<string>", background = "<string>" }`

focused_match = { foreground = "#181818", background = "#f4bf75" }

# This section documents the [colors.hints] table of the configuration.

[colors.hints]

# First character in the hint label.
#
# Allowed values are hexadecimal colors like #ff00ff, or CellForeground/CellBackground, which references the affected cell.
#
# Default: { foreground = "#181818", background = "#f4bf75" }
#
# Schema: `{ foreground = "<string>", background = "<string>" }`

start = { foreground = "#181818", background = "#f4bf75" }

# All characters after the first one in the hint label.
#
# Allowed values are hexadecimal colors like #ff00ff, or CellForeground/CellBackground, which references the affected cell.
#
# Default: { foreground = "#181818", background = "#ac4242" }
#
# Schema: `{ foreground = "<string>", background = "<string>" }`

end = { foreground = "#181818", background = "#ac4242" }

# This section documents the [colors.normal] table of the configuration.

[colors.normal]

# Default: "#181818"
#
# Schema: `"<string>"`

black = "#181818"

# Default: "#ac4242"
#
# Schema: `"<string>"`

red = "#ac4242"

# Default: "#90a959"
#
# Schema: `"<string>"`

green = "#90a959"

# Default: "#f4bf75"
#
# Schema: `"<string>"`

yellow = "#f4bf75"

# Default: "#6a9fb5"
#
# Schema: `"<string>"`

blue = "#6a9fb5"

# Default: "#aa759f"
#
# Schema: `"<string>"`

magenta = "#aa759f"

# Default: "#75b5aa"
#
# Schema: `"<string>"`

cyan = "#75b5aa"

# Default: "#d8d8d8"
#
# Schema: `"<string>"`

white = "#d8d8d8"

# This section documents the [colors.bright] table of the configuration.

[colors.bright]

# Default: "#6b6b6b"
#
# Schema: `"<string>"`

black = "#6b6b6b"

# Default: "#c55555"
#
# Schema: `"<string>"`

red = "#c55555"

# Default: "#aac474"
#
# Schema: `"<string>"`

green = "#aac474"

# Default: "#feca88"
#
# Schema: `"<string>"`

yellow = "#feca88"

# Default: "#82b8c8"
#
# Schema: `"<string>"`

blue = "#82b8c8"

# Default: "#c28cb8"
#
# Schema: `"<string>"`

magenta = "#c28cb8"

# Default: "#93d3c3"
#
# Schema: `"<string>"`

cyan = "#93d3c3"

# Default: "#f8f8f8"
#
# Schema: `"<string>"`

white = "#f8f8f8"

# This section documents the [colors.dim] table of the configuration.
#
# If the dim colors are not set, they will be calculated automatically based on the normal colors.

[colors.dim]

# Default: "#0f0f0f"
#
# Schema: `"<string>"`

black = "#0f0f0f"

# Default: "#712b2b"
#
# Schema: `"<string>"`

red = "#712b2b"

# Default: "#5f6f3a"
#
# Schema: `"<string>"`

green = "#5f6f3a"

# Default: "#a17e4d"
#
# Schema: `"<string>"`

yellow = "#a17e4d"

# Default: "#456877"
#
# Schema: `"<string>"`

blue = "#456877"

# Default: "#704d68"
#
# Schema: `"<string>"`

magenta = "#704d68"

# Default: "#4d7770"
#
# Schema: `"<string>"`

cyan = "#4d7770"

# Default: "#8e8e8e"
#
# Schema: `"<string>"`

white = "#8e8e8e"

# The indexed colors include all colors from 16 to 256. When these are not set, they're filled with sensible defaults.
#
# Default: []
#
# Schema: `[{ index = <integer>, color = "<string>" },]`

# Whether or not window.opacity applies to all cell backgrounds, or only to the default background. When set to true all cells will be transparent regardless of their background color.
#
# Default: false
#
# Schema: `true | false`

# When true, bold text is drawn using the bright color variants.
#
# Default: false
#
# Schema: `true | false`

########
# BELL #
########

# This section documents the [bell] table of the configuration file.

[bell]

# Visual bell animation effect for flashing the screen when the visual bell is rung.
#
# "Ease"
# "EaseOut"
# "EaseOutSine"
# "EaseOutQuad"
# "EaseOutCubic"
# "EaseOutQuart"
# "EaseOutQuint"
# "EaseOutExpo"
# "EaseOutCirc"
# "Linear"
#
# Default: "Linear"
#
# Schema: `"Ease" | "EaseOut" | "EaseOutSine" | "EaseOutQuad" | "EaseOutCubic" | "EaseOutQuart" | "EaseOutQuint" | "EaseOutExpo" | "EaseOutCirc" | "Linear"`

animation = "Linear"

# Duration of the visual bell flash in milliseconds. A `duration` of `0` will disable the visual bell animation.
#
# Default: 0
#
# Schema: `<integer>`

duration = 0

# Visual bell animation color.
#
# Default: "#ffffff"
#
# Schema: `"<string>"`

color = "#ffffff"

# This program is executed whenever the bell is rung.
#
# When set to "None", no command will be executed.
#
# Default: "None"
#
# Schema: `"<string>" | { program = "<string>", args = ["<string>",] }`

command = "None"

############
# SELECTION #
############

# This section documents the [selection] table of the configuration file.

[selection]

# This string contains all characters that are used as separators for "semantic words" in Alacritty.
#
# Default: ",│`|:\""' ()[]{}<>\t"
#
# Schema: `"<string>"`

semantic_escape_chars = ",│`|:\"' ()[]{}<>\t"

# When set to true, selected text will be copied to the primary clipboard.
#
# Default: false
#
# Schema: `true | false`

save_to_clipboard = false

#########
# CURSOR #
#########

# This section documents the [cursor] table of the configuration file.

[cursor]

# Default: { shape = "Block", blinking = "Off" }
#
# Schema: `{ shape = "<shape>", blinking = "<blinking>" }`

style = { shape = "Block", blinking = "Off" }

# If the vi mode cursor style is "None" or not specified, it will fall back to the active value of the normal cursor.
#
# Default: "None"
#
# Schema: `{ shape = "<shape>", blinking = "<blinking>" } | "None"`

vi_mode_style = "None"

# Cursor blinking interval in milliseconds.
#
# Default: 750
#
# Schema: `<integer>`

blink_interval = 750

# Time after which cursor stops blinking, in seconds.
#
# Specifying 0 will disable timeout for blinking.
#
# Default: 5
#
# Schema: `<integer>`

blink_timeout = 5

# When this is true, the cursor will be rendered as a hollow box when the window is not focused.
#
# Default: true
#
# Schema: `true | false`

unfocused_hollow = true

# Thickness of the cursor relative to the cell width as floating point number from 0.0 to 1.0.
#
# Default: 0.15
#
# Schema: `<float>`

thickness = 0.15

# Shape:
#   "Block"
#   "Underline"
#   "Beam"
#
# Blinking:
#   "Never"
#     Prevent the cursor from ever blinking
#   "Off"
#     Disable blinking by default
#   "On"
#     Enable blinking by default
#   "Always"
#     Force the cursor to always blink

###########
# TERMINAL #
###########

# This section documents the [terminal] table of the configuration file.

[terminal]

# Controls the ability to write to the system clipboard with the OSC 52 escape sequence. While this escape sequence is useful to copy contents from the remote server, allowing any application to read from the clipboard can be easily abused while not providing significant benefits over explicitly pasting text.
#
# "Disabled"
#   Disable writing to the system clipboard entirely.
#
# "OnlyCopy"
#   Allow writing to the system clipboard from Alacritty only.
#
# "OnlyPaste"
#   Allow reading from the system clipboard in Alacritty only.
#
# "CopyPaste"
#   Allow writing to and reading from the system clipboard in Alacritty.
#
# Default: "OnlyCopy"
#
# Schema: `"Disabled" | "OnlyCopy" | "OnlyPaste" | "CopyPaste"`

osc52 = "OnlyCopy"

########
# MOUSE #
########

# This section documents the [mouse] table of the configuration file.

[mouse]

# When this is true, the cursor is temporarily hidden when typing.
#
# Default: false
#
# Schema: `true | false`

hide_when_typing = false

# See keyboard.bindings for full documentation on mods, mode, action, and chars.
#
# When an application running within Alacritty captures the mouse, the `Shift` modifier can be used to suppress mouse reporting. If no action is found for the event, actions for the event without the `Shift` modifier are triggered instead.
#
# mouse = "Middle" | "Left" | "Right" | "Back" | "Forward" | <integer>
#   Mouse button which needs to be pressed to trigger this binding.
#
# action = <keyboard.bindings.action> | "ExpandSelection"
#   "ExpandSelection"
#     Expand the selection to the current mouse cursor location.
#
# Example:
#   ```
#   [mouse]
#   bindings = [
#     { mouse = "Right", mods = "Control", action = "Paste" },
#   ]
#   ```
#
# Schema: `[{ mouse = "<mouse>", mods = "<string>", mode = "<string>", action = "<action>" | "<chars>" },]`

bindings = []

########
# HINTS #
########

# This section documents the [hints] table of the configuration file.
#
# Terminal hints can be used to find text or hyperlinks in the visible part of the terminal and pipe it to other applications.

[hints]

# Keys used for the hint labels.
#
# Default: "jfkdls;ahgurieowpq"
#
# Schema: `"<string>"`

alphabet = "jfkdls;ahgurieowpq"

# Array with all available hints.
# Each hint must have at least one of regex or hyperlinks and either an action or a command.

# Schema: `[{ regex = "<string>", hyperlinks = true | false, post_processing = true | false, persist = true | false, action = "Copy" | "Paste" | "Select" | "MoveViModeCursor", command = "<string>" | { program = "<string>", args = ["<string>",] }, binding = { key = "<string>", mods = "<string>", mode = "<string>" }, mouse = { mods = "<string>", enabled = true | false } },]`
  # Default:

[[hints.enabled]]
command = "xdg-open" # On Linux/BSD
# command = "open" # On macOS
# command = { program = "cmd", args = [ "/c", "start", "" ] } # On Windows
hyperlinks = true
post_processing = true
persist = false
mouse.enabled = true
binding = { key = "U", mods = "Control|Shift" }
regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+"

############
# KEYBOARD #
############

# This section documents the [keyboard] table of the configuration file.

[keyboard]

# To unset a default binding, you can use the action "ReceiveChar" to remove it or "None" to inhibit any action.
#
# Multiple keybindings can be triggered by a single key press and will be executed in the order they are defined in.
#
# key = "<string>"
#   The regular keys like "A", "0", and "Я" can be mapped directly without any special syntax. Full list of named keys like "F1" and the syntax for dead keys can be found here:
#     https://docs.rs/winit/latest/winit/keyboard/enum.NamedKey.html
#     https://docs.rs/winit/latest/winit/keyboard/enum.Key.html#variant.Dead
#
#   Numpad keys are prefixed by "Numpad": "NumpadEnter" | "NumpadAdd" | "NumpadComma" | "NumpadDivide" | "NumpadEquals" | "NumpadSubtract" | "NumpadMultiply" | "Numpad[0-9]".
#
#   The key field also supports using scancodes, which are specified as a decimal number.
#
# mods = "Command" | "Control" | "Option" | "Super" | "Shift" | "Alt"
#   Multiple modifiers can be combined using |, like this: "Control | Shift".
#
# mode = "AppCursor" | "AppKeypad" | "Search" | "Alt" | "Vi"
#   This defines a terminal mode which must be active for this binding to have an effect.
#
#   Prepending ~ to a mode will require the mode to not be active for the binding to take effect.
#
#   Multiple modes can be combined using |, like this: "~Vi|Search".
#
# chars = "<string>"
#   Writes the specified string to the terminal.
#
# action
#   "ReceiveChar"
#     Allow receiving char input.
#
#   "None"
#     No action.
#
#   "Paste"
#     Paste contents of system clipboard.
#
#   "Copy"
#     Store current selection into clipboard.
#
#   "IncreaseFontSize"
#     Increase font size.
#
#   "DecreaseFontSize"
#     Decrease font size.
#
#   "ResetFontSize"
#     Reset font size to the config value.
#
#   "ScrollPageUp"
#     Scroll exactly one page up.
#
#   "ScrollPageDown"
#     Scroll exactly one page down.
#
#   "ScrollHalfPageUp"
#     Scroll half a page up.
#
#   "ScrollHalfPageDown"
#     Scroll half a page down.
#
#   "ScrollLineUp"
#     Scroll one line up.
#
#   "ScrollLineDown"
#     Scroll one line down.
#
#   "ScrollToTop"
#     Scroll all the way to the top.
#
#   "ScrollToBottom"
#     Scroll all the way to the bottom.
#
#   "ClearHistory"
#     Clear the display buffer(s) to remove history.
#
#   "Hide"
#     Hide the Alacritty window.
#
#   "Minimize"
#     Minimize the Alacritty window.
#
#   "Quit"
#     Quit Alacritty.
#
#   "ClearLogNotice"
#     Clear warning and error notices.
#
#   "SpawnNewInstance"
#     Spawn a new instance of Alacritty.
#
#   "CreateNewWindow"
#     Create a new Alacritty window.
#
#   "ToggleFullscreen"
#     Toggle fullscreen.
#
#   "ToggleMaximized"
#     Toggle maximized.
#
#   "ClearSelection"
#     Clear active selection.
#
#   "ToggleViMode"
#     Toggle vi mode.
#
#   "SearchForward"
#     Start a forward buffer search.
#
#   "SearchBackward"
#     Start a backward buffer search.
#
#   Vi mode actions:
#
#   "Up"
#     Move up.
#
#   "Down"
#     Move down.
#
#   "Left"
#     Move left.
#
#   "Right"
#     Move right.
#
#   "First"
#     First column, or beginning of the line when already at the first column.
#
#   "Last"
#     Last column, or beginning of the line when already at the last column.
#
#   "FirstOccupied"
#     First non-empty cell in this terminal row, or first non-empty cell of the line when already at the first cell of the row.
#
#   "High"
#     Move to top of screen.
#
#   "Middle"
#     Move to center of screen.
#
#   "Low"
#     Move to bottom of screen.
#
#   "SemanticLeft"
#     Move to start of semantically separated word.
#
#   "SemanticRight"
#     Move to start of next semantically separated word.
#
#   "SemanticLeftEnd"
#     Move to end of previous semantically separated word.
#
#   "SemanticRightEnd"
#     Move to end of semantically separated word.
#
#   "WordLeft"
#     Move to start of whitespace separated word.
#
#   "WordRight"
#     Move to start of next whitespace separated word.
#
#   "WordLeftEnd"
#     Move to end of previous whitespace separated word.
#
#   "WordRightEnd"
#     Move to end of whitespace separated word.
#
#   "Bracket"
#     Move to opposing bracket.
#
#   "ToggleNormalSelection"
#     Toggle normal vi selection.
#
#   "ToggleLineSelection"
#     Toggle line vi selection.
#
#   "ToggleBlockSelection"
#     Toggle block vi selection.
#
#   "ToggleSemanticSelection"
#     Toggle semantic vi selection.
#
#   "SearchNext"
#     Jump to the beginning of the next match.
#
#   "SearchPrevious"
#     Jump to the beginning of the previous match.
#
#   "SearchStart"
#     Jump to the next start of a match to the left of the origin.
#
#   "SearchEnd"
#     Jump to the next end of a match to the right of the origin.
#
#   "Open"
#     Launch the URL below the vi mode cursor.
#
#   "CenterAroundViCursor"
#     Centers the screen around the vi mode cursor.
#
#   "InlineSearchForward"
#     Search forward within the current line.
#
#   "InlineSearchBcakward"
#     Search backward within the current line.
#
#   "InlineSearchForwardShort"
#     Search forward within the current line, stopping just short of the character.
#
#   "InlineSearchBackwardShort"
#     Search backward within the current line, stopping just short of the character.
#
#   "InlineSearchNext"
#     Jump to the next inline search match.
#
#   "InlineSearchPrevious"
#     Jump to the previous inline search match.
#
#   Search actions:
#
#   "SearchFocusNext"
#     Move the focus to the next search match.
#
#   "SearchFocusPrevious"
#     Move the focus to the previous search match.
#
#   "SearchConfirm"
#     Confirm the active search.
#
#   "SearchCancel"
#     Cancel the active search.
#
#   "SearchClear"
#     Reset the search regex.
#
#   "SearchDeleteWord"
#     Delete the last word in the search regex.
#
#   "SearchHistoryPrevious"
#     Go to the previous regex in the search history.
#
#   "SearchHistoryNext"
#     Go to the next regex in the search history.
#
#   macOS exclusive:
#
#   "ToggleSimpleFullscreen"
#     Enter fullscreen without occupying another space.
#
#   "HideOtherApplications"
#     Hide all windows other than Alacritty.
#
#   "CreateNewTab"
#     Create new window in a tab.
#
#   "SelectNextTab"
#     Select next tab.
#
#   "SelectPreviousTab"
#     Select previous tab.
#
#   "SelectTab1"
#     Select the first tab.
#
#   "SelectTab2"
#     Select the second tab.
#
#   "SelectTab3"
#     Select the third tab.
#
#   "SelectTab4"
#     Select the fourth tab.
#
#   "SelectTab5"
#     Select the fifth tab.
#
#   "SelectTab6"
#     Select the sixth tab.
#
#   "SelectTab7"
#     Select the seventh tab.
#
#   "SelectTab8"
#     Select the eighth tab.
#
#   "SelectTab9"
#     Select the ninth tab.
#
#   "SelectLastTab"
#     Select the last tab.
#
#   Linux/BSD exclusive:
#
#   "CopySelection"
#     Copy from the selection buffer.
#
#   "PasteSelection"
#     Paste from the selection buffer.
#
# Default: See [alacritty-bindings](https://alacritty.org/config-alacritty-bindings.html)
#
# Example:
#   ```
#   [keyboard]
#   bindings = [
#     { key = "N", mods = "Control|Shift", action = "CreateNewWindow" },
#     { key = "L", mods = "Control|Shift", chars = "l" },
#   ]
#   ```
#
# Schema: `[{ key = "<string>", mods = "<string>", mode = "<string>", action = "<action>" | "<chars>" },]`

bindings = []

########
# DEBUG #
########

# This section documents the [debug] table of the configuration file.
#
# Debug options are meant to help troubleshoot issues with Alacritty. These can change or be removed entirely without warning, so their stability shouldn't be relied upon.

[debug]

# Display the time it takes to draw each frame.
#
# Default: false
#
# Schema: `true | false`

render_timer = false

# Keep the log file after quitting Alacritty.
#
# Default: false
#
# Schema: `true | false`

persistent_logging = false

# Default: "Warn"
#
# Schema: `"Off" | "Error" | "Warn" | "Info" | "Debug" | "Trace"`

log_level = "Warn"

# To add extra libraries to logging ALACRITTY_EXTRA_LOG_TARGETS variable can be used.
#
# Example:
#   ALACRITTY_EXTRA_LOG_TARGETS="winit;vte" alacritty -vvv

# Force use of a specific renderer, "None" will use the highest available one.
#
# Default: "None"
#
# Schema: `"glsl3" | "gles2" | "gles2_pure" | "None"`

renderer = "None"

# Log all received window events.
#
# Default: false
#
# Schema: `true | false`

print_events = false

# Highlight window damage information.
#
# Default: false
#
# Schema: `true | false`

highlight_damage = false

# Use EGL as display API if the current platform allows it. Note that transparency may not work with EGL on Linux/BSD.
#
# Default: false
#
# Schema: `true | false`

prefer_egl = false
		'';
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
      	bind "Ctrl w" { NewTab { cwd "/home/jhonatan/Workspace/code/"; }; SwitchToMode "Normal"; }
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
      export OSH='${oh-my-bash-source}'
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
    '';
  };
}
