#Vim Flinger

This plugin aims to allow you to quickly navigate through a list of files (and
optionally line numbers in those files)

##Installation
1.  If you use [Vundle](https://github.com/gmarik/Vundle.vim) add the following
    line to your `.vimrc`:  
    ```
    Bundle 'aclindsa/vim-flinger'
    ```  
    Then run:  
    ```
    :BundleInstall
    ```
2.  If you use [Pathogen](https://github.com/tpope/vim-pathogen) run the
    following commands:
    ```
    cd ~/.vim/bundle/ && git clone git://github.com/aclindsa/vim-flinger
    ```
3.  You can also manually install it by copying the contents of plugin/ and doc/
    in the repository to ~/.vim/plugin and ~/.vim/doc

##Usage

If you currently have a buffer open in Vim with a list of file names, one per
line, run `:StartFlinger` to transition into flinger mode. This will open a new
buffer containing the file on the current line in the original buffer and
optionally move the cursor to the line number specified on that line if such a
line number exists on the line on the original buffer.

For example, if you are in a buffer and your cursor is on a line which contains
```
/etc/fstab 10
```
running `:StartFlinger` will open `/etc/fstab` in a new buffer and move the
cursor to line 10.

The `:StartFlinger` command also introduces several new key bindings, which can
be configured (see Configuration section below). The defaults are that `,f`
exits flinger mode and returns to the buffer containing the file names, `,j`
opens the file on the next line in the buffer with file names, and `,k` opens
the previous file. `,j` and `,k` (or whatever you change them to) can both be
prefixed by the number of times to perform that action. To skip 10 files
forward, do `10,j`.

##Configuration

The following settings allow you to customize the keys which control the
operation of flinger once `:StartFlinger` has been called. These should all be
set in your .vimrc file. The examples below contain the default mappings for
these actions.

To change the mapping to navigate to the file on the next line in the original
buffer:
```
:let g:flinger_next_file = ",j"
```

To change the mapping to navigate to the file on the previous line in the
original buffer:
```
:let g:flinger_previous_file = ",k"
```

To change the mapping to exit flinger mode and return to the buffer which was
active when `:StartFlinger` was called:
```
:let g:flinger_deactivate = ",f"
```

I also find typing `:StartFlinger` cumbersome, so I map a shortcut to it as
well in my .vimrc:
```
nnoremap ,f :StartFlinger<CR>
```
