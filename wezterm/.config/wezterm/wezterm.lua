local wezterm = require 'wezterm'
local act = wezterm.action
local resurrect = wezterm.plugin.require 'https://github.com/MLFlexer/resurrect.wezterm'
local config = wezterm.config_builder()

---------------------------------------------------------------------------
-- Leader key (tmux prefix equivalent)
-- Matches tmux prefix: F13 (Caps Lock remapped to F13 via xmodmap on deskflow server)
---------------------------------------------------------------------------
config.leader = { key = 'F13', timeout_milliseconds = 1000 }

---------------------------------------------------------------------------
-- Session persistence (like tmux-resurrect + tmux-continuum)
-- Uses a unix domain mux server that keeps sessions alive when the
-- window closes. Reopening wezterm reconnects to the running server.
-- resurrect.wezterm saves/restores state across reboots.
---------------------------------------------------------------------------
config.unix_domains = {
  { name = 'unix' },
}
config.default_gui_startup_args = { 'connect', 'unix' }

-- Preserve SSH_AUTH_SOCK in mux server (wezterm strips it by default)
config.mux_env_remove = {
  'SSH_CLIENT',
  'SSH_CONNECTION',
}

-- Save state on GUI close (covers normal quit/logout before reboot).
-- gui-detach fires when the window closes even though the unix mux keeps
-- running, so state is fresh when the next gui-startup restores it.
wezterm.on('gui-detach', function()
  local state = resurrect.workspace_state.get_workspace_state()
  resurrect.state_manager.save_state(state)
  resurrect.state_manager.write_current_state(state.workspace, 'workspace')
end)

-- Save workspace state and track current (used by event handlers below)
local function save_workspace(window)
  local workspace = window:active_workspace()
  local state = resurrect.workspace_state.get_workspace_state()
  resurrect.state_manager.save_state(state)
  resurrect.state_manager.write_current_state(workspace, 'workspace')
end

-- Auto-restore on startup (like tmux-continuum restore).
-- gui-startup is never emitted in 'connect unix' mode.
-- The mux server writes /tmp/wezterm-fresh-mux on its first config load;
-- wezterm.GLOBAL persists across hot-reloads so config edits don't re-write it,
-- and wezterm.gui is nil in the headless mux server but a real table in the GUI.
-- update-status reads and deletes that marker for a one-shot restore.
if not wezterm.GLOBAL.mux_initialized then
  wezterm.GLOBAL.mux_initialized = true
  if not wezterm.gui then
    local f = io.open('/tmp/wezterm-fresh-mux', 'w')
    if f then f:write(tostring(os.time())); f:close() end
  end
end
local _startup_restore_done = false

-- Save when pane/tab structure changes (new split, new tab, closed pane).
-- pane-focus-changed fires whenever focus moves to a pane, including on creation.
-- We compare tab+pane counts so we only save on structural changes, not focus switches.
local last_structure = {}
wezterm.on('pane-focus-changed', function(window, pane)
  local win_id = tostring(window:window_id())
  local tabs = window:mux_window():tabs()
  local pane_count = 0
  for _, tab in ipairs(tabs) do
    pane_count = pane_count + #tab:panes()
  end
  local sig = #tabs .. ':' .. pane_count
  if last_structure[win_id] ~= sig then
    last_structure[win_id] = sig
    save_workspace(window)
  end
end)

-- Save when CWD changes. Shell precmd sends OSC 1337 SetUserVar=WEZTERM_SAVE
-- only when $PWD changes (see _wezterm_precmd in .zshrc).
wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'WEZTERM_SAVE' then
    save_workspace(window)
  end
end)

---------------------------------------------------------------------------
-- General
---------------------------------------------------------------------------
config.scrollback_lines = 30000
config.term = 'xterm-256color'
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 50
config.font_size = 13.0
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2 }

-- Dim inactive panes so the active one stands out
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

---------------------------------------------------------------------------
-- Mouse
---------------------------------------------------------------------------
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
  },
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(-3),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(3),
  },
}

---------------------------------------------------------------------------
-- Colors (matching tmux status bar theme: colour234 bg, colour231 fg)
---------------------------------------------------------------------------
config.colors = {
  -- Bright pane split line (default is very subtle)
  split = '#6699cc',

  tab_bar = {
    background = '#1c1c1c',
    active_tab = {
      bg_color = '#0087af',
      fg_color = '#ffffff',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#3a3a3a',
      fg_color = '#b2b2b2',
    },
    inactive_tab_hover = {
      bg_color = '#4e4e4e',
      fg_color = '#ffffff',
    },
    new_tab = {
      bg_color = '#1c1c1c',
      fg_color = '#808080',
    },
    new_tab_hover = {
      bg_color = '#3a3a3a',
      fg_color = '#ffffff',
    },
  },
}

---------------------------------------------------------------------------
-- Vim-aware pane navigation
-- smart-splits.nvim sets IS_NVIM user variable when neovim is running.
-- Ctrl+h/j/k/l navigates panes. Sends Ctrl+h/j/k/l to vim when active.
---------------------------------------------------------------------------
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function vim_nav(key, direction)
  return {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end),
  }
end

---------------------------------------------------------------------------
-- Key bindings
---------------------------------------------------------------------------
config.keys = {
  -- Splits (LEADER + \ horizontal, LEADER + - vertical) — matches tmux
  {
    key = '\\',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Resize panes (LEADER + h/j/k/l by 5 units) — matches tmux
  { key = 'h', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'j', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'k', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'l', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'LeftArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'DownArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'UpArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'RightArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Vim-aware pane navigation (Alt+h/j/k/l) — matches tmux smart pane switching
  vim_nav('h', 'Left'),
  vim_nav('j', 'Down'),
  vim_nav('k', 'Up'),
  vim_nav('l', 'Right'),

  -- Copy mode (LEADER + Escape to enter) — matches tmux bind Escape copy-mode
  -- Once in copy mode: v to select, y to yank, q/Escape to exit
  { key = 'Escape', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Paste (LEADER + p) — matches tmux bind p paste-buffer
  { key = 'p', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },

  -- New tab (LEADER + c) — matches tmux new-window
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },

  -- Tab navigation (LEADER + n for next) — matches tmux next-window
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },

  -- Tab navigation by index (LEADER + number) — matches tmux select-window
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

  -- Swap tabs (Ctrl+Shift+Left/Right) — matches tmux swap-window
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },

  -- Close pane (LEADER + x) — matches tmux kill-pane
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- Zoom/fullscreen pane (LEADER + z) — matches tmux resize-pane -Z
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- Last tab (double-tap F13) — matches tmux bind-key F10 last-window
  { key = 'F13', mods = 'LEADER', action = act.ActivateLastTab },

  -- Send F13 through (LEADER + a) — matches tmux send-prefix for nested sessions
  { key = 'a', mods = 'LEADER', action = act.SendKey { key = 'F13' } },

  -- Workspaces (tmux sessions equivalent)
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- Rename tab (LEADER + ,) — matches tmux rename-window
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new tab name',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- Quick select (like tmux-urlview) — highlights URLs, hashes, paths, etc.
  { key = 'u', mods = 'LEADER', action = act.QuickSelect },

  -- Prompt navigation (requires shell integration in .zshrc)
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },

  -- Session save/restore (like tmux-resurrect prefix+Ctrl-s / prefix+Ctrl-r)
  {
    key = 'S',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      local workspace = win:active_workspace()
      local state = resurrect.workspace_state.get_workspace_state()
      resurrect.state_manager.save_state(state)
      resurrect.state_manager.write_current_state(state.workspace, 'workspace')
      resurrect.window_state.save_window_action()
    end),
  },
  {
    key = 'R',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
        local type = id:match '([^/]+)' or 'workspace'
        local name = id:match '/(.+)$'
        local state = resurrect.state_manager.load_state(name, type)
        if type == 'workspace' then
          resurrect.workspace_state.restore_workspace(state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        elseif type == 'window' then
          resurrect.window_state.restore_window(win:mux_window(), state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        elseif type == 'tab' then
          resurrect.tab_state.restore_tab(pane:tab(), state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        end
      end)
    end),
  },
}

---------------------------------------------------------------------------
-- Status bar (matching tmux status bar)
-- Left:  bold session/workspace name (like tmux #S)
-- Right: date/time (like tmux %a %d %b %Y :: %l:%M %p)
---------------------------------------------------------------------------
wezterm.on('update-status', function(window, pane)
  if not _startup_restore_done then
    local mf = io.open('/tmp/wezterm-fresh-mux', 'r')
    if mf then
      _startup_restore_done = true
      local t = tonumber(mf:read '*l')
      mf:close()
      os.remove('/tmp/wezterm-fresh-mux')
      if t and (os.time() - t) < 30 then
        local state_dir = resurrect.state_manager.save_state_dir
        local sf = io.open(state_dir .. 'current_state', 'r')
        if sf then
          local name = sf:read '*l'
          local type_str = sf:read '*l'
          sf:close()
          if type_str == 'workspace' then
            local ok, state = pcall(resurrect.state_manager.load_state, name, type_str)
            if ok and state then
              resurrect.workspace_state.restore_workspace(state, {
                window = window:mux_window(),
                close_open_tabs = true,
                close_open_panes = true,
                spawn_in_workspace = true,
                relative = true,
                restore_text = true,
                on_pane_restore = resurrect.tab_state.default_on_pane_restore,
              })
              wezterm.mux.set_active_workspace(name)
            end
          end
        end
      end
    elseif (os.time() - _startup_time) > 30 then
      _startup_restore_done = true
    end
  end

  local workspace = window:active_workspace()

  local date = wezterm.strftime '%a %d %b %Y :: %l:%M %p'

  window:set_left_status(wezterm.format {
    { Background = { Color = '#d7d7d7' } },
    { Foreground = { Color = '#000000' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' ' .. workspace .. ' ' },
    { Background = { Color = '#1c1c1c' } },
    { Foreground = { Color = '#d7d7d7' } },
    { Text = ' ' },
  })

  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#ffff00' } },
    { Text = date .. ' ' },
  })
end)

---------------------------------------------------------------------------
-- Tab title: show cwd basename (like tmux automatic-rename with pane_current_path)
---------------------------------------------------------------------------
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local pane = tab.active_pane
  local cwd = pane.current_working_dir
  local title = pane.title

  if cwd then
    local path = cwd.file_path or tostring(cwd)
    title = path:match '([^/]+)/?$' or path
  end

  local index = tab.tab_index + 1
  return ' ' .. index .. ': ' .. (title or '') .. ' '
end)

return config
