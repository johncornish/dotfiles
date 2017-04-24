#!/usr/bin/env zsh

callpath=${0:a:h}

function do_sync() {
	#Optionally pass profile directory names to be synced
	for profile in .core $@; do
		rsync -avhrP --no-perms $callpath/$profile/ ~;
	done
	source ~/.zshrc;
}

do_sync $@;
unset do_sync;
