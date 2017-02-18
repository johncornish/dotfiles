#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function do_sync() {
	rsync --exclude ".git/" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE.md" \
		-avhP --no-perms . ~;
	source ~/.bashrc;
}

do_sync;
unset do_sync;