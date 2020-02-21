% +----+
% | Px |
% | 42 |
% +----+

displCase(Pos, L) :-
    case(Pos, EstSniper),
    ( L == 0,               % if (L == 0) première ligne
        write('+----+') ,!
    ; L == 1,               % if (L == 1) ligne ?policier et ?sniper
        write('|  '),
        ( EstSniper == true,
            write('x') ,!
        ;
            write(' ')
        ),
        write(' |') ,!
    ; L == 2,               % if (L == 2) ligne nombre de perso
        write('|    |') ,!
    ;
        write('+----+')
    ).


test() :-
    between(0, 1, I),
        between(0, 3, L),
            displCase((I, 3), L)
        fail,
        nl,
    fail.

% terrLigne(N) :-

% d_Terrain() :-

