puts "Hello, Dec 19th"

proc matchall {rules str allRules} {
    set next $str
    foreach rule $rules {
        set try [match $rule $next $allRules]
        if {[ string compare $try $next ] == 0} {
            # puts "NO MATCH $rules $next"
            return $str
        }
        set next $try
    }
    # puts "ALL MATCH $rule $next"
    return $next
}

proc match {idx str rules} {

    if {[string length $str] < [llength $idx]} {
        return "fail"
    }

    set next $str
    foreach i $idx {
        set cur $next
        set l [string length $str]
        foreach rule [lindex $rules $idx] {
            if {[ string match "a" $rule ] || [ string match "b" $rule ]} {
                set f [string range $str 0 0]
                if {[string compare $rule $f] == 0} {
                   set next [string range $next 1 $l]
                }
            } else {
                set firstRule [lindex $rule 0]
                if {[ string is integer -strict $firstRule ]} {
                    set next [matchall $rule $next $rules]
                    continue
                }
                foreach subrule $rule {
                    set try [match $subrule $next $rules]
                    if {[ string compare $try $next ] != 0} {
                        set next $try
                        break
                    }
                }
            }
            if {[ string compare $next $cur] == 0} {
                return $str
            }
        }
    }
    return $next
}

set rules {
    {{4 1 5}}
    {{2 3} {3 2}}
    {{4 4} {5 5}}
    {{4 5} {5 4}}
    "a"
    "b"
}
    
set inputs {
    "ababbb"
    "abbbab"
    "bababa"
    "aaabbb"
    "aaaabbb"
}



set matched 0
foreach in $inputs {
    set out [match 0 $in $rules]
    set t [string trim $out]
    if {[string length $out] == 0} {
        set matched [expr {$matched + 1}]
    }
    puts "$in -> $out [string length $t]"
    
}
puts $matched

# read the rules
set rules {
    {{8 11}}
    {{20 90} {30 134}}
    {{122 20} {135 30}}
    {{20 90} {30 5}}
    {{20 55} {30 5}}
    {{30 30} {30 20}}
    {{20 55} {30 123}}
    {{20 53} {30 123}}
    42
    {{96 30} {43 20}}
    {{30 89} {20 134}}
    {{42 31}}
    {{30 48} {20 3}}
    {{43 20} {43 30}}
    {{124 20} {73 30}}
    {{5 30} {51 20}}
    {{30 68} {20 39}}
    {{30 84} {20 35}}
    {{65 20} {43 30}}
    {{40 20} {62 30}}
    "b"
    {{20 76} {30 80}}
    {{30 30}}
    {{87 30} {55 20}}
    {{131 30} {7 20}}
    {{30 43} {20 51}}
    {{30 58} {20 6}}
    {{30 64} {20 24}}
    {{20 30} {30 30}}
    {{83 30} {47 20}}
    "a"
    {{2 20} {82 30}}
    {{95 123}}
    {{5 20} {87 30}}
    {{20 37} {30 116}}
    {{20 36} {30 61}}
    {{30 22} {20 87}}
    {{89 20} {43 30}}
    {{96 20} {90 30}}
    {{89 20}}
    {{4 30} {107 20}}
    {{20 51} {30 22}}
    {{57 30} {101 20}}
    {{20 20}}
    {{89 30} {28 20}}
    {{22 30} {53 20}}
    {{134 20} {87 30}}
    {{96 20} {66 30}}
    {{30 134} {20 43}}
    {{30 38} {20 75}}
    {{65 20} {134 30}}
    {{30 20} {20 95}}
    {{4 20} {38 30}}
    {{30 30} {20 20}}
    {{105 20} {18 30}}
    {{30 95} {20 30}}
    {{5 20} {96 30}}
    {{117 30} {108 20}}
    {{30 22} {20 43}}
    {{20 28} {30 87}}
    {{79 30} {120 20}}
    {{20 53} {30 90}}
    {{92 30} {10 20}}
    {{20 123} {30 55}}
    {{20 118} {30 25}}
    {{20 30} {20 20}}
    {{95 95}}
    {{30 131} {20 126}}
    {{5 20} {89 30}}
    {{20 94} {30 115}}
    {{87 30} {96 20}}
    {{96 30} {51 20}}
    {{20 90} {30 123}}
    {{65 20} {55 30}}
    {{30 6} {20 46}}
    {{96 30} {55 20}}
    {{1 20} {23 30}}
    {{30 112} {20 13}}
    {{45 30} {37 20}}
    {{116 20} {71 30}}
    {{20 50} {30 44}}
    {{106 30} {85 20}}
    {{30 104} {20 132}}
    {{30 66} {20 22}}
    {{129 30} {33 20}}
    {{77 20} {67 30}}
    {{30 5} {20 53}}
    {{30 20}}
    {{109 20} {36 30}}
    {{20 30} {30 20}}
    {{20 30}}
    {{30 27} {20 113}}
    {{28 20} {43 30}}
    {{87 20} {87 30}}
    {{121 20} {15 30}}
    {{20} {30}}
    {{30 95} {20 20}}
    {{20 26} {30 78}}
    {{89 30} {65 20}}
    {{20 12} {30 125}}
    {{20 7} {30 61}}
    {{30 81} {20 91}}
    {{30 111} {20 103}}
    {{127 30} {23 20}}
    {{69 30} {99 20}}
    {{20 87}}
    {{16 30} {54 20}}
    {{96 20} {123 30}}
    {{21 20} {119 30}}
    {{95 134}}
    {{20 59} {30 32}}
    {{20 23} {30 72}}
    {{30 90} {20 123}}
    {{52 30} {34 20}}
    {{20 63} {30 41}}
    {{20 70} {30 93}}
    {{90 20} {87 30}}
    {{133 30} {102 20}}
    {{20 134} {30 66}}
    {{30 49} {20 74}}
    {{56 30} {9 20}}
    {{43 20} {123 30}}
    {{97 30} {60 20}}
    {{30 30} {20 95}}
    {{96 30} {22 20}}
    {{20 98} {30 86}}
    {{20 53} {30 55}}
    {{30 53} {20 123}}
    {{30 114} {20 14}}
    {{89 20} {96 30}}
    {{30 29} {20 88}}
    {{20 55} {30 134}}
    {{30 17} {20 19}}
    {{20 100} {30 110}}
    {{20 20} {30 20}}
    {{128 30} {130 20}}
}


set infile [open "input.txt" r]

set matched 0
while { [gets $infile in] >= 0 } {
    set out [match 0 $in $rules]
    set t [string trim $out]
    if {[string length $out] == 0} {
        set matched [expr {$matched + 1}]
    }

    puts "$in -> $out [string length $t]"
    # break
}


puts $matched

close $infile