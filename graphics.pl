% +----+
% | Px |
% | 42 |
% +----+

displCase(Pos, L) :-
    case(Pos, EstSniper),   % if (il existe une case a Pos) {
    ( L == 0,               %   if (L == 0) première ligne
        write('+----+') ,!
    ; L == 1,               %   if (L == 1) ligne ?policier et ?sniper
        write('| '),
        ( personnage(Perso, Pos, vivant), policier(Perso),
            write('P') ,!
        ;
            write(' ')
        ),
        ( EstSniper == true,
            write('x') ,!
        ;
            write(' ')
        ),
        write(' |') ,!
    ; L == 2,               %   if (L == 2) ligne nombre de perso
        findall(I, (personnage(I,Pos,vivant), \+ policier(I)), Personnages),
        length(Personnages, Nombre),
        write('| '),
        format('~|~` t~d~2+', [ Nombre ]),
        write(' |') ,!
    ;
        write('+----+')
    ) ,!
    ;                       % } else {
        write('      ').

test() :-
    between(0, 5, I),
        between(0, 3, L),
            nl,
            between(0, 5, J),
                displCase((I, J), L),
            fail,
        fail,
    fail.

% terrLigne(N) :-

% d_Terrain() :-

