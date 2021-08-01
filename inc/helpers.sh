# Echoes a directory name - assumed notebook - which is tag formatted
directory_to_tag() {
    dirname_basename="$(basename "$1")" 
    tag_name="$(echo $dirname_basename | sed 's/ /_/g' | sed 's/,//g')"
    echo -n "$tag_name"
}
# Echoes a json escaped string
json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}
create_sncli_config() {
    echo "Please enter your Simplenote login:"
    read -p "Username: " username
    read -p "Password: " password
    cat <<EOF > .snclirc
[sncli]
cfg_sn_username = $username
cfg_sn_password = $password
EOF

    echo "...Created new .snclirc file!"
}
add_sncli_config() {
    echo "...Moving new .snclirc file to home directory"
    mv .snclirc ~/.snclirc 2>/dev/null
}
remove_sncli_config() {
    echo "...Removing the temporary .snclirc file"
    rm -rf ~/.snclirc
}
sncli_trash_all() {
    echo "...Syncing with server"
    # Full server sync
    sncli sync
    echo "...Sync complete!"
    echo "...Trashing notes"
    # Trash all notes
    sncli list | awk '{print $1}' | while read key; do echo "...Trashing note: $key"; sncli -k"$key" trash; echo "...Syncing";  sncli sync; done
}
sncli_markdown_all() {
    echo "...Syncing with server"
    # Full server sync
    sncli sync
    echo "...Sync complete!"
    echo "...Enabling markdown on notes"
    # Enable markdown on all notes
    sncli list | awk '{print $1}' | while read key; do echo "...Enabling markdown for note: $key"; sncli -k"$key" markdown; echo "...Syncing"; sncli sync; done
}
# Generates space separated tags from directory names
get_directory_tag_names() {
    export_directory="$1"
    notebook_export_directories=("$export_directory"/*)
    tags=()
    for notebook_export_directory in "${notebook_export_directories[@]}";
    do
        # Test to make sure it's a directory (not default empty glob)
        [ -d "$notebook_export_directory" ] || continue
        tag="$(directory_to_tag "$notebook_export_directory")"
        tags+=("$tag")
    done
    for tag in "${tags[@]}"; do echo "$tag"; done | sort | uniq | while read tag; do echo -n " $tag"; done
}
# This does not work - but it's a nice thought
evernote_export() {
    # Set up project folder structure
    mkdir -p "$ES_EXPORT_DIRECTORY"
    echo "...Creating export directory: $ES_EXPORT_DIRECTORY"

    # Export Evernote as .enex, creating new directories and grouping by notebook
    echo "...Running Evernote export"
    # exporteer_evernote_osx export -E -n "$ES_EXPORT_DIRECTORY"
    # Loop through each folder in the exports directory (grouped by notebook)
}
