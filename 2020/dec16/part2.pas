program Part2;
uses
    Classes,Sysutils;
type
    rule = array[0..1] of integer;
    ticket = array of integer;
    validRule = set of 0..255; // this needs t b
    possibleRule = array of validRule;
var
    departureFields: array of integer;
	rules: array of array [0..1] of rule;
    tickets: array of array of integer;
    valid, ticketValid: boolean;
    l, i, j, r, c: integer;

    infile: TextFile;
    line: string;
    s, parts: TStrings;
    parsedTicket: array of integer;

    // list of valid tickets and the possible rules for each entry
    allPossibleRules: array of possibleRule;
    possible: possibleRule;
    ticketFieldRules: possibleRule;

    myTicket: array of integer;
    ticketFields: array of integer;
    usedRules: validRule;

    found: integer;

    result: uint64;

function getRule(s: string): rule;
var
   p: TStrings;
begin
    try
        p := TStringList.Create;
        ExtractStrings(['-'], [], PChar(s), p);
        getRule[0] := StrToInt(p[0]);
        getRule[1] := StrToInt(p[1]);
    finally
        p.Free;
    end;
end;

function parseTicket(s: string): ticket;
var
    p: TStrings;
    t: array of integer;
begin
    try
        p := TStringList.Create;
        ExtractStrings([','], [], PChar(s), p);
        setLength(t, p.count);
        for i := 0 to p.count-1 do
        begin
            t[i] := StrToInt(p[i]);
        end;
    finally
        p.Free;
    end;
    parseTicket := t;
end;

// function checkRules(s: array of integer): possibleRule;
// begin
// end;

begin
    writeln ('Hello, Dec 16th part II');

    // Set the name of the file that will be read
    AssignFile(infile, 'input.txt');

    // Embed the file handling in a try/except block to handle errors gracefully
    try
        // Open the file for reading
        reset(infile);

        l := 0;

        // Read the rules
        readln(infile, line);
        repeat
            if(not SameText(line, '')) then
            begin
                parts := TStringList.Create;
                setLength(rules, l+1);

                s := TStringList.Create;
                ExtractStrings([':'], [], PChar(line), s);

                // Track which fields we're going to need to use for the result
                if(pos('departure', s[0]) = 1) then
                begin
                    setLength(departureFields, length(departureFields)+1);
                    departureFields[length(departureFields)-1] := l;
                end;

                ExtractStrings([' '], [], PChar(s[1]), parts);
                s.Free;

                rules[l][0] := getRule(parts[0]);
                rules[l][1] := getRule(parts[2]);
                
                parts.Free;
                l += 1;
            end;
            readln(infile, line);
        until SameText(line, 'your ticket:') or eof(infile);

        // Read my ticket
        readln(infile, line);
        myTicket := parseTicket(line);
        
        // skip until the next block
        repeat readln(infile, line) until SameText(line, 'nearby tickets:') or eof(infile);

        l := 0;

        // Read nearby tickets
        repeat
            readln(infile, line);

            parsedTicket := parseTicket(line);

            // This would fail if ticket length ever varied, but since they don't leaving it as-is
            setLength(tickets, l+1, length(parsedTicket));
            tickets[l] := parsedTicket; 
            
            l += 1;
        until eof(infile);

        // Done so close the file
        CloseFile(infile);

    except
        on E: EInOutError do
            writeln('File handling error occurred. Details: ', E.Message);
    end;

    result := 0;

    for i := 0 to high(tickets) do
    begin
        // check all rules and if the ticket has valid fields for all, set ticketValid
        ticketValid := true;
        setLength(possible, length(tickets[i]));

        for j := 0 to high(tickets[i]) do 
        begin
            valid := false;
            possible[j] *= [];
            for r := 0 to high(rules) do
            begin
                if(
                    ((tickets[i][j] >= rules[r][0][0]) and (tickets[i][j] <= rules[r][0][1]))
                    or
                    ((tickets[i][j] >= rules[r][1][0]) and (tickets[i][j] <= rules[r][1][1]))
                ) then
                begin
                    valid := true;
                    possible[j] += [r]; // add this rule to the set of valid rules for this field
                end
            end;
            ticketValid := (valid and ticketValid);
        end;

        if(ticketValid) then 
        begin
            setLength(allPossibleRules, length(allPossibleRules)+1, length(tickets[i]));
            for j := 0 to length(tickets[i]) -1 do
            begin
                allPossibleRules[length(allPossibleRules)-1][j] := possible[j];
            end;
        end;
    end;


    setLength(ticketFieldRules, length(allPossibleRules[0]));

    // combine all possible rules to create the final set of rules
    for i := 0 to high(allPossibleRules) do
    begin
        for j := 0 to high(allPossibleRules[i]) do
        begin
            if(i<=0) then ticketFieldRules[j] := allPossibleRules[i][j]
            else ticketFieldRules[j] := ticketFieldRules[j] * allPossibleRules[i][j];
        end;
    end;
    
    setLength(ticketFields, length(myTicket));

    // We should be able to sieve out the rules now
    while found < length(myTicket) do
    begin
        for i := 0 to high(ticketFieldRules) do
            begin
                c := 0;
                for j := 0 to high(rules) do
                begin
                    if((j in ticketFieldRules[i]) and not (j in usedRules)) then 
                    begin
                        c += 1;
                        r := j;
                    end;
                end;
                if(c = 1) then
                begin
                    writeln('field: ', i, ' -> rule: ', r);
                    usedRules += [r];
                    ticketFields[r] := i;
                    found += 1;
                end;
            end;
    end;

    result := 1;
    for i := 0 to high(departureFields) do 
    begin
        result *= myTicket[ticketFields[departureFields[i]]];
    end;
        
    writeln(result);

end.