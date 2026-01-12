%% -*- mode: prolog; -*-

:- begin_tests(day04).

test(accessible_rolls_of_paper):-
    accessible_rolls_of_paper("day04_test_input.txt", 13).

:- end_tests(day04).

main(X):-
    accessible_rolls_of_paper("day04_input.txt", X).

accessible_rolls_of_paper(_, _):- fail.
