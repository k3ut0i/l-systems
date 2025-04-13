iter([], []).
iter([f|Xs], [f, +, f, -, f, -, f, +, f | Ys]) :- iter(Xs, Ys).
iter([+|Xs], [+|Ys]) :- iter(Xs, Ys).
iter([-|Xs], [-|Ys]) :- iter(Xs, Ys).

itern(X, X, 0).
itern(X, Y, N) :- N > 0, !, N1 is N-1, iter(X, X1), itern(X1, Y, N1).

printps(S, []) :- format(S, "stroke~ngrestore~n", []), nl.
printps(S, [+, f|Xs]) :- format(S, "90 rotate len 0 rlineto~n", []),
                         printps(S, Xs).
printps(S, [-, f|Xs]) :- format(S, "270 rotate len 0 rlineto~n", []),
                         printps(S, Xs).

drawkoch(Stream, X0, Y0, Len, N) :-
    itern([f], [f|Z], N),
    format(Stream, "gsave~n~d ~d translate newpath 0 0 moveto~n", [X0, Y0]),
    format(Stream, "/len ~d def len 0 rlineto~n", [Len]),
    printps(Stream, Z).

drawexample(Fname) :-
    open(Fname, write, Stream),
    drawkoch(Stream, 20, 600, 54, 2),
    drawkoch(Stream, 20, 300, 18, 3),
    drawkoch(Stream, 20, 20, 6, 4),
    close(Stream).
