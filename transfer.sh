#!/usr/bin/env bash

# Define includes directory
incd="$(pwd)/inc"

# Include helper functions
source "$incd/helpers.sh"

# Make sure dependencies have been installed
if ! command -v evernote2md &> /dev/null || ! command -v sncli &> /dev/null; then
    source "$incd/install.sh"
fi

# Set export directory from user input as arg
export_directory="$1"
if [ ! -d "$1" ]; then
    echo "usage: transfer.sh export_directory"
    exit
fi

temp_snclirc=false
# Make sure .snclirc file exists with username and password - otherwise, create temp file
if [ ! -f ~/.snclirc ];
then
    echo "No .snclirc file detected in home directory!"
    temp_snclirc=true
    create_sncli_config
    add_sncli_config
fi

# Glob all files in exports directory - should be directories
notebook_export_directories="$export_directory/*"
echo "Finding notebooks:"
for notebook_export_directory in $notebook_export_directories;
do
    # Test to make sure it's a directory
    if [ -d "$notebook_export_directory" ];
    then
        echo "$notebook_export_directory"
        echo "...Importing notebook $notebook_export_directory"
        tag="$(directory_to_tag "$notebook_export_directory")"
        echo "...Tagging for Simplenote: $tag"
        # Create .md versions of files in the export directories
        echo "...Converting .enex files to .md files"
        evernote2md "$notebook_export_directory/*.enex" "$notebook_export_directory"
        markdown_files="$notebook_export_directory/*.md"
        # Loop through each new markdown file in the notebook folder
        for markdown_file in $markdown_files;
        do
            echo "...Importing note $markdown_file";
            # Format json for import to Simplenote, using directory name as tag and markdown as content
            json="{\"tags\":[\"$tag\"],\"content\":$(json_escape "$(cat "$markdown_file")")}"
            # Echo tag and markdown as JSON into sncli as stdin
            echo "$json" | sncli import -
        done
    fi
done

# If we added a temp config file, remove so as not to clutter
if [ "$temp_snclirc" = true ];
then
    remove_sncli_config
fi
