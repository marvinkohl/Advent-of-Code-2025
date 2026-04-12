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

test(roll_of_paper):- assertion(roll_of_paper(@)).
test(roll_of_paper_fails):- assertion(\+ roll_of_paper(.)).

test(diagram_index_gives_all_indexes):-
    Diagram = [[1,2,3,4,5],
               [6,7,8,9,0],
               [1,2,3,4,5]],
    findall(X, diagram_index(Diagram, X), Results),
    assertion(member(index(0,0), Results)),
    assertion(member(index(2,4), Results)),
    length(Results, Count),
    assertion(Count =:= 15).

test(accessible_roll_of_paper):-
    accessible_roll_of_paper(
        [[@,@,.,@,.],
         [.,@,@,.,@],
         [.,.,.,@,@]],
        index(0,3)).

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

%% Get the indexes of the diagram
diagram_index(Diagram, index(X, Y)):-
    length(Diagram, XLen),
    nth0(0, Diagram, Row),
    length(Row, YLen),
    XUpper is XLen - 1,
    YUpper is YLen - 1,
    between(0, XUpper, X),
    between(0, YUpper, Y).

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

%% Identify roll of papers
roll_of_paper(@).

%% Check a accessible roll of paper
accessible_roll_of_paper(Diagram, Index):-
    indexed_value(Diagram, Index, Item),
    roll_of_paper(Item),
    adjacent_items(Diagram, Index, Adjacents),
    include(roll_of_paper, Adjacents, AdjacentRolls),
    length(AdjacentRolls, Count),
    Count < 4.
