" Author: w0rp <devw0rp@gmail.com>
" Description: This module provides a function for printing information
"   about which Python classs and methdo we are looking at, etc.

function! python_tools#statusline#GetStatus() abort
    if &filetype !=# 'python'
        return ''
    endif

    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.class)
        if !empty(l:info.def)
            return l:info.class . '.' . l:info.def
        endif

        return l:info.class
    elseif !empty(l:info.def)
        return l:info.def
    endif

    return ''
endfunction
