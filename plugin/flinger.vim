" flinger.vim - Rapidly nagivate between filenames in a buffer
" Maintainer:   Aaron Lindsay http://aclindsay.com
" Version:      1.0
" Updates:      http://github.com/aclindsa/vim-flinger
"
" License:      You may redistribute this plugin under the same terms as Vim
"               itself.
"
" Usage:        :StartFlinger
"
" 		" To change the default mappings, set any of the following (the
" 		" defaults are shown here)
"		:let g:flinger_next_file = ",j"
"		:let g:flinger_previous_file = ",k"
"		:let g:flinger_deactivate = ",f"

function! <SID>FlingerTeardown()
	if exists("g:flinger_display_buffer")
		exe "bd! ".g:flinger_display_buffer
		unlet g:flinger_display_buffer
	endif
	unlet g:flinger_line
	unlet g:flinger_buffer
endfunction

function! <SID>FlingerSetup()
	if ! exists("g:flinger_buffer")
		let g:flinger_line = line(".")
		let g:flinger_buffer = bufnr('%')
		call <SID>UpdateFlinger()
	endif
endfunction

function! <SID>UpdateFlinger()
	if exists("g:flinger_buffer")
		" Make sure we're still in the buffer with the filenames
		exe "buffer ".g:flinger_buffer
		if g:flinger_line < 0 || g:flinger_line > line('$')
			echoerr "Line number ".g:flinger_line." doesn't exist in the current buffer"
			call <SID>FlingerTeardown()
			return
		endif

		"Set the buffer's line to point to the line of the buffer we're opening
		exe "".g:flinger_line

		"Get the filename and line number from that line
		let a:line_contents = split(getline(g:flinger_line))
		if len(a:line_contents) < 1
			echoerr "Line number ".g:flinger_line." doesn't contain a suitable filename"
			call <SID>FlingerTeardown()
			return
		endif

		"Open a buffer with that file (if it isn't already open)
		if exists("g:flinger_display_buffer")
			exe "buffer ".g:flinger_buffer
			if bufname("%") != a:line_contents[0]
				exe "bd! ".g:flinger_display_buffer
				exe "edit ".a:line_contents[0]
			endif
		else
			exe "edit ".a:line_contents[0]
		endif
		let g:flinger_display_buffer = bufnr('%')


		"Make sure we're on the right line number
		if len(a:line_contents) > 1
			exe ":".a:line_contents[1]
		endif

		"Setup buffer-specific key mappings
		if exists("g:flinger_next_file")
			exe "nmap <buffer> ".g:flinger_next_file." :<C-U>exe \"let g:flinger_line +=\".v:count1 <CR> :call <SID>UpdateFlinger() <CR>"
		else
			nmap <buffer> ,j :<C-U>exe "let g:flinger_line +=".v:count1 <CR> :call <SID>UpdateFlinger() <CR>
		endif
		if exists("g:flinger_previous_file")
			exe "nmap <buffer> ".g:flinger_previous_file." :<C-U>exe \"let g:flinger_line -=\".v:count1 <CR> :call <SID>UpdateFlinger() <CR>"
		else
			nmap <buffer> ,k :<C-U>exe "let g:flinger_line -=".v:count1 <CR> :call <SID>UpdateFlinger() <CR>
		endif
		if exists("g:flinger_deactivate")
			exe "nnoremap <buffer> ".g:flinger_deactivate." :call <SID>FlingerTeardown() <CR>"
		else
			nnoremap <buffer> ,f :call <SID>FlingerTeardown() <CR>
		endif
	endif
endfunction

command! -bar -nargs=0 StartFlinger call <SID>FlingerSetup()
