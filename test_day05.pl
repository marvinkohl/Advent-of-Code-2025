%% -*- mode: prolog; -*-

:- ensure_loaded("day05").

:- begin_tests(day05).

test(available_ingedrients_are_loaded):-
    file_ingredients("day05_test_input.txt", _, Result),
    assertion(Result == [1, 5, 8, 11, 17, 32]).

test(fresh_ingredients_are_loaded):-
    file_ingredients("day05_test_input.txt", Result, _),
    assertion(Result == [range(3,5), range(10,14), range(16,20), range(12,18)]).

:- end_tests(day05).
