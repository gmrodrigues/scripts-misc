sudo find $(pwd) -maxdepth 2 -type f -perm /a+x -exec ln -sf {} /usr/local/bin \;
