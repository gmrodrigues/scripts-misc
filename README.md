# linux-desktop-icon-creator

- Shell script to create menu/desktop icons out from a executable file and icon image
- Usefull when you use software bundled as a tarball that does not provide means to create an icon so you don't need to type bin/whatever on terminal before using it
- Tested on ubuntu and mint

## Example

```Shell
bash add-desktop-icon.sh                      \
  ./pycharm-community-2018.1.3/bin/pycharm.sh \
  "Pycharm"                                   \
  ./pycharm-community-2018.1.3/bin/pycharm.png
```

