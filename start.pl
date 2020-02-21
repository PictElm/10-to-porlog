:- consult('players.pl').
:- consult('board.pl').
:- consult('game.pl').

menu :- repeat,
    write('Combien de joueurs ? (q pour quitter)'),nl,
    write('    -> '), read(Choix),
    (
        integer(Choix), Choix > 0, Choix < 5 -> creationJeu(Choix), !;
        Choix == 'q' -> !
    ).

creationJeu(N):- 
    write('Vous avez choisi '), write(N), write(' joueurs'), nl.
    a_FaireJoueurs(N), 
    repeat,   
    % TO DO
    % Gerer le joueur en cours avec un assert



:-menu.


