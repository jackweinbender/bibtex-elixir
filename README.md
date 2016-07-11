# Bibtex

A pure Elixir BibTeX parser. Please note, this is a work in progress. PR's welcomed.

### TODO:

- [ ] Better handling of comments
- [ ] More robust syntax errors
- [ ] Recursive `key: value` parsing (currently uses regex on "="; not good)
- [ ] Option for stripping/simplifying/keeping braces
- [ ] Better handling of escaped chars
- [ ] Add encoder
- [ ] Use `:attrs` for all attributes (other than `:entry_type` and `:citekey`)
