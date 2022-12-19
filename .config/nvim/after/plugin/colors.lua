require('rose-pine').setup({
    disable_background = true
})

require('gruvbox').setup({
    contrast = "soft",
    italic = false,
})

function ColorMyPencils(color)
    color = color or "gruvbox"
    vim.cmd.colorscheme(color)

    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    if color == "gruvbox" then
        vim.o.background = "dark"
    end

end

ColorMyPencils()
