local lazydev_ok, lazydev = pcall(require, "lazydev")

if lazydev_ok then
  lazydev.setup(
    {
      library = {
        "lazy.nvim",
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "LazyVim",
      },
    }
  )
end
