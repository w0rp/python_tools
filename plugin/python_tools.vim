if exists('g:loaded_python_tools')
    finish
endif

let g:loaded_python_tools = 1

" <Plug> mappings for functions
nnoremap <silent> <Plug>(python_tools_run_pytest_on_class_at_cursor)
\   :call python_tools#pytest#RunPytestOnClassAtCursor()<Return>
nnoremap <silent> <Plug>(python_tools_run_pytest_on_function_at_cursor)
\   :call python_tools#pytest#RunPytestOnFunctionAtCursor()<Return>
