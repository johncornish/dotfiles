function mkproj() {
    templ_path="$HOME/project_templates"

    [[ $# == 0 ]] && templ="cpp" || templ=$1

    if [[ -d $templ_path/$templ ]]; then
        cp -r $templ_path/$templ/* ./
    else
        echo "Template $1 does not exist."
    fi
}
