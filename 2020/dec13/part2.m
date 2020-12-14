:- module part2.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int, string, list, bool.


:- func intList(list(string)) = list(int).
intList(I) = R :-
    map((pred(X::in, Y::out) is det :-
        string.to_int(string.chomp(X), O) ->
            Y = O; Y = -1), I, R).

:- pred earliestTimestamp(list(int)::in, int::out) is det.
earliestTimestamp(Lines, Result) :-
    earliestTimestamp(0, Lines, Result).
    
:- pred earliestTimestamp(int::in, list(int)::in, int::out) is det.
earliestTimestamp(T, Lines, Result) :-
    foldl2((pred(Bus::in, Offset::in, Next::out, Prev::in, Count::out) is det :-
        (if (Bus > 0; Prev = 0) then
                Count = Prev + (T + Offset) mod Bus,
                Next = Offset + 1
        else
            Count = Prev,
            Next = Offset + 1
        )
    ), Lines, 0, _, 0, Total),
    (if Total = 0 then
            Result = T
        else
            earliestTimestamp(T+1, Lines, Result)
    ).

main(!IO) :-
    io.write_string("Hello, December 13th part II\n", !IO),
    io.open_input("sampleinput3.txt", OpenResult, !IO),
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

                        BusRoutes = intList(string.split_at_char(',', RouteString)),
                        earliestTimestamp(BusRoutes, Result),
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