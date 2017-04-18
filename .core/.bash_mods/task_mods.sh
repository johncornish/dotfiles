function taskint() {
    ui="task list $@"
    input=''
    while [[ $input != 'q' ]]; do
        clear
        $ui
        read input
        task $input
    done
}

function taskm() {
    read input
    while [[ ! -z $input ]]; do
        task add $@ $input
        read input
    done
}
