if [ -z "$1" ]
  then
    echo "No day supplied"
    exit 1
fi

CURRENT_DAY=$1

# nodejs
JS_FILE=nodejs/days/$CURRENT_DAY/index.js
if [ ! -f "$JS_FILE" ]; then
  echo "Creating $JS_FILE..."
  mkdir nodejs/days/$CURRENT_DAY
  cp index.tpl.js $JS_FILE
  sed -i '' "s/__DAY__/$CURRENT_DAY/" $JS_FILE
  git add $JS_FILE
fi

# elixir
EXS_FILE=elixir/day_$CURRENT_DAY.exs
if [ ! -f "$EXS_FILE" ]; then
  echo "Creating $EXS_FILE..."
  cp index.tpl.exs $EXS_FILE
  sed -i '' "s/__DAY__/$CURRENT_DAY/" $EXS_FILE
  git add $EXS_FILE
fi

# inputs
if [ ! -f "inputs/day-$CURRENT_DAY.sample.txt" ]; then
  echo "Creating input files..."
  echo "Sample-${CURRENT_DAY}" > inputs/day-$CURRENT_DAY.sample.txt
  git add inputs/day-$CURRENT_DAY.sample.txt
  echo "Puzzle-${CURRENT_DAY}" > inputs/day-$CURRENT_DAY.puzzle.txt
  git add inputs/day-$CURRENT_DAY.puzzle.txt
fi
