# Auto config for barroit

### How to use

run `./init` to create the corresponding file symlinks

### Quick update config

```bash
echo "export CONFIG="$(pwd)/src"" >> ~/.profile
source ~/.profile
ls -al $CONFIG
```

### Init onedrive

```bash
sudo apt update
sudo apt install rclone
rclone config # create a remote named "onedrive"
~/onedrive mount
```

### Working with Passkeeper

```bash
cd ~
git clone https://github.com/barroit/PassKeeper.git
cd PassKeeper
./build-penguin
sudo cp build/penguin/pk /usr/local/bin/pk
echo 'export ONEDRIVE="${HOME}"' >> ~/.profile
source ~/.profile
```
