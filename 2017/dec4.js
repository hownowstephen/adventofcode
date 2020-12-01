fs = require('fs');
fs.readFile(process.argv[2], 'utf8', function (err,input) {
  if (err) {
    return console.log(err);
  }
  valid = input.split("\n").map(function(value){
    var words = {}
    var isValid = 1
    value.split(" ").forEach(function(word){
        
        // part two addition, sort the strings so we can check anagram matches
        word = word.split('').sort().join('');

        if(words[word] == true){
            console.log("invalid:", value)
            isValid = 0
        }
        words[word] = true
    })
    return isValid
    }).reduce(function(prev, current){
        return prev + current
    })

    console.log(valid)
});

