Rusty Phillips' dotfiles.  
Built in config for git, nvim, tmux, and zsh. 

To use:
On Ubuntu, just run ./install-all.sh to get everything.

Otherwise, run each of the individual scripts to get as much setup as you can.

New Automatic Stuff:
As much as is possible is installed automatically via zinit.
Specifically, installs sdkman, powerlevel 10K, and a number of autocompletions that I use frequently.

The design is built around using sdkman.  Unfortunately, I have yet to find a way to install maven and java automatically; those will need to be manually installed via
```source ./sdkman.sh```

from within the zsh shell.
