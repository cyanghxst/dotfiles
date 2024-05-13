" Better up/down
nmap j gj
nmap k gk

" Clear highlight search
nmap <CR> :nohl

" Yank to system clipboard
set clipboard=unnamed

" Jump to link in Lightspeed mode plugin
exmap jumpToLink obcommand mrj-jump-to-link:activate-lightspeed-jump
nmap s :jumpToLink
