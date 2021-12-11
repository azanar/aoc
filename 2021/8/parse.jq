split("|") | [
    ( .[0] | ltrimstr(" ") | rtrimstr(" ") | split(" ")),
    ( .[1] | ltrimstr(" ") | rtrimstr(" ") | split(" "))
]
