for p in $(cat ppalist);
  do sudo add-apt-repository ppa:$p
done

sudo apt-get update
sudo apt-get install -y $(cat pkglist)

sudo apt-get -y upgrade
sudo apt-get -y autoremove
