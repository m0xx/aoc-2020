if [ -z "$1" ]
  then
    echo "No day supplied"
    exit 1
fi

CURRENT_DAY=$1

mkdir days/$CURRENT_DAY
cp index.tpl.js nodejs/days/$CURRENT_DAY/index.js
echo "Sample-${CURRENT_DAY}" > inputs/day-$CURRENT_DAY.sample.txt
echo "Puzzle-${CURRENT_DAY}" > inputs/day-$CURRENT_DAY.puzzle.txt

sed -i '' "s/__DAY__/$CURRENT_DAY/" nodejs/days/${CURRENT_DAY}/index.js
