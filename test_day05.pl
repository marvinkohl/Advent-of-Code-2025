%% -*- mode: prolog; -*-

:- ensure_loaded("day05").

:- begin_tests(day05).

test(available_ingedrients_are_loaded):-
    file_ingredients("day05_test_input.txt", _, Result),
    assertion(Result == [1, 5, 8, 11, 17, 32]).

:- end_tests(day05).
