goenv
=====

golang virtualenv wrapper

You can use bash command to apply script without downloading

    GF=$(mktemp -t goenv); curl -s https://raw.github.com/biinilya/goenv/master/activate.sh > $GF; source $GF
