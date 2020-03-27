:- consult('players.pl').
:- consult('board.pl').
:- consult('game.pl').
:- consult('graphics.pl').

menu :- repeat,
    write('Combien de joueurs ? (q pour quitter)'),
    nl,
    write('    -> '), read(Choix),
    (
        integer(Choix), Choix > 1, Choix < 5 -> creationJeu(Choix), !;
        Choix == 'q' -> !
    ).

m_Deplacer :- write('cool').
% On consulte le plateau entier puis les cases qu'on souhaite regarder.
m_ConsulterPlateau() :- 
    d_Terrain(),nl,
    repeat,
    write('Quelle position consulter ? (écrire sous la forme (x,y) / p plateau / q pour quitter)'),
    nl,
    write('    -> '), read(Pos),
    (
        case(Pos,_) -> d_Detail(Pos),nl;
        Pos == 'q' -> !;
        Pos == 'p' -> d_Terrain(),nl;
        write('!!!! Veuillez selectionner un choix valide !!!'), nl, fail
    ),
    write('Que voulez-vous faire?'), nl, nl,
    write(' ---                            ---'), nl,
    write('| 1 | Deplacer un personnage   | 2 | Eliminer un personnage'),nl,
    write(' ---                            ---'), nl, 
    write(' ---  Controler l\'identite      ---'), nl,
    write('| 3 |   d\'un personnage a      | 4 | Consulter les personnages'),nl,
    write(' ---  l\'aide d\'un policier      ---'), nl, nl,
    m_ChoisirAction.

m_ChoisirAction :- repeat,
                write('    -> '), read(Choix),
                (
                    Choix == 1 -> m_Deplacer;
                    Choix == 2 -> write('NIMPLEMENTED2'), nl, !;
                    Choix == 3 -> write('NIMPLEMENTED'), nl;
                    Choix == 4 -> write('version alpha'),m_ConsulterPlateau(), nl, !;
                    write('!!!! Veuillez selectionner un choix valide !!!'), nl, fail
                ).

tour :- write('Nouveau tour, les joueurs sont : '),
    r_TousLesJoueurs(L), write(L),
    repeat,
        nth0(N,L,JoueurEnCours), nl, nl,
        write('C\'est au tour de : '), write(JoueurEnCours), nl,
        between(1, 2, I),
            write('Action n° : '), write(I), write('/2'), nl, nl,
            write('Que voulez-vous faire?'), nl, nl,
            write(' ---                            ---'), nl,
            write('| 1 | Deplacer un personnage   | 2 | Eliminer un personnage'),nl,
            write(' ---                            ---'), nl, 
            write(' ---  Controler l\'identite      ---'), nl,
            write('| 3 |   d\'un personnage a      | 4 | Consulter les personnages'),nl,
            write(' ---  l\'aide d\'un policier      ---'), nl, nl,
            m_ChoisirAction,
        fail,
        N is N+1 mod 3. 

creationJeu(N):- 
    write('Vous avez choisi '), write(N), write(' joueurs'), nl,
    a_FaireJoueurs(N),
    tour.

:-menu.
