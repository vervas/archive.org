#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

status=$(curl --write-out %{http_code} --silent --output /dev/null http://archive.org/details/$1)
[ "$status" -eq 200 ] || die "URL does not exist"

[ -d $1 ] || mkdir $1
cd $1

for i in `curl http://archive.org/details/$1 | grep href.*mp3 |  sed 's/^.*href="\([^""]*\)".*$/\1/'`; do
    url="http://archive.org"$i;
    echo $url;
    curl -OL $url;
done
