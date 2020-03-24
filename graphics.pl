:- dynamic personnage/3.
:- dynamic policier/1.
:- dynamic case/2.

% +----+
% | Px |
% | 42 |
% +----+

displCaseExist(Pos, L, EstSniper) :-
    L == 0,               %   if (L == 0) première ligne
        write('+----') ,!
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
        write(' ') ,!
    ; L == 2,               %   if (L == 2) ligne nombre de perso
        findall(I, (personnage(I,Pos,vivant), \+ policier(I)), Personnages),
        length(Personnages, Nombre),
        write('| '),
        format('~|~` t~d~2+', [ Nombre ]),
        write(' ').

displCaseVide((X,Y), L) :-
    X2 is X-1, Y2 is Y-1,
    (
        L == 0, ( % if (ligne 0 
            case((X,Y2), _), % ET case au dessu exist)
            write('+----') ,!
        ) ; ( % else
            case((X2,Y), _), % if (case a gauche existe)
                ( L == 0, write('+') ,!; write('|') ) ,!
            ; % else (le + c'est pour les angles bas-droit des extemitées)
                L == 0,case((X2,Y2), _), write('+') ,!; write('.')
        ), write('....')
    ).

% affiche une case si elle existe, sinon une case vide
displCase(Pos, L) :-
    case(Pos, EstSniper),   % if (il existe une case a Pos) {
        displCaseExist(Pos, L, EstSniper) ,!
    ;                       % } else
        displCaseVide(Pos, L).

% affiche les numéros sur le côté gauche
displNumLigne(J, L) :-
    ( L == 1,
        format('~|~` t~d~3+', [ J ]), write('  ') ,!
    ;
        write('     ')
    ).

% affiche les numéros en haut
displNumColonnes(N) :-
    write('     '),
    between(0, N, I),
        format('~|~` t~d~3+', [ I ]), write('  '),
    fail.

trouveTailleTerrain(TaillX, TaillY) :-
    findall(X, case((X,_), _), ListX),
    findall(Y, case((_,Y), _), ListY),
    max_list(ListX, TaillX),
    max_list(ListY, TaillY).

% verticalement : permière coordonnée (numéro colonne)
displTerrain() :-
    trouveTailleTerrain(MaxX, MaxY),

    % les limites sont +1 pour afficher le contours bas et droite des cases au bord bas droit du terrain
    LimX is MaxX+1, LimY is MaxY+1,

    nl, \+ displNumColonnes(MaxX), nl,

    between(0, LimY, J),
        % scanlines (chaque case fait 3 lignes)
        between(0, 2, L),
            nl,
            % comme on va jusqu'a taille+1, on skip dès qu'on a atteint la limite
            ( J == LimY, write('     ') ,!; displNumLigne(J, L) ),
            between(0, LimX, I),
                displCase((I, J), L),
            I == LimX,
        L == 2,
    J == LimY.

g_Terrain :-
    \+ displTerrain(), nl.
