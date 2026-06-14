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

test(available_ingredient_fresh_count):-
    available_ingredient_fresh_count("day05_test_input.txt", Result),
    assertion(Result == 3).

test(range_union, true(permutation(Result, [range(4,6), range(8,9)]))):-
    range_union(range(4,6), range(8,9), Result).

test(range_union, true(Result = range(4,8))):-
    range_union(range(4,7), range(6,8), Result).

test(range_union, true(Result = range(4,8))):-
    range_union(range(4,6), range(7,8), Result).

test(range_list_merged):-
    Input = [range(12,14), range(9,10), range(13, 15)],
    range_list_merged(Input, Result),
    %% Assert
    range_list_members(Input, X1),
    range_list_members(Result, X2),
    assertion(permutation(X1, X2)),
    assertion(permutation(Result, [range(12,15), range(9,10)])).

test(range_member):-
    range_member([range(8,10), range(15,73)], 9).

test(range_member, all(Result == [9, 10, 11])):-
    range_member(range(9, 11), Result).
test(range_member, all(Result == [2, 3, 4, 5, 6, 10, 11, 12, 13])):-
    range_member([range(2, 6), range(10, 13)], Result).

:- end_tests(day05).
