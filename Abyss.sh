#!/bin/sh
printf '\033c\033]0;%s\a' Abyss
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Abyss.x86_64" "$@"
