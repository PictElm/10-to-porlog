:- abolish(victime,3).

:- dynamic personnage/3.
:- dynamic policier/1.
:- dynamic case/2.
:- dynamic victime/3.

:- retractall(victime(_,_,_)).

% Nomenclature :
% I = index d'un personnage
% r_X = recherche d'éléments concernant l'action X
% a_X = action modifiant l'état du jeu

r_EtreSurCaseSniper(I) :-
    personnage(I,Pos,_), case(Pos,true).

r_Deplacer(I,PosNew) :-
    personnage(I,Pos,vivant),
    case(PosNew,_), PosNew\==Pos.

% Si personnage pas mort, on peut le déplacer sur une autre case si celle-ci existe
a_Deplacer(I,PosNew) :-
    r_Deplacer(I,PosNew),
    retractall(personnage(I,_,vivant)),
    assert(personnage(I,PosNew,vivant)).

% TESTS SWI
% personnage(a,X,vivant). =>X = (0,3)
% deplacer(personnage(a,_,_), case((0,3), _)). => FALSE (parce qu'on est déjà sur la case et donc pas de déplacement possible)
% deplacer(personnage(a,_,_), case((4,2), _)). => TRUE (deplacement possible)

abs(N,N) :- N >= 0, !.
abs(N,R) :- R is -N.

% Vérifier si 2 cases sont l'une à côté de l'autre
r_EtreAdjacent((X1,Y1),(X2,Y2)) :-
    case((X1,Y1),_),
    case((X2,Y2),_),
    abs(X1 - X2, R1),
    abs(Y1 - Y2, R2),
    1 is R1 + R2.

r_ControlerIdentite(PI,I) :-
    personnage(I,Pos,vivant),
    personnage(PI,Pos,vivant),
    policier(PI).

% Le personnage I1 tue le personnage I2
r_Tuer(I1, I2) :-
    personnage(I1, (X1,Y1), vivant),
    \+ policier(I1),
    personnage(I2, (X2,Y2), vivant),
    (
        % par couteau
        (X1,Y1) == (X2,Y2), I1 \= I2, !
        ;
        % par pistolet
        r_EtreAdjacent((X1,Y1), (X2,Y2)),
        \+ r_TemoinPresent(I1,(X1,Y1)), !
        ;
        % par sniper
        case((X1,Y1), true),
        (X1 == X2 ; Y1 == Y2),
        \+ r_TemoinPresent(I1,(X1,Y1)), !
    ).

r_TemoinPresent(Tueur,(X,Y)) :-
    personnage(Temoin,(X,Y),vivant),
    Temoin\=Tueur
    ;
    r_EtreAdjacent((X,Y),(X2,Y2)),
    personnage(Temoin,(X2,Y2),vivant),
    policier(Temoin).

% duplicat >< ?
r_Tuable(I1, I2) :-
    personnage(I1, (X1,Y1), vivant),
    \+ policier(I1),
    personnage(I2, (X2,Y2), vivant),
    (
        % par couteau
        (X1,Y1) == (X2,Y2), I1\=I2
        ;
        % par sniper
        case((X1,Y1), true),
        (X1,Y1) \= (X2,Y2),
        (X1 == X2 ; Y1 == Y2),
        \+ r_TemoinPresent(I1,(X1,Y1))
        ;
        % par pistolet
        \+ case((X1,Y1), true), % les cases snipers sont forcément adjacentes donc fin de la recherche
        r_EtreAdjacent((X1,Y1), (X2,Y2)),
        \+ r_TemoinPresent(I1,(X1,Y1))
    ).

r_PlacerPolicier(I2) :-
    personnage(I2,Pos,_),
    personnage(Policier,nonPose,vivant), % Si certains policiers ne sont pas encore sur le plateau
    retractall(personnage(Policier,_,vivant)),
    assert(personnage(Policier,Pos,vivant)),r_ZoneVictime(I2,Pos,Policier), ! ;
    personnage(I2,Pos,_),
    r_ZoneVictime(I2,Pos,policierPasPresent),true. % Si tous les policiers ont été placés, on ne fait rien

r_ZoneVictime(I,Pos,Policier) :- % stocke les infos sur la victime
    case(Pos,_),
    retractall(victime(_,_,_)),
    assert(victime(I,Pos,Policier)).

a_Tuer(I1, I2) :-
    r_Tuer(I1, I2),
    r_PlacerPolicier(I2),  % on rajoute un policier sur la case s'il en reste en reserve
    retractall(personnage(I2,_,vivant)),
    assert(personnage(I2,_,I1)).

a_EvacuerZone :-
    victime(I,Pos,Policier),
    g_AnnoncerMeurtre(I,Pos,Policier),
    case(Pos,_),
    findall(Pers, (personnage(Pers,Pos,vivant),Pers\=Policier), Personnages),
    r_Evacuer(Personnages,Policier),
    retractall(victime(_,_,_)),g_NettoieEcranMaisAttendUnPeutQuandMeme;
    true.

r_Evacuer([I|Q],Policier) :- 
    \+ b_Evacuer(I),
    r_Evacuer(Q,Policier).

r_Evacuer([],Policier) :- 
    nl,
    writeln('Tous les temoins ont ete deplaces.'),
    Policier = policierPasPresent
    % writeln('Il faut que vous deplaciez un des policiers du plateau') 
    % TODO : faire le predicat pour deplacer un policier du plateau
    ;
    true.

b_Evacuer(I) :-
    personnage(I,Pos,vivant),
    repeat,nl,
    write('Choisir ou deplacer le personnage '),write(I),nl,
    g_QuestionChoisireCase,
    g_Repondre(PosNew),
    (
        prompt(_,''),
        a_Deplacer(I,PosNew) -> g_PersoSeDeplacerEn(I, Pos, PosNew), !;
            g_ChoixNonExistant
    ),
    fail.

