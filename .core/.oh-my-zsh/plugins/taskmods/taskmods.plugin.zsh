taskint() {
  input=''
  while [[ $input != 'q' ]]; do
    clear
    task $@
    read input
    [ "$input" != 'q' ] && /usr/bin/task $input
  done
}

taskm() {
  read input
  while [[ ! -z $input ]]; do
    task add $@ $input
    read input
  done
}

taskfile() {
  if [ -f $1 ]; then
    while IFS= read -r t; do
      [[ ! -z $t ]] && task ${@:2} "$t"
    done < $1
  else
    echo "File does not exist"
  fi
}
