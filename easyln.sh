#! /bin/bash
for f in $(find $1 -type f -not -path "$1/_root/*");
do
    dn=$(dirname $f)
    dn=${dn#$1}
    read -p "Link $f to ~/$dn? [y/n/Q]: " -N1 -d '' ans
    echo
    if [ "$ans" = 'y' ]; then
	mkdir -p ~/$dn
	ln -sf "$(pwd)/$f" ~/$dn
    elif [ "$ans" != 'n' ]; then
	exit 0
    fi
done

