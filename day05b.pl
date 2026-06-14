%% -*- mode: prolog; -*-

:- module(day05,
          [file_fresh_ingredient_count/2]).
:- ensure_loaded("day05").

%% file_fresh_ingredient_count(+File:string, -Count:int)
%
%  True if Count is the count of all fresh ingredients in the File even
%  when unavailable.
file_fresh_ingredient_count(File, Count):-
    file_ingredients(File, Fresh1, _),
    range_list_merged(Fresh1, Fresh),
    findall(X, range_member(Fresh, X), Members),
    length(Members, Count).
