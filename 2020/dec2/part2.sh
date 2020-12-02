echo "Hello, December Second, part two"
count=0
while read pass; do

    idx1=$(echo $pass | sed -E 's/([0-9]+)-.*/\1/')
    idx2=$(echo $pass | sed -E 's/.*-([0-9]+).*/\1/')
    char=$(echo $pass | sed -E 's/.*([a-z]):.*/\1/')
    val=$(echo $pass | sed -E 's/.*: ([a-z]+)/\1/')
    
    idx1=$((idx1-1))
    idx2=$((idx2-1))

    i=0
    if [ "${val:$idx1:1}" = "$char" ]; then
        i=$((i+1))
    fi

    if [ "${val:$idx2:1}" = "$char" ]; then
        i=$((i+1))
    fi

    if [ $i -eq 1 ]; then
        count=$((count+1))
    fi

done <input.txt

echo $count