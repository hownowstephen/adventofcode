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
            Y = Res; Y = 1), I, R).
 
:- func modifiedChineseRemainder(list(int)) = int is det.
modifiedChineseRemainder(Routes) = Out :-
    foldl((pred(Mod::in, A::in, O::out) is det :-
        O = A * Mod
    ), Routes, 1, Prod),

    foldl2((pred(I::in, PrevTotal::in, Total::out, Idx::in, NewIdx::out) is det :-
        P = Prod / I,
        Total = PrevTotal + (Idx * mulInv(P, I, I, 0, 1) * P),
        NewIdx = Idx + 1
    ), Routes, 0, Sum, 0, _),

    Out = Prod - Sum mod Prod.


:- func mulInv(int, int, int, int, int) = int is det.
mulInv(A, B, B0, X0, X1) = Out :-
    (if B0 = 1 then
        Out = 1
    else if A > 1 then
        Out = mulInv(B, A mod B, B0, X1 - (A / B) * X0, X0)
    else if X1 < 0 then
        Out = X1 + B0
    else
        Out = X1
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
                        Result = modifiedChineseRemainder(BusRoutes),
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