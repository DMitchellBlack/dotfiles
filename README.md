# dotfiles

Just some dotfiles for DMitchellBlack

## Inspirations

- https://dotfiles.github.io

## Setup

- Ensure that `~/.config` exists
  - `mkdir -p ~/.config`
- Clone the repository
  - `mkdir -p ~/git`
  - `cd ~/git`
  - `jj git clone git@github.com:DMitchellBlack/dotfiles.git`

## Usage

- Dry run to check changes
  - `stow -n -v -t ~ .`
- Stow dotfiles
  - `stow -v -t ~ .`
- Re-stow (unstow and stow)
  - `stow -v -t -R ~ .`
