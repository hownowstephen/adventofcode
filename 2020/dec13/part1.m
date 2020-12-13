:- module part1.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int, string, list.

% calculates the min(earliest wait time * the line number) for a list of bus lines
:- pred earliestBus(int::in, list(string)::in, int::out) is det.
earliestBus(T, Lines, Result) :-
     % two accumulators so we can keep track of which is the right one
    foldl2((pred(S::in, Acc::in, M::out, CurrBest::in, Best::out) is det :-

        string.to_int(string.chomp(S), L) ->
            C = ((T div L) * L + L) - T,
            (if Acc > C then
                M = C,
                Best = M * L
            else
                M = Acc,
                Best = CurrBest        
            )
        ;
        M = Acc,
        Best = CurrBest  
    ), Lines, 10000, _, 0, Result).

main(!IO) :-
    io.write_string("Hello, December 13th\n", !IO),

    % Time = 939,
    % io.format("Time: %d\n", [i(Time)], !IO),

    % Lines = [7, 13, 59, 31, 19],

    % earliestBus(Time, Lines, Result),

    % io.format("Result: %d\n", [i(Result)], !IO).
    
    io.open_input("input.txt", OpenResult, !IO),
    (
        OpenResult = ok(File),

        % read the bus number
        io.read_line_as_string(File, ReadTime, !IO), (
            ReadTime = ok(TimeString),
            (
                string.to_int(string.chomp(TimeString), Time) ->
                    io.format("Time: %d\n", [i(Time)], !IO),

                    % read the route descriptions
                    io.read_line_as_string(File, ReadRoutes, !IO), (
                        ReadRoutes = ok(RouteString),
                        earliestBus(Time, string.split_at_char(',', RouteString), Result),
                        io.format("Result: %d\n", [i(Result)], !IO)
                        ;
                            ReadRoutes = error(E),
                            io.stderr_stream(Stderr2, !IO),
                            io.write_string(Stderr2, io.error_message(E) ++ "\n", !IO)
                        ;
                            ReadRoutes = eof
                    )

                ;
                    io.write_string("Bus num invalid", !IO)
            )
        ;
            ReadTime = error(E),
            io.stderr_stream(Stderr, !IO),
            io.write_string(Stderr, io.error_message(E) ++ "\n", !IO)
        ;
            ReadTime = eof
        )

    ;
        OpenResult = error(IO_Error),
        io.stderr_stream(Stderr, !IO),
        io.write_string(Stderr, io.error_message(IO_Error) ++ "\n", !IO)
   ).