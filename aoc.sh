#!/usr/bin/env bash
# Advent of Code CLI runner

set -euo pipefail

# Function to display usage
usage() {
    cat << EOF
Usage: $0 <day> <part> [--example]

Arguments:
    day     Day number (e.g., 1, 2, 3...)
    part    Part number (1 or 2)
    
Options:
    --example    Use example.txt instead of input.txt

Examples:
    $0 1 1              # Run day 1, part 1 with real input
    $0 1 2 --example    # Run day 1, part 2 with example input
EOF
    exit 1
}

# Check minimum number of arguments
if [[ $# -lt 2 ]]; then
    echo "Error: Missing required arguments" >&2
    usage
fi

# Parse arguments
DAY="$1"
PART="$2"
USE_EXAMPLE=false

# Check for --example flag
if [[ $# -ge 3 ]] && [[ "$3" == "--example" ]]; then
    USE_EXAMPLE=true
fi

# Validate day and part
if ! [[ "$DAY" =~ ^[0-9]+$ ]] || [[ "$DAY" -lt 1 ]] || [[ "$DAY" -gt 25 ]]; then
    echo "Error: Day must be a number between 1 and 25" >&2
    usage
fi

if ! [[ "$PART" =~ ^[12]$ ]]; then
    echo "Error: Part must be 1 or 2" >&2
    usage
fi

# Construct paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAY_DIR="$SCRIPT_DIR/day$DAY"
PART_SCRIPT="$DAY_DIR/pt$PART"

# Select input file
if [[ "$USE_EXAMPLE" == true ]]; then
    INPUT_FILE="$DAY_DIR/example.txt"
else
    INPUT_FILE="$DAY_DIR/input.txt"
fi

# Check if day directory exists
if [[ ! -d "$DAY_DIR" ]]; then
    echo "Error: Day $DAY directory not found at $DAY_DIR" >&2
    exit 1
fi

# Check if part script exists
if [[ ! -f "$PART_SCRIPT" ]]; then
    echo "Error: Part $PART script not found at $PART_SCRIPT" >&2
    exit 1
fi

# Check if part script is executable
if [[ ! -x "$PART_SCRIPT" ]]; then
    echo "Error: Part $PART script is not executable" >&2
    exit 1
fi

# Check if input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file not found at $INPUT_FILE" >&2
    exit 1
fi

# Run the script
echo "Running Day $DAY, Part $PART with $(basename "$INPUT_FILE")..."
echo "---"

# Change to the day directory and run the script with the input file
cd "$DAY_DIR"
"$PART_SCRIPT" "$INPUT_FILE"
