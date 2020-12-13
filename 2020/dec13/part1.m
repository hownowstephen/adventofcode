:- module part1.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int, string, list.

:- pred calc(int::in, list(int)::in, int::out) is det.
calc(T, Lines, Result) :-
     % two accumulators so we can keep track of which is the right one
    foldl2((pred(L::in, Acc::in, M::out, CurrBest::in, Best::out) is det :-
        C = ((T div L) * L + L) - T,
        (if Acc > C then
            M = C,
            Best = M * L
        else
            M = Acc,
            Best = CurrBest        
        )
    ), Lines, 10000, _, 0, Result).

main(!IO) :-
    io.write_string("Hello, December 13th\n", !IO),

    Time = 939,
    io.format("Time: %d\n", [i(Time)], !IO),

    Lines = [7, 13, 59, 31, 19],
    
    % % two accumulators so we can keep track of which is the right one
    % foldl2((pred(L::in, Acc::in, M::out, CurrBest::in, Best::out) is det :-
    %     C = ((Time div L) * L + L) - Time,
    %     (if Acc > C then
    %         M = C,
    %         Best = M * L
    %     else
    %         M = Acc,
    %         Best = CurrBest        
    %     )
    % ), Lines, 10000, Min, 0, Best),

    calc(Time, Lines, Best),

    io.format("Best: %d\n", [i(Best)], !IO).

    % print the results
    % foldl((pred(L::in, !.IO::di, !:IO::uo) is det :-
    %         io.print(L, !IO),
    %         io.nl(!IO)), Modulos, !IO).
    
%     io.open_input("sampleinput.txt", OpenResult, !IO),
%     (
%         OpenResult = ok(File),

%         % read the bus number
%         io.read_line_as_string(File, Res, !IO), (
%             Res = ok(S),
%             (
%                 string.to_int(string.chomp(S), BusNum) ->
%                     io.format("Bus: %d\n", [i(BusNum)], !IO),

%                     % read the route descriptions
%                     io.read_line_as_string(File, Res2, !IO), (
%                         Res2 = ok(Routes),
%                         io.write_string(Routes, !IO)

%                         % foldl

%                         ;
%                             Res2 = error(E),
%                             io.stderr_stream(Stderr2, !IO),
%                             io.write_string(Stderr2, io.error_message(E) ++ "\n", !IO)
%                         ;
%                             Res2 = eof
%                     )

%                 ;
%                     io.write_string("Bus num invalid", !IO)
%             )
%         ;
%             Res = error(E),
%             io.stderr_stream(Stderr, !IO),
%             io.write_string(Stderr, io.error_message(E) ++ "\n", !IO)
%         ;
%             Res = eof
%         )

%     ;
%         OpenResult = error(IO_Error),
%         io.stderr_stream(Stderr, !IO),
%         io.write_string(Stderr, io.error_message(IO_Error) ++ "\n", !IO)
%    ).