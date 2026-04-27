%% -*- mode: prolog; -*-

file_ingredients(File, Fresh, Available):-
    open(File, read, Stream),
    stream_ingredients(Stream, Fresh, Available),
    !,
    close(Stream).

stream_ingredients(Stream, Fresh, Available):-
    stream_lines(Stream, Lines),
    append([FreshLines, [], AvailableLines], Lines),
    maplist(number_string, Available, AvailableLines).

stream_lines(Stream, []):- at_end_of_stream(Stream).
stream_lines(Stream, [Line|RestLines]):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes), !,
    string_codes(Line, Codes),
    stream_lines(Stream, RestLines).
