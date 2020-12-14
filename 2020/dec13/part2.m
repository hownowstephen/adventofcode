:- module part2.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int, string, list, bool.


:- func intList(list(string)) = list(int).
intList(I) = R :-
    map((pred(X::in, Y::out) is det :-
        string.to_int(string.chomp(X), Res) ->
            Y = Res; Y = -1), I, R).

:- func earliestTimestamp(list(int)) = int is det.
earliestTimestamp(Routes) = Out :-
    Out = earliestTimestamp(100000000000000, Routes).


:- func earliestTimestamp(int, list(int)) = int is det.
earliestTimestamp(T, Routes) = Out :-
    Res = earliestTimestamp(T, 0, Routes) ->
        (if Res = -1 then
            Out = earliestTimestamp(T+1, Routes)
        else
            Out = Res
        )
    ;
        Out = T.


:- func earliestTimestamp(int, int, list(int)) = int is semidet.
earliestTimestamp(Time, Idx, List) = Out :-
    (if (Time + Idx) mod head(List) > 0 then
       Out = -1
    else
        Out = earliestTimestamp(Time, Idx + 1, tail(List))
    ).

main(!IO) :-
    io.write_string("Hello, December 13th part II\n", !IO),
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

                        BusRoutes = intList(string.split_at_char(',', RouteString)),
                        Result = earliestTimestamp(BusRoutes),
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