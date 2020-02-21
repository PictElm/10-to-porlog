% % ETAT

% % CASES
% % PLATEAU

% % ADJACENCE DES CASES 
% % POSITION PERSONNAGE

% % PERSONNAGE
% % ETAT DE MORT

% % ACTIONS PERSONNAGE
% % COUPS JOUABLES

% % CARTES EN MAIN : ton serial killer et les 3 cibles

% %action().
% %action().
% %tourSuivant().

% Liste des joueurs 
% [
%     [personnageKiller,personnageToKill1,personnageToKill2,personnageToKill3], %Joueur0
%     [personnageKiller,personnageToKill1,personnageToKill2,personnageToKill3], %Joueur1
%     [personnageKiller,personnageToKill1,personnageToKill2,personnageToKill3], %Joueur2
%     ...
% ]

% case(X,Y,EstSniper).

% % à asserter lorsqu'un joueur le met inchallah
% policier(1,(X,Y),IndexKiller). OU policier(17,(X,Y),IndexKiller).
% ...

% % critère d'adjacence : distanceManhattan = 1
% % critère positionnement sur la ligne : x1 - x2 = 0

% % Actions
% deplacer(Personnage,Case).
% eliminer(Personnage1,Personnage2).
% controlerIdentite(Personnage).

% % Controles
% prisEnFlag(Personnage). %check si aucun policier ne voit le futur crime

% evacuer()

%-----------------------------------------------------------%





