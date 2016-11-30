" Author: w0rp <devw0rp@gmail.com>
" Description: This module provides some extra functions for supporting the
"   rest of the plugin.

" Given a path, create a list containing each directory in the path.
function! python_tools#util#AllPaths(path)
    " TODO: Support Windows paths
    let l:components = split(a:path, '/')
    let l:result = []

    for l:part in l:components
        call add(
        \   l:result,
        \   '/' . join(l:components[0:len(l:result)], '/')
        \)
    endfor

    return l:result
endfunction

" Given a root path, search that path and all ancestor paths for a glob match.
function! python_tools#util#FindGlob(root, glob)
    return globpath(join(python_tools#util#AllPaths(a:root), ','), a:glob, 0, 1, 1)
endfunction
