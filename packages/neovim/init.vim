set autowrite
set ignorecase
set smartcase
set title

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

syntax on

" Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
map <ScrollWheelUp> <C-Y>
imap <ScrollWheelUp> <C-X><C-Y>
map <ScrollWheelDown> <C-E>
imap <ScrollWheelDown> <C-X><C-E>
