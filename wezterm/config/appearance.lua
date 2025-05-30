local gpu_adapters = require('utils.gpu-adapter')
local wezterm = require('wezterm')

local custom = wezterm.color.get_builtin_schemes()['Tokyo Night']
custom.background = '#1B1E20'

return {
   max_fps = 120,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
   underline_thickness = '1.2pt',

   -- cursor
   animation_fps = 120,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',

   --  SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar,BlinkingBar.
   default_cursor_style = 'BlinkingBar',
   cursor_blink_rate = 650,

   -- color scheme
   -- color_scheme = 'Catppuccin Mocha',
   color_schemes = {
      ['Tokyo'] = custom,
   },
   color_scheme = 'Tokyo',

   -- color_scheme = 'Tokyo Night',
   -- scrollbar
   enable_scroll_bar = false,
   -- tab bar
   enable_tab_bar = false,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   tab_max_width = 25,
   -- show_tab_index_in_tab_bar = false,
   -- switch_to_last_active_tab_when_closing_tab = true,

   -- window
   window_background_opacity = 1,
   window_padding = {
      left = 10,
      right = 10,
      top = 10,
      bottom = 10,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_content_alignment = {
      horizontal = 'Center',
      vertical = 'Center',
   },

   visual_bell = {
      fade_in_function = 'EaseIn',
      fade_in_duration_ms = 250,
      fade_out_function = 'EaseOut',
      fade_out_duration_ms = 250,
      target = 'CursorColor',
   },
}
