mkdir deb
for u in $(cat urllist);
  #Download only if server has newer version
  do wget -NP deb/ $u
done
sudo dpkg -i deb/*.deb
sudo apt-get install -f