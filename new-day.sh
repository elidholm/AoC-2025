#!/usr/bin/env bash

DAY=$1

if [[ -z $DAY ]]; then
  echo "Error: Missing required argument <day>" >&2
  echo "Usage: ${0##*/} <day>"
  exit 1
fi

if ! [[ $DAY =~ ^[0-9]+$ ]] || ((DAY < 1)) || ((DAY > 25)); then
  echo "Error: Day must be a number between 1 and 25" >&2
  exit 1
fi

mkdir -p "day$DAY"

touch "day$DAY"/{pt1,pt2,input.txt,example.txt}

for f in day$DAY/{pt1,pt2}; do
  chmod +x "$f"
  echo "#!/usr/bin/env bash" > "$f"
done
