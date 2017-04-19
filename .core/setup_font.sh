cd
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
fc-cache -vf
xrdb -merge .Xresources
