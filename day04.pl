%% -*- mode: prolog; -*-

:- begin_tests(day04).

test(accessible_rolls_of_paper, [fixme(todo)]):-
    accessible_rolls_of_paper("day04_test_input.txt", 13).

test(adjacent_items):-
    adjacent_items([[1,2,3,4,5],
                    [6,7,8,9,0],
                    [1,2,3,4,5]],
                   index(1, 1),
                   Result),
    assertion(permutation(Result, [1,2,3,8,3,2,1,6])).

test(adjacent_items_of_corners_are_found):-
    adjacent_items([[1,2,3,4,5],
                    [6,7,8,9,0],
                    [1,2,3,4,5]],
                   index(0, 4),
                   Result),
    assertion(permutation(Result, [4,9,0])).

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

%%
adjacent_items(Diagram, index(X, Y), Items):-
    findall(Result, adjacent_item(Diagram, index(X, Y), Result), Items),
    assertion((length(Items, Len), Len =< 8)).

adjacent_item(Diagram, Index, Item):-
    adjacent_index(Index, AdjIndex),
    indexed_value(Diagram, AdjIndex, Item).

adjacent_index(index(X, Y), index(X2, Y2)):- X2 is X - 1, Y2 is Y - 1.
adjacent_index(index(X, Y), index(X2, Y)):- X2 is X - 1.
adjacent_index(index(X, Y), index(X2, Y2)):- X2 is X - 1, Y2 is Y + 1.
adjacent_index(index(X, Y), index(X, Y2)):- Y2 is Y - 1.
adjacent_index(index(X, Y), index(X, Y2)):- Y2 is Y + 1.
adjacent_index(index(X, Y), index(X2, Y2)):- X2 is X + 1, Y2 is Y - 1.
adjacent_index(index(X, Y), index(X2, Y)):- X2 is X + 1.
adjacent_index(index(X, Y), index(X2, Y2)):- X2 is X + 1, Y2 is Y + 1.

indexed_value(Diagram, index(X, Y), Item):-
    nth0(X, Diagram, Row),
    nth0(Y, Row, Item).
