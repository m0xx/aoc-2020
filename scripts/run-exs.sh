if [ -z "$1" ]
  then
    echo "No day supplied"
    exit 1
fi

elixir elixir/day_$1.exs
