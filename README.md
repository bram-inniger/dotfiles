# Bram's dot-files

A collection of my own dot-files, mostly here for my own laziness and convenience to quickly provision a new environment.

## Getting started

Simply clone the repo and run the Perl script [sync.pl](sync.pl).

It will:
* Back-up existing files, appending the current timestamp
* Symlink the files under [/configuration](configuration) into their correct locations on disk

```bash
$ git clone https://github.com/bram-inniger/dotfiles.git
$ cd dotfiles
$ chmod +x sync.pl
$ ./sync.pl
```

## License

GNU GENERAL PUBLIC LICENSE version 3. See [LICENSE](LICENSE).

_Copyright (C) 2021 Bram Inniger_
