local bacon_ok, bacon = pcall(require, "bacon")

if bacon_ok then
  bacon.setup({
    quickfix = {
      enabled = true,       -- Enable Quickfix integration
      event_trigger = true, -- Trigger QuickFixCmdPost after populating Quickfix list
    },
  })
end
