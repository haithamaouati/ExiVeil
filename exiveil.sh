#!/bin/bash

# Author: Haitham Aouati
# GitHub: github.com/haithamaouati

# Colors
nc="\e[0m"
bold="\e[1m"
underline="\e[4m"
bold_red="\e[1;31m"
bold_green="\e[1;32m"
bold_yellow="\e[1;33m"

banner() {
clear
ascii_art="
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⡏⠀⠹⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣻
⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠘⢦⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢠⡇⢰⣷⣤⣤⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣟⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⡿⠀⢸⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⣿⣿⣿⣿⣿⣦⡀⠀⢳⣄⠀⠀⠀⠀⠀⠹
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⡄⠀⣻⣷⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠃⠀⣿⣿⠁⠀⠀⢀⣼
"
echo -e "${bold_green}$ascii_art${nc}"
echo -e "${bold_green}ExiVeil${nc} — EXIF metadata viewer.\n"
echo -e " Author: Haitham Aouati"
echo -e " GitHub: ${underline}github.com/haithamaouati${nc}\n"
}

usage() {
  banner
  echo "Usage: $0 -f <image_file>"
  echo "Flags:"
  echo "  -f, --file    Path to the image file"
  echo -e "  -h, --help    Show this help message\n"
  exit 1
}

check_deps() {
  if ! command -v exiv2 >/dev/null 2>&1; then
    echo -e "${bold_red}[!]${nc} Missing dependency: exiv2"
    exit 2
  fi
}

pretty_print() {
  local file="$1"
  banner
  echo -e "[*] Reading metadata from: $file"
  echo

  exiv2 -pt "$file" | while read -r tag type count rest; do
    # Clean tag name: strip 'Exif.' and convert dots to spaces
    clean_tag=$(echo "$tag" | sed 's/^Exif\.//' | sed 's/\./ /g')

    # Skip empty or unreadable lines
    [[ -z "$clean_tag" || -z "$rest" ]] && continue

    # Trim leading whitespace in 'rest'
    clean_rest=$(echo "$rest" | sed 's/^[[:space:]]*//')

    # Print formatted output
    echo -e "$clean_tag: ${bold}$count  ${bold_green}$clean_rest${nc}"
  done
}

[[ $# -eq 0 ]] && usage

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file)
      FILE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo -e "${bold_red}[!]${nc} Unknown option: ${bold_red}$1${nc}"
      usage
      ;;
  esac
done

check_deps
[[ -f "$FILE" ]] || { echo -e "${bold_red}[!]${nc} File not found: $FILE"; exit 3; }

pretty_print "$FILE"
