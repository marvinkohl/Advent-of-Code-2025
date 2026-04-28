%% -*- mode: prolog; -*-

file_ingredients(File, Fresh, Available):-
    open(File, read, Stream),
    stream_ingredients(Stream, Fresh, Available),
    !,
    close(Stream).

stream_ingredients(Stream, Fresh, Available):-
    stream_lines(Stream, Lines),
    append([FreshLines, [""], AvailableLines], Lines),
    maplist(string_range, FreshLines, Fresh),
    maplist(number_string, Available, AvailableLines).

stream_lines(Stream, []):- at_end_of_stream(Stream).
stream_lines(Stream, [Line|RestLines]):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes), !,
    string_codes(Line, Codes),
    stream_lines(Stream, RestLines).

%%! string_range(+String:string, Range)
string_range(String, range(X, Y)):-
    debug(day05, "string_range ~s~n", [String]),
    sub_string(String, XLen, 1, YLen, "-"),
    sub_string(String, 0, XLen, _, XStr),
    sub_string(String, _, YLen, 0, YStr),
    number_string(X, XStr),
    number_string(Y, YStr).
