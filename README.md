# ensure-git-repos

Shell script that checks whether a directory contains only Git repositories.

It will highlight plain files and directories to help you identify things you
may have forgotten to put under version control.



## Usage

```
ensure-git-repos [OPTION]... [DIR]

Options:
  -d, --depth     maximum depth (defaults to 2)
  -h, --help      show this help, then exit
  --no-color      disable colors
  -v, --version   print the version
```



## Installation

With curl:

```
curl -sSLo /usr/local/bin/ensure-git-repos \
  https://raw.githubusercontent.com/AlphaHydrae/ensure-git-repos/v1.0.0/ensure-git-repos.sh && \
  chmod +x /usr/local/bin/ensure-git-repos
```

With wget:

```
wget -O /usr/local/bin/ensure-git-repos \
  https://raw.githubusercontent.com/AlphaHydrae/ensure-git-repos/v1.0.0/ensure-git-repos.sh && \
  chmod +x /usr/local/bin/ensure-git-repos
```
