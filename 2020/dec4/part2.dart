import 'dart:io';

Set<String> reqKeys = {'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'};
Set<String> eyeColours = {'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'};

RegExp exp = new RegExp(r"([a-z]{3}):([^ \n]+)");
RegExp hgtMatch = new RegExp(r"^(\d+)(cm|in)$");
RegExp hairColour = new RegExp(r"^#[0-f]{6}$");
RegExp pidMatch = new RegExp(r"^[0-9]{9}$");

void main() {
  print('Hello, December 4th');

  String contents = new File('input.txt').readAsStringSync();
  
  List parts = contents.split("\n\n");

  int validPassports = 0;
  int totalPassports = 0;
  for(var i = 0;i<parts.length;i++){

    Iterable<RegExpMatch> matches = exp.allMatches(parts[i]);

    Map<String,String> passport = {};
    for(var match in matches){
      passport[match.group(1)] = match.group(2);
    }
    
    if(validPassport(passport)){
      validPassports++;
    }
    totalPassports++;
  }

  print("${validPassports} / ${totalPassports} passports are valid");
}

bool validPassport(Map<String,String> p) {

  if(!p.keys.toSet().containsAll(reqKeys)){
    return false;
  }

  try { 

    // byr (Birth Year) - four digits; at least 1920 and at most 2002.
    int byr = int.parse(p['byr']);
    if(byr < 1920 || byr > 2002) { return false; }

    // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    int iyr = int.parse(p['iyr']);
    if(iyr < 2010 || iyr > 2020) { return false; }

    // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    int eyr = int.parse(p['eyr']);
    if(eyr < 2020 || eyr > 2030 ) { return false; }

    // hgt (Height) - a number followed by either cm or in:
    // If cm, the number must be at least 150 and at most 193.
    // If in, the number must be at least 59 and at most 76.
    var match = hgtMatch.firstMatch(p['hgt']);
    int hgt = int.parse(match.group(1));

    switch(match.group(2)) {
      case "cm": { if(hgt < 150 || hgt > 193) { return false; }} break;
      case "in": { if(hgt < 59 || hgt > 76) { return false; }} break;
      default: { return false; }
    }

    // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    if(!hairColour.hasMatch(p['hcl'])) { return false; }
  
    // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    if(!eyeColours.contains(p['ecl'])) { return false; }

    // pid (Passport ID) - a nine-digit number, including leading zeroes.
    if(!pidMatch.hasMatch(p['pid'])) { return false; }
    
  }
  catch(e){
    return false;
  }

  return true;
}