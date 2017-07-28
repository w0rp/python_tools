" Author: w0rp <devw0rp@gmail.com>
" Description: This module provides some means of running py.text on files
"   we are editing.

function! s:RunPytestCommand(command) abort
    let l:command = a:command

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

    " vint: -ProhibitAutocmdWithNoGroup
    autocmd BufUnload <buffer> call job_stop(b:job)
endfunction

function! python_tools#pytest#RunPytest(arguments, reuse_db) abort
    " Save the file first, if it has been modified.
    if &modified
        :w
    endif

    let l:pytest_executable = findfile('ve/bin/py.test', ',;')
    let l:pytest_file = findfile('pytest.ini', ',;')

    if !empty(l:pytest_file)
        " Use the directory which contains the pytest.ini file, if we find
        " that.
        let l:project_dir = fnamemodify(l:pytest_file, ':h')
    else
        " Use the root from git if we can't find the directory with the
        " pytest.ini file.
        let l:project_dir = finddir('.git', '.;')
    endif

    let l:command = l:pytest_executable . ' --tb=short'

    if get(g:, 'python_tools_pytest_verbose')
        let l:command .= ' -vv'
    endif

    if a:reuse_db
        let l:command .= ' --reuse-db'
    endif

    " Switch to the project directory for the command if we can.
    if !empty(l:project_dir)
        let l:command = 'cd ' . fnameescape(l:project_dir) . ' && ' . l:command
    endif

    let l:command .= ' ' . a:arguments

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

    " vint: -ProhibitAutocmdWithNoGroup
    autocmd BufUnload <buffer> call job_stop(b:job)
endfunction

function! python_tools#pytest#RunPytestOnFile(filename, reuse_db)
    call python_tools#pytest#RunPytest(fnameescape(a:filename), a:reuse_db)
endfunction

function! python_tools#pytest#RunPytestOnClass(filename, class, reuse_db)
    call python_tools#pytest#RunPytest(
    \   fnameescape(a:filename) . '::' . a:class,
    \   a:reuse_db
    \)
endfunction

function! python_tools#pytest#RunPytestOnFunction(filename, class, def, reuse_db)
    let l:command = fnameescape(a:filename)

    if !empty(a:class)
        let l:command .= '::' . a:class
    endif

    call python_tools#pytest#RunPytest(l:command . '::' . a:def, a:reuse_db)
endfunction

function! python_tools#pytest#RunPytestOnClassAtCursor(reuse_db) abort
    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.class)
        call python_tools#pytest#RunPytestOnClass(
        \   expand('%:p'),
        \   l:info.class,
        \   a:reuse_db
        \)
    else
        echoerr 'No class found at cursor!'
    endif
endfunction

function! python_tools#pytest#RunPytestOnFunctionAtCursor(reuse_db) abort
    let l:info = python_tools#cursor_info#GetInfo()

    if !empty(l:info.def)
        let l:filename = expand('%:p')

        call python_tools#pytest#RunPytestOnFunction
        \   (expand('%:p'),
        \   l:info.class,
        \   l:info.def,
        \   a:reuse_db
        \)
    else
        echoerr 'No function found at cursor!'
    endif
endfunction
