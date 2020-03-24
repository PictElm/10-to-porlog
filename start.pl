:- consult('board.pl').
:- consult('players.pl').
:- consult('game.pl').
:- consult('graphics.pl').

% Pour plus de clarté, ce document se lit de bas en haut (en partant de la boucle de lancement du jeu)
% Le programme/jeu débute par le menu et est constitué de plusieurs tours (correspondant au tour d'un autre joueur).
% Chaque joueur peut effectuer 2 actions, sauf s'il décide d'éléminer quelqu'un (correspondant à 2 actions d'un coup)

% Nomenclature :
%   b : boucle
%   c : choix effectue
%   g : graphique/affichage
%   a : action
%   r : recherche

% ---- PARTIE GRAPHIQUE (questions, affichage des reponses, des choix etc) ----
g_NettoieEcran :- nl,
    write('\e[2J'),
    g_Titre.

g_NettoieEcranMaisAttendUnPeutQuandMeme :- nl,
    write('Appuyer sur entrer pour effacer l\'ecran et continuer.'),
    get_code(_),
    g_NettoieEcran.

g_Titre :- nl,
    writeln('      -------------------------------- '),
    writeln('     |       10 MINUTES TO KILL       |'),
    writeln('     |       ~ A PROLOG GAME! ~       |'), 
    writeln('      -------------------------------- ').

g_QPourQuitter :- nl,
    writeln('(q pour quitter)').

g_QuestionNbJoueurs :- nl,
    write('     Combien de joueurs vont participer (2 a 4 max) ?'),
    g_QPourQuitter.

g_QuestionChoisireCase :- nl,
    write('     Choisissez une case (entrez X,Y)').

g_Repondre(Choix) :- nl,
    write('      --> Votre choix : '),
    read(Choix).

g_ChoixNonExistant :- nl,
    writeln('     Erreur: ce choix n\'est pas disponible. Veuillez recommencer.').

g_NbJoueurs(NbJoueurs) :- nl,
    write('           ---- '), nl,
    write('          | -> | Cette partie a '), write(NbJoueurs), writeln(' joueurs'),
    write('           ---- '), nl.

g_Joueurs(ListeJoueurs) :-
    write('          Ces joueurs sont : '),
    writeln(ListeJoueurs).

g_DebutPartie :- nl, nl,   
    writeln('      -------------------------------- '),
    writeln('     |     QUE LA PARTIE COMMENCE !   |'),
    writeln('      -------------------------------- ').

g_JoueurEnCours(JoueurEnCours) :- nl,
    write('          C\'est au tour de : '), writeln(JoueurEnCours).

g_EtatAction(I) :- nl,
    write('           --------------- '), nl,
    write('          | Action no '), write(I), writeln('/2 |'),
    write('           --------------- '), nl.

g_QuestionActionSouhaitee :- nl,
    writeln('     Que voulez-vous faire ?'), nl, nl,
    writeln('          --> AGIR <--'), nl,
    writeln('      ---                            ---'),
    writeln('     | 1 | Deplacer un personnage   | 2 | Eliminer un personnage'),
    writeln('      ---                            ---'), 
    writeln('      ---  Controler l\'identite     '),
    writeln('     | 3 |   d\'un personnage a      '),
    writeln('      ---  l\'aide d\'un policier    '), nl, nl,
    writeln('          --> ou CONSULTER <--'), nl,
    writeln('      ---                            ---      Consulter les    '),
    writeln('     | 4 | Voir le plateau          | 5 | personnages/policiers'),
    writeln('      ---                            ---        vivants       '),
    writeln('      ---                            '),
    writeln('     | 6 | Se faire conseiller       '),
    writeln('      ---                            ').

g_PersonnagesVivant(ListePersonnages) :- nl,
    writeln(ListePersonnages).

g_PersonnagesSurCase(Pos, ListePersonnages) :- nl,
    write('Les personnages sur la case '), write(Pos), write(' sont :'),
    g_PersonnagesVivant(ListePersonnages).

% ---- CHOIX PRIT PAR L'UTILISATEUR ----
% Un choix correspond en général à une action (a_...) et/ou recherche (r_...) suivi d'une phrase ou d'un élément graphique (g_...)

c_NotImplemented :- nl,
    writeln('NOT IMPLEMENTED YET').

c_Deplacer :- c_NotImplemented.
c_Eliminer :- c_NotImplemented.
c_Controler :- c_NotImplemented.

c_ConsulterPersonnagesVivant :- 
    findall((I,Pos), personnage(I,Pos,vivant), ListePersonnages),
    g_PersonnagesVivant(ListePersonnages).

c_VoirPlateau :-
    g_Terrain,
    repeat,
        g_QuestionChoisireCase, g_QPourQuitter,
        g_Repondre(Choix),
        (
            Choix == 'q' -> !, fail;
            case(Choix, _) -> ( % détailler les personnage sur la case Choix
                findall(I, (personnage(I,Choix,vivant), \+ policier(I)), Personnages),
                g_PersonnagesSurCase(Choix, Personnages)
            );
            g_ChoixNonExistant, fail
        ).

c_IA :- c_NotImplemented.

c_CreationPartie(NbJoueurs):- 
    g_NbJoueurs(NbJoueurs),
    a_CreerJoueurs(NbJoueurs),
    b_Partie.

% ---- BOUCLES DE CHOIX ----
b_ActionsPrincipales :- 
    repeat,
        g_NettoieEcranMaisAttendUnPeutQuandMeme,
        g_QuestionActionSouhaitee,
        g_Repondre(Choix),
        (
            Choix == 1 -> c_Deplacer, !;
            Choix == 2 -> c_Eliminer, !;
            Choix == 3 -> c_Controler, !;
            Choix == 4 -> c_VoirPlateau;
            Choix == 5 -> c_ConsulterPersonnagesVivant;
            Choix == 6 -> c_IA;
            g_ChoixNonExistant, fail
        ).

b_Partie :-
    r_TousLesJoueurs(ListeJoueurs),
    g_Joueurs(ListeJoueurs),
    g_DebutPartie,
    repeat,
        nth0(N, ListeJoueurs, JoueurEnCours),
        g_JoueurEnCours(JoueurEnCours),
        between(1, 2, I),
            g_EtatAction(I),
            b_ActionsPrincipales,
        fail,
        N is N+1 mod 3.
        
b_LancementJeu :-
    g_NettoieEcran,
    g_Titre,
    repeat,
        g_QuestionNbJoueurs,
        g_Repondre(Choix),
        (
            % Ce qui est inséré doit être un chiffre entier de 2 à 4 sinon on reboucle
            integer(Choix), Choix > 1, Choix < 5 -> c_CreationPartie(Choix), !;
            Choix == 'q' -> halt, !;
            g_ChoixNonExistant, fail
        ).

:-b_LancementJeu.
