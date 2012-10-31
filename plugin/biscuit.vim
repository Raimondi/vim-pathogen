let b:disabled = []
let b:enabled = []

function! BiscuitStamp(script)
  " enable all non-pinned plugins
  %s/^\s*-\s*/ /e
  " disable & test
  exe b:disabled[0] . ',' . b:disabled[1] . "s/^ /-/e"
  silent write
  silent! exe "!vim -c 'so " . fnameescape(a:script) . "'"
endfunction

function! Biscuit(script)
  " TODO: back up ~/.vim/bundled_plugins
  edit ~/.vim/bundled_plugins
  silent g/:$/d
  let b:enabled = [1, line('$') / 2]
  let b:disabled = [(line('$') / 2) + 1, line('$')]
  call BiscuitStamp(a:script)

  " TODO: might need a better loop termination condition
  while b:enabled[0] != b:enabled[1]
    " halve the enabled range depending on v:shell_error
    if v:shell_error == 0
      let range = b:disabled
    else
      let range = b:enabled
    endif
    let half = range[0] + (range[1] - range[0]) / 2
    let b:enabled = [range[0], half]
    let b:disabled = [half + 1, range[1]]
    call BiscuitStamp(a:script)
  endwhile
endfunction
