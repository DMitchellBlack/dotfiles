# dotfiles

Just some dotfiles for DMitchellBlack

## Inspirations

- https://www.atlassian.com/git/tutorials/dotfiles
- https://medium.com/@simontoth/best-way-to-manage-your-dotfiles-2c45bb280049

## Cloning Instructions

- Ensure git is installed
- `$ git clone --bare https://github.com/DMitchellBlack/dotfiles.git $HOME/dotfiles`
  - Clone `DMitchellBlack/dotfiles` to `$HOME/dotfiles` as a bare repository.
- `$ /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no`
  - Prevent untracked files from showing up in `git-status`
- `$ /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME checkout`
  - Checkout the repo!

## Tips / tricks

- The included `.zsh_aliases` includes `git-dotfiles`, which is an alias for
  `/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME`. This allows usage
  of `$ git-dotfiles` in the same way as `$ git`!
