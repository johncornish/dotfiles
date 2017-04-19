function taskint() {
  ui="task $@"
  input=''
  while [[ $input != 'q' ]]; do
    clear
    $ui
    read input
    [ "$input" != 'q' ] && task $input
  done
}

function taskm() {
  read input
  while [[ ! -z $input ]]; do
    task add $@ $input
    read input
  done
}

function taskfile() {
  op="task ${@:2}"
  if [ -f $1 ]; then
    while IFS= read -r t; do
      $op "$t"
    done < $1
  else
    echo "File does not exist"
  fi
}
