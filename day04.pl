%% -*- mode: prolog; -*-

:- begin_tests(day04).

test(accessible_rolls_of_paper):-
    accessible_rolls_of_paper("day04_test_input.txt", 13).

:- end_tests(day04).

main(X):-
    accessible_rolls_of_paper("day04_input.txt", X).

accessible_rolls_of_paper(_, _):- fail.

%% Reading the Diagram from a File as list of list of chars.
file_diagram(File, Diagram):-
    open(File, read, Stream),
    stream_diagram(Stream, Diagram),
    !,
    close(Stream).

stream_diagram(Stream, []):- at_end_of_stream(Stream).
stream_diagram(Stream, [Line|RestLines]):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes), !,
    maplist(char_code, Line, Codes),
    stream_diagram(Stream, RestLines).
