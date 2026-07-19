-- Prettify a hunk of JSON with <localleader>p
vim.keymap.set("n", "<localleader>p", "^vg_:!python -m json.tool<cr>", { buffer = true })
vim.keymap.set("v", "<localleader>p", ":!python -m json.tool<cr>", { buffer = true })
