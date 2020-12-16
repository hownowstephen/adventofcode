program Part1;
uses
    Classes,Sysutils;
type
    rule = array[0..1] of integer;
var
    // names: array of string;
	rules: array of array [0..1] of rule;
    tickets: array of array of integer;
    valid: boolean;
    l, i, j, r, result: integer;

    infile: TextFile;
    line: string;
    s, parts: TStrings;

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

begin
    writeln ('Hello, Dec 16th.');

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
                ExtractStrings([' '], [], PChar(s[1]), parts);
                s.Free;

                rules[l][0] := getRule(parts[0]);
                rules[l][1] := getRule(parts[2]);
                
                parts.Free;
                l += 1;
            end;
            readln(infile, line);
        until SameText(line, 'your ticket:') or eof(infile);

        // Read my ticket, can be ignored for this part
        readln(infile, line);
        // writeln('My Ticket ', line);
        
        // skip until the next block
        repeat readln(infile, line) until SameText(line, 'nearby tickets:') or eof(infile);

        l := 0;

        // Read nearby tickets
        repeat
            readln(infile, line);
            parts := TStringList.Create;
            ExtractStrings([','], [], PChar(line), parts);

            setLength(tickets, l+1, parts.count);
            
            for i := 0 to parts.count-1 do
            begin
                tickets[l][i] := StrToInt(parts[i]);
            end;

            l += 1;
            parts.Free;
        until eof(infile);

        // Done so close the file
        CloseFile(infile);

    except
        on E: EInOutError do
            writeln('File handling error occurred. Details: ', E.Message);
    end;

    result := 0;

    for i := 0 to length(tickets) - 1 do
    begin
        for j := 0 to length(tickets[i]) - 1 do 
        begin
            valid := false;
            for r := 0 to length(rules) - 1 do
            begin
                if((tickets[i][j] >= rules[r][0][0]) and (tickets[i][j] <= rules[r][0][1])) then valid := true;
                if((tickets[i][j] >= rules[r][1][0]) and (tickets[i][j] <= rules[r][1][1])) then valid := true;
            end;
            if(not valid) then 
            begin
                // writeln('invalid ', tickets[i][j]);
                result += tickets[i][j];
            end;
        end;
    end;

    writeln(result);

end.