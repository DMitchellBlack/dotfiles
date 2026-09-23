# Neovim config

## Installations

- Lua formatter: stylua
  - `$ brew install stylua`
  - NOTE: Additional configurations have been specified in the Conform setup.
- Prettier
  - `$ brew install prettier`
  - NOTE: `$ node` must be availble (can also install with homebrew).
- Java
  - `$ brew install google-java-format`
- SQL Formatter: sleek
  - `$ brew install sleek`
- Markdown formatter: `mdformat`
  - `$ brew install pipx` - `pipx` is used to install `mdformat`
  - `$ pipx ensurepath` - Ensure `pipx` install location is in PATH variable
  - `$ pipx install mdformat` - Install mdformat with CommonMark support
  - `$ pipx inject mdformat mdformat-gfm mdformat-frontmatter` - Inject plugins
    for GitHub Flavored Markdown (GFM) and Frontmatter support into mdformat.

## TODO

- [x] Make `K` hover window better looking/more distinct.
- [ ] Figure out how to use nvim lint in a way I like.
