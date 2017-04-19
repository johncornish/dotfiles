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
