%% -*- mode: prolog; -*-

:- ensure_loaded("day05").

:- begin_tests(day05).

test(available_ingedrients_are_loaded):-
    file_ingredients("day05_test_input.txt", _, Result),
    assertion(Result == [1, 5, 8, 11, 17, 32]).

test(fresh_ingredients_are_loaded):-
    file_ingredients("day05_test_input.txt", Result, _),
    assertion(Result == [range(3,5), range(10,14), range(16,20), range(12,18)]).

test(range_members):-
    range_members(range(9, 13), Result),
    assertion(Result == [9,10,11,12,13]).

test(range_list_members):-
    range_list_members([range(2,4), range(6,7)], Result),
    assertion(Result == [2,3,4,6,7]).

test(range_list_members_doesnt_create_duplicate_members):-
    range_list_members([range(11,15), range(13,16)], Result),
    assertion(Result == [11,12,13,14,15,16]).

:- end_tests(day05).
