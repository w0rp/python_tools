" Author: w0rp <devw0rp@gmail.com>
" Description: This module provides some means of running py.text on files
"   we are editing.

function! python_tools#pytest#RunPytest(arguments) abort
    let l:pytest_executable = findfile('ve/bin/py.test', ',;')

    let l:command = l:pytest_executable

    if get(g:, 'python_tools_pytest_no_migrations')
        let l:command .= ' --nomigrations'
    endif

    let l:command = l:command . ' --reuse-db ' . a:arguments
    let l:project_dir = finddir('.git', '.;')

    " Switch to the project directory for the command if we can.
    if !empty(l:project_dir)
        let l:command = 'cd ' . fnameescape(l:project_dir) . ' && ' . l:command
    endif

    if has('win32')
        let l:command = 'cmd /c ' . l:command
    else
        let l:command = split(&shell) + split(&shellcmdflag) + [l:command]
    endif

    :new +set\ filetype=pytest
    let l:buffer = bufnr('%')

    let b:job = job_start(l:command, {
    \   'out_io': 'buffer',
    \   'out_buf': l:buffer,
    \   'err_io': 'buffer',
    \   'err_buf': l:buffer,
    \})

    autocmd BufUnload <buffer> call job_stop(b:job)
endfunction

function! python_tools#pytest#RunPytestOnFile(filename)
    call python_tools#pytest#RunPytest(fnameescape(a:filename))
endfunction

function! python_tools#pytest#RunPytestOnClass(filename, class)
    call python_tools#pytest#RunPytest(fnameescape(a:filename) . '::' . a:class)
endfunction

function! python_tools#pytest#RunPytestOnFunction(filename, class, def)
    let l:command = fnameescape(a:filename)

    if !empty(a:class)
        let l:command .= '::' . a:class
    endif

    call python_tools#pytest#RunPytest(l:command . '::' . a:def)
endfunction

function! python_tools#pytest#RunPytestOnClassAtCursor() abort
    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.class)
        call python_tools#pytest#RunPytestOnClass(expand('%:p'), l:info.class)
    else
        echoerr 'No class found at cursor!'
    endif
endfunction

function! python_tools#pytest#RunPytestOnFunctionAtCursor() abort
    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.def)
        let l:filename = expand('%:p')

        call python_tools#pytest#RunPytestOnFunction
        \   (expand('%:p'),
        \   l:info.class,
        \   l:info.def
        \)
    else
        echoerr 'No function found at cursor!'
    endif
endfunction
