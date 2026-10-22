#!/bin/bash

# GNOME custom shortcuts for zk notes. Safe to re-run.

set -e

NOTES_DIR="$HOME/git_strawberry/notes"
SCHEMA=org.gnome.settings-daemon.plugins.media-keys
BASE=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

add_shortcut() {
    local id=$1 name=$2 binding=$3 command=$4
    local path="$BASE/$id/"
    local list
    list=$(gsettings get "$SCHEMA" custom-keybindings)

    # Append to the list of custom shortcuts, keeping any existing ones
    if [[ $list != *"'$path'"* ]]; then
        if [[ $list == "@as []" || $list == "[]" ]]; then
            list="['$path']"
        else
            list="${list%]}, '$path']"
        fi
        gsettings set "$SCHEMA" custom-keybindings "$list"
    fi

    gsettings set "$SCHEMA.custom-keybinding:$path" name "$name"
    gsettings set "$SCHEMA.custom-keybinding:$path" binding "$binding"
    gsettings set "$SCHEMA.custom-keybinding:$path" command "$command"
}

add_shortcut notes-new "Daily note" "<Super><Alt>n" \
    "ptyxis --new-window -- $HOME/.local/bin/zk new $NOTES_DIR/daily --no-input --notebook-dir $NOTES_DIR"

add_shortcut notes-find "Find notes" "<Super><Shift>n" \
    "ptyxis --new-window -- $HOME/.local/bin/zk edit --interactive --notebook-dir $NOTES_DIR"
