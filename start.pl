:- consult('players.pl').
:- consult('board.pl').
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
g_Titre :- nl, 
    writeln('      -------------------------------- '),
    writeln('     |       10 MINUTES TO KILL       |'),
    writeln('     |       ~ A PROLOG GAME! ~       |'), 
    writeln('      -------------------------------- ').

g_QuestionNbJoueurs :- nl, 
    writeln('     Combien de joueurs vont participer (2 a 4 max) ? (q pour quitter)').

g_Repondre :- nl, 
    write('      --> Votre choix : ').

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

c_VoirPlateau :- c_NotImplemented.
c_IA :- c_NotImplemented.

c_CreationPartie(NbJoueurs):- 
    g_NbJoueurs(NbJoueurs),
    a_CreerJoueurs(NbJoueurs),
    b_Partie.

% ---- BOUCLES DE CHOIX ----
b_ActionsPrincipales :- 
    g_QuestionActionSouhaitee,
    repeat,
        g_Repondre, 
        read(Choix),
        (
            Choix == 1 -> c_Deplacer, !;
            Choix == 2 -> c_Eliminer, !;
            Choix == 3 -> c_Controler, !;
            Choix == 4 -> c_ConsulterPersonnagesVivant;
            Choix == 5 -> c_VoirPlateau;
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
    g_Titre,
    repeat,
        g_QuestionNbJoueurs,
        g_Repondre, 
        read(Choix),
        (
            % Ce qui est inséré doit être un chiffre entier de 2 à 4 sinon on reboucle
            integer(Choix), Choix > 1, Choix < 5 -> c_CreationPartie(Choix), !;
            Choix == 'q' -> !;
            g_ChoixNonExistant, fail
        ).

:-b_LancementJeu.
