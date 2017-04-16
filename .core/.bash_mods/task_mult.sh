function taskm() {
    read input
    while [[ ! -z $input ]]; do
        task add $@ $input
        read input
    done
}
