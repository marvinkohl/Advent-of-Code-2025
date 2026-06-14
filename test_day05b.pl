%% -*- mode: prolog; -*-

:- module(day05b, []).
:- use_module(day05b).

:- begin_tests(day05b).

test(file_fresh_ingredient_count, true(Result = 14)):-
    file_fresh_ingredient_count("day05_test_input.txt", Result).

:- end_tests(day05b).
