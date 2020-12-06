if [ -z "$1" ]
  then
    echo "No day supplied"
    exit 1
fi

node nodejs/days/$1/index.js
