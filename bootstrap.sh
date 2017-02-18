#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function do_sync() {
	#Optionally pass profile directory names to be synced
	for profile in .core $@; do
		rsync --exclude ".git/" \
			--exclude "bootstrap.sh" \
			--exclude "README.md" \
			--exclude "LICENSE.md" \
			-avhP --no-perms $profile ~;
	done
	source ~/.bashrc;
}

do_sync;
unset do_sync;