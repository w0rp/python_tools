if exists('g:loaded_python_tools')
    finish
endif

let g:loaded_python_tools = 1

" <Plug> mappings for functions
nnoremap <silent> <Plug>(python_tools_pytest_class)
\   :call python_tools#pytest#RunPytestOnClassAtCursor(0)<Return>
nnoremap <silent> <Plug>(python_tools_pytest_class_reuse_db)
\   :call python_tools#pytest#RunPytestOnClassAtCursor(1)<Return>
nnoremap <silent> <Plug>(python_tools_pytest_function)
\   :call python_tools#pytest#RunPytestOnFunctionAtCursor(0)<Return>
nnoremap <silent> <Plug>(python_tools_pytest_function_reuse_db)
\   :call python_tools#pytest#RunPytestOnFunctionAtCursor(1)<Return>
