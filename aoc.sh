#!/usr/bin/env bash
# Advent of Code CLI runner

print_usage() {
    cat << EOF
Usage: ${0##*/} <day> <part> [--example]

Arguments:
    day     Day number (e.g., 1, 2, 3...)
    part    Part number (1 or 2)

Options:
    --example    Use example.txt instead of input.txt

Examples:
    ${0##*/} 1 1              # Run day 1, part 1 with real input
    ${0##*/} 1 2 --example    # Run day 1, part 2 with example input
EOF
}

fatal() {
  local msg=$1
  echo "Error: $msg" >&2
  print_usage
  exit 1
}

if (($# < 2)); then
  fatal 'Missing required arguments <day> and <part>'
fi

DAY=$1
PART=$2
USE_EXAMPLE=false

if (($# >= 3)) && [[ $3 == '--example' ]]; then
  USE_EXAMPLE=true
fi

if ! [[ $DAY =~ ^[0-9]+$ ]] || ((DAY < 1)) || ((DAY > 25)); then
  fatal 'Day must be a number between 1 and 25'
fi

if ! [[ $PART =~ ^[12]$ ]]; then
  fatal 'Part must be 1 or 2'
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAY_DIR="$SCRIPT_DIR/day$DAY"
PART_SCRIPT="$DAY_DIR/pt$PART"

if [[ $USE_EXAMPLE == true ]]; then
  INPUT_FILE="$DAY_DIR/example.txt"
else
  INPUT_FILE="$DAY_DIR/input.txt"
fi

if [[ ! -d $DAY_DIR ]]; then
  fatal "Day $DAY directory not found at $DAY_DIR"
fi

if [[ ! -f $PART_SCRIPT ]]; then
  fatal "Part $PART script not found at $PART_SCRIPT"
fi

if [[ ! -x $PART_SCRIPT ]]; then
  fatal "Part $PART script is not executable"
fi

if [[ ! -f $INPUT_FILE ]]; then
  fatal "Input file not found at $INPUT_FILE"
fi

echo "Running Day $DAY, Part $PART with ${INPUT_FILE##*/}..."
echo -e '---\n'

pushd "$DAY_DIR" &>/dev/null || fatal "Failed to change directory to $DAY_DIR"
time "$PART_SCRIPT" "$INPUT_FILE"
popd &>/dev/null || fatal 'Failed to return to original directory'
