local live_server_ok, live_server = pcall(require, "live-server")

if live_server_ok then
  live_server.setup({
    build = 'pnpm add -g live-server',
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = true
  })
end
