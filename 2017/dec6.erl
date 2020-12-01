-module(dec6).
-export([testcase1/0, testcase2/0, part1/0, part2/0]).

testcase1() ->
    run([0, 2, 7, 0]).

part1() ->
    run([11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]).

run(Registers) -> 
    Seen = sets:new(),
    Result = cycle(Registers, Seen, 0),
    io:fwrite("part1: ~p~n", [Result]).

cycle(Registers, Set, Count) ->
    case sets:is_element(Registers, Set) of
        true -> Count;
        Otherwise ->
            NewSet = sets:add_element(Registers, Set),
            Max = lists:max(Registers),
            StartIndex = index_of(Max, Registers),
            cycle(redistribute(set_to_zero(Registers, StartIndex), StartIndex, Max), NewSet, Count + 1)
    end.


testcase2() ->
    run2([0, 2, 7, 0]).

part2() ->
    run2([11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]).

run2(Registers) ->
    Seen = sets:new(),
    Result = cycle2(Registers, Seen, []),
    io:fwrite("part2: ~p~n", [Result]).

cycle2(Registers, Set, All) ->
    case sets:is_element(Registers, Set) of
        true -> length(All) - index_of(Registers, All) + 1;
        Otherwise ->
            NewSet = sets:add_element(Registers, Set),
            Max = lists:max(Registers),
            StartIndex = index_of(Max, Registers),
            cycle2(redistribute(set_to_zero(Registers, StartIndex), StartIndex, Max), NewSet, All ++ [Registers])
    end.


% redistribute value across the list, starting at Index
redistribute(List, _, 0) -> List;
redistribute(L, Index, Val) ->
    NewIndex = Index rem length(L),
    redistribute(incr(L, NewIndex), NewIndex + 1, Val-1).

% set the value at Index to zero
set_to_zero(L, Index) ->
    lists:sublist(L,Index-1) ++ [0] ++ lists:nthtail(Index,L).

% increment the value at Index
incr(L, Index) ->
    lists:sublist(L,Index) ++ [lists:nth(Index+1,L)+1] ++ lists:nthtail(Index+1,L).


% % borrowed from https://stackoverflow.com/questions/1459152/erlang-listsindex-of-function#1459199
index_of(Item, List) -> index_of(Item, List, 1).
index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).