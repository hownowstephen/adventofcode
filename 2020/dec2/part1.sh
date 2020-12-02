echo "Hello, December Second"
cat input.txt | sed -r "sX([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)Xecho \"\4\" | grep -o . | sort |tr -d \"\n\" | awk '/^[^\3]*\3{\1,\2}[^\3]*$/ {print \$1;}' X" > intermediate.sh; bash ./intermediate.sh | wc -l
rm intermediate.sh