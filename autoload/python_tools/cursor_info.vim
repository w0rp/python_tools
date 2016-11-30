" Author: w0rp <devw0rp@gmail.com>
" Description: This module provides a function for getting information about
"   Python symbols at the current cursor position.

" Search from the current cursor position, and return an object with
" the following information:
"
" class: The class name for the class the cusor is looking at.
" def: The function/method name for the function/method the cusor is looking at.
function! python_tools#cursor_info#GetInfo() abort
    let l:info = {
    \   'class': '',
    \   'def': '',
    \}

    let l:class_line = search('^class ', 'bnW')
    let l:class_name = ''
    let l:def_line = search('^\(\|    \|\t\)def ', 'bnW')
    let l:def_name = ''

    if l:class_line
        let l:info.class = substitute(
        \   getline(l:class_line),
        \   'class \([a-zA-Z0-9]\+\).*',
        \   '\1',
        \   ''
        \)
    endif

    if l:def_line && (!l:class_line || l:def_line > l:class_line)
        let l:info.def = substitute(
        \   getline(l:def_line),
        \   '.*def \([a-zA-Z0-9_]\+\).*',
        \   '\1',
        \   ''
        \)
    endif

    return l:info
endfunction

function! python_tools#cursor_info#GenerateSuperCall() abort
    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.class) && !empty(l:info.def)
        return printf('super(%s, self).%s', l:info.class, l:info.def)
    endif

    throw 'Could not determine the super class!'
endfunction
