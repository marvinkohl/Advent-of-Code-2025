%% -*- mode: prolog; -*-

:- module(test_day06, []).
:- use_module(day06).

:- begin_tests(day06).

test(problem_result, Result == 33210):-
    problem_result(problem([123, 45, 6], '*'), Result).
test(problem_result, Result == 490):-
    problem_result(problem([328, 64, 98], '+'), Result).

:- end_tests(day06).
