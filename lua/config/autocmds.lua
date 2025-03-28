-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

-- fix autoindent for asm
vim.api.nvim_create_autocmd("FileType", {
	pattern = "asm",
	callback = function()
		vim.bo.indentexpr = "GetNasmIndent()" -- Custom indent function
		vim.bo.autoindent = false -- Disable default autoindent
		vim.bo.smartindent = false -- No smart indent
		vim.bo.cindent = false -- No C-style indent
		vim.bo.tabstop = 4 -- 4-space tabs
		vim.bo.shiftwidth = 4 -- Match tabstop
		vim.bo.expandtab = false -- Use tabs, not spaces

		-- Define the custom indent function using nvim_exec2
		vim.api.nvim_exec2(
			[[
      function! GetNasmIndent()
        let lnum = prevnonblank(v:lnum - 1)  " Get previous non-blank line
        if lnum == 0                         " First line, no indent
          return 0
        endif
        let prev_line = getline(lnum)        " Get text of previous line
        if prev_line =~ ':\s*$'              " Ends with colon + optional whitespace
          return &shiftwidth                 " Indent one level (4 spaces)
        endif
        return indent(lnum)                  " Otherwise, keep previous indent
      endfunction
    ]],
			{ output = false }
		)
	end,
})
