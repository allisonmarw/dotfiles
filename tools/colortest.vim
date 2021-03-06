" Source: http://emerg3nc3.wordpress.com/2012/07/28/full-256-color-support-for-vim-andor-xterm-on-ubuntu-12-04/
" 
" Color test: Save this file, then enter ':so %'
" Then enter the following commands:
"   :VimColorTest    "(for console/terminal Vim)
function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(136, a:fgend)
    for bg in range(a:bgend)
      let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
    endfor
  endfor
  call put(result)
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 256, 256)



