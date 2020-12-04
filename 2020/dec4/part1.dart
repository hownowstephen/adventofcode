import 'dart:io';

void main() {
  print('Hello, December 4th');

  String contents = new File('input.txt').readAsStringSync();
  
  List parts = contents.split("\n\n");

  RegExp exp = new RegExp(r"([a-z]{3}):([^ \n]+)");

  Set<String> reqKeys = {'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'};

  int validPassports = 0;
  int totalPassports = 0;
  for(var i = 0;i<parts.length;i++){

    Iterable<RegExpMatch> matches = exp.allMatches(parts[i]);

    Set<String> keys = {};  
    for(var match in matches){
      keys.add(match.group(1));
    }
    
    if(keys.containsAll(reqKeys)){
      validPassports++;
    }
    totalPassports++;
  }

  print("${validPassports} / ${totalPassports} passports are valid");
}