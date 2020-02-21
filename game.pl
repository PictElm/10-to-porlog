% :- dynamic personnage/3.
% :- dynamic case/2.

% Nomenclature :
% I = index d'un personnage
% r_X = recherche d'éléments concernant l'action X
% a_X = action modifiant l'état du jeu

r_EtreSurCaseSniper(I):-personnage(I,Pos,_), case(Pos,true).

r_Deplacer(I,Pos,PosNew):-
    personnage(I,Pos,vivant),
    case(PosNew,_), PosNew\==Pos.

% Si personnage pas mort, on peut le déplacer sur une autre case si celle-ci existe
a_Deplacer(I,Pos,PosNew):-
    deplacerRecherche(I,Pos,PosNew),
    retractall(personnage(I,Pos,vivant)),
    assert(personnage(I,PosNew,vivant)).

% TESTS SWI
% personnage(a,X,vivant). =>X = (0,3)
% deplacer(personnage(a,_,_), case((0,3), _)). => FALSE (parce qu'on est déjà sur la case et donc pas de déplacement possible)
% deplacer(personnage(a,_,_), case((4,2), _)). => TRUE (deplacement possible)

abs(N,N) :- N >= 0, !.
abs(N,R) :- R is -N.

% Vérifier si 2 cases sont l'une à côté de l'autre
r_EtreAdjacent((X1,Y1),(X2,Y2)):-
    case((X1,Y1),_),
    case((X2,Y2),_),
    abs(X1 - X2, R1),
    abs(Y1 - Y2, R2),
    1 is R1 + R2.
