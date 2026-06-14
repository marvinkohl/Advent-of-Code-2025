%% -*- mode: prolog; -*-

:- module(day05,
          [file_fresh_ingredient_count/2]).
:- ensure_loaded("day05").

%% file_fresh_ingredient_count(+File:string, -Count:int)
%
%  True if Count is the count of all fresh ingredients in the File even
%  when unavailable.
file_fresh_ingredient_count(File, Count):-
    file_ingredients(File, Fresh, _),
    range_member_count(Fresh, Count).

%% range_member_count(+Range:range, -Count:int)
%
%  True if Count is the count of all members in Range.
range_member_count(Range, Count):-
    is_single_range(Range),
    var(Count),
    !,
    range(X, Y) = Range,
    Count is Y - X + 1.
range_member_count(Range, Count):-
    is_range_list(Range),
    var(Count),
    !,
    range_list_merged(Range, Merged),
    range_member_count(Merged, 0, Count).

%% range_member_count(+Range:range, +Acc:int, -Count:int)
range_member_count([], Count, Count).
range_member_count([R1|Rs], A0, Count):-
    range_member_count(R1, C1),
    A1 is A0 + C1,
    range_member_count(Rs, A1, Count).
