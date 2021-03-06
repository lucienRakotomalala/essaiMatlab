function [initialIndice,markedStatesIndices,transitionsDatas, numberOfStates] = AutomatonWallsContraintsCreation (verticalsWalls,horizontalsWalls,FirstWallsMove)
% AUTOMATONWALLSCONTRAINTSCREATION Creates the automaton that defines the every possibles moves in all the walls configuration.
% Inputs :
%       verticalsWalls       : int  = [...]     the verticals walls matrix
%       horizontalsWalls     : int  = [...]     the horizontal walls matrix
%
%       FirstWallsMove       : char  = [x]      x = 'v' : the first walls
%                                                   move is vertical.
%                                               x = 'h' : the first walls
%                                                   move is horizontal.
% Output :
%       initialIndice        : int  = [x]       x = indice of the initial state
%       markedStatesIndices  : int = [.,.,...]  indice of the marked states   
%       transitionsDatas     : cell  = {O,D,Tr;.,.,.;} One line : 1 transition
%                                               O  = origin state 
%                                               D  = destination state
%                                               Tr = event name
%       numberOfStates   : int  = [x]           x  = number of states of the
%                                               automaton

labySize = max(size(verticalsWalls));
% number Of States
numberOfStates = labySize*2;
%initial Indice
initialIndice = strcmp(FirstWallsMove,'v')*1 + strcmp(FirstWallsMove,'h')*2;
% marked States Indices
markedStatesIndices = 0;% a faire 
Vwalls = verticalsWalls;
Hwalls = horizontalsWalls;
% 
INDICE = 0;
transitionsDatas = cell(1,3);
for i = 1 : numberOfStates %all states
    [U,D,L,R] = generer_lab(Hwalls,Vwalls);
        % U : Up ; D : Down ; L:Left ; R:Right
        % U(y,x)    =1 : can move from state x to state y
        %           =0 : can't move
        % same for D, L and R
        [~,oU]=find(U);        
        [~,oD]=find(D);
        [~,oL]=find(L);
        [~,oR]=find(R);
        %% find the impossible moves
        noU=find(sum(U)==0);        
        noD=find(sum(D)==0);
        noL=find(sum(L)==0);
        noR=find(sum(R)==0);
        
        
        str = cell(1,max(size(oU))+max(size(oD))+max(size(oL))+max(size(oR)));
        l=0;        
        %up 
        if(~isempty(oU))
            for k = 1 : max(size(oU))
                str{k}=sprintf('U%d',oU(k));
                
            end
        end
        %down
        if(~isempty(oD))                
            l = max(size(oU));
            for k = 1 : max(size(oD))
                str{l+k}=sprintf('D%d',oD(k));
            end
        end
        %left
        if(~isempty(oL))
            l = l+max(size(oD));
            for k = 1 : max(size(oL))
                str{l+k}=sprintf('L%d',oL(k));
            end
        end
        % right
        if(~isempty(oR))
            l = l+max(size(oL));
            for k = 1 : max(size(oR))
                str{l+k}=sprintf('R%d',oR(k));
            end
        end
        %%  impossibles moves
        % not up 
        if(~isempty(noU))
            l = l+max(size(oR));
            for k = 1 : max(size(noU))
                str{l+k}=sprintf('nU%d',noU(k));
                
            end
        end
        % not down
        if(~isempty(noL))  
            l = l+max(size(noU));
            for k = 1 : max(size(noD))
                str{l+k}=sprintf('nD%d',noD(k));
            end
        end
        % not left
        if(~isempty(noL))
            l = l+max(size(noD));
            for k = 1 : max(size(noL))
                str{l+k}=sprintf('nL%d',noL(k));
            end
        end
        % not right
        if(~isempty(noR))
            l = l+max(size(noL));
            for k = 1 : max(size(noR))
                str{l+k}=sprintf('nR%d',noR(k));
            end
        end
        
        
        
        % write into output
        for h = 1:max(size(str))
            j = INDICE + h;
            transitionsDatas{j,1}=i;
            transitionsDatas{j,2}=i;
            transitionsDatas{j,3}=str{h}; % maybe x/y switch
        end
        transitionsDatas{j+1,1}=i;
        transitionsDatas{j+1,2}=mod(i,numberOfStates)+1;
        if mod(i,2)==0
            % mv down
            Vwalls = [Vwalls(end,:); Vwalls(1:end-1,:) ];
            transitionsDatas{j+1,3}='wD'; 

        else
            % mh right
            Hwalls = [Hwalls(:,end), Hwalls(:,1:end-1) ];
            transitionsDatas{j+1,3}='wR'; % maybe x/y switch

        end
        INDICE = INDICE+max(size(str))+1;
end

end