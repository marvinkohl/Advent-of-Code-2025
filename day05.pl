%% -*- mode: prolog; -*-

:- use_module(library(clpfd)).

file_ingredients(File, Fresh, Available):-
    open(File, read, Stream),
    stream_ingredients(Stream, Fresh, Available),
    !,
    close(Stream).

stream_ingredients(Stream, Fresh, Available):-
    stream_lines(Stream, Lines),
    append([FreshLines, [""], AvailableLines], Lines),
    maplist(string_range, FreshLines, Fresh),
    maplist(number_string, Available, AvailableLines).

stream_lines(Stream, []):- at_end_of_stream(Stream).
stream_lines(Stream, [Line|RestLines]):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes), !,
    string_codes(Line, Codes),
    stream_lines(Stream, RestLines).

%%! string_range(+String:string, Range)
string_range(String, range(X, Y)):-
    debug(day05, "string_range ~s~n", [String]),
    sub_string(String, XLen, 1, YLen, "-"),
    sub_string(String, 0, XLen, _, XStr),
    sub_string(String, _, YLen, 0, YStr),
    number_string(X, XStr),
    number_string(Y, YStr).

%%! range_members(+Range, -Members:list)
range_members(range(X, X), [X]):- !.
range_members(range(X1, Y), [X1|MRest]):-
    X1 < Y,
    succ(X1, X2),
    range_members(range(X2, Y), MRest).

%%! range_list_members(+RangeList:list, -Members:list)
range_list_members([], []).
range_list_members([R|Rs], Members):-
    range_members(R, M),
    range_list_members(Rs, Ms),
    ord_union(M, Ms, Members).

%!  range_member(+Range:range, ?Member:integer).
range_member(Range, Member):-
    is_single_range(Range),
    var(Member),
    !,
    range(X, Y) = Range,
    Member in X..Y,
    indomain(Member).
range_member(Range, Member):-
    is_range_list(Range),
    var(Member),
    !,
    [R1|Rs] = Range,
    (range_member(R1, Member); range_member(Rs, Member)).
range_member(range(X,Y), M):-
    integer(X),
    integer(Y),
    integer(M),
    debug(day05, "~d in range(~d,~d)?", [M, X, Y]),
    X =< M,
    M =< Y.
range_member([R1|_], M):-
    is_single_range(R1),
    range_member(R1, M),
    !.
range_member([_|Rs], M):-
    range_member(Rs, M).

%%  Rules to create unions of multiple ranges
%
%!  range_union(+Range1:range, +Range2:range, -Union:range)
range_union([], [], []).
range_union(X, [], X):- is_range(X), !.
range_union([], X, X):- is_range(X), !.
range_union(X,Y,Z):-
    is_single_range(X),
    is_single_range(Y),
    range_merged(X,Y,Z),
    !.
range_union(X, Y, [X,Y]):-
    is_single_range(X),
    is_single_range(Y),
    !.

%!  range_list_merged(+Unmerged:list, -Merged:range)
%
%   True if Merged a best merged range of all ranges in the Unmerged list
range_list_merged(U, M):-
    sort(U, Sorted),
    range_list_merged_(Sorted, M).

range_list_merged_([], []).
range_list_merged_([X], [X]).
range_list_merged_([X1,X2|Xs], Z):-
    range_merged(X1,X2,Y),
    !,
    range_list_merged_([Y|Xs], Z).
range_list_merged_([X1|Xs], [X1|Y]):-
    range_list_merged_(Xs, Y),
    !.

%%! available_ingredient_fresh_count(+File:string, -FreshCount:int)
available_ingredient_fresh_count(File, Count):-
    file_ingredients(File, Fresh1, Available),
    debug(day05, "File read", []),
    range_list_merged(Fresh1, Fresh),
    debug(day05, "Calculated fresh ranges", []),
    include([X]>>range_member(Fresh, X), Available, FreshAvailable),
    debug(day05, "Calculated fresh and available ingredients", []),
    length(FreshAvailable, Count).

%% Predicate to check variable as ranges
%%
%%! is_single_range(+Term)
is_single_range(range(X,Y)):-
    integer(X),
    integer(Y).

%%! is_range_list(+Term)
is_range_list(List):-
    maplist(is_range, List).

%%! is_range(+Term)
is_range(X):- is_single_range(X); is_range_list(X).


%% Merge single ranges
%%
%%! range_intersection(+Range, +Range, -Intersection)
range_intersection(range(Xa,Xb), range(Ya,Yb), range(Min,Max)):-
    Xa =< Yb,
    Ya =< Xb,
    Min is min(Xa,Ya),
    Max is max(Xb,Yb).

%%! range_connected(+Range, +Range, -ConnectedRange)
range_connected(range(Min,Xb), range(Ya,Max), range(Min,Max)):-
    succ(Xb,Ya).
range_connected(range(Xa,Max), range(Min,Yb), range(Min,Max)):-
    succ(Yb,Xa).

%%! range_merged(+Range, +Range, -MergedRange)
range_merged(X,Y,Z):-
    range_intersection(X,Y,Z);
    range_connected(X,Y,Z).
