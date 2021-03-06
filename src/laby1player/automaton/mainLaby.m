%% Structural main of Automata Laby
clear all
%%   Generation of a laby scenario 1
%
addpath('modelGenerator', 'optimalCommand')
modelGenerator
% Creation of a struct of the process of Laby
ProcessAutomata = struct('lab',AutomateGraph,   ...
                         'walls',AutomateGraph, ...
                         'sche',AutomateGraph);   
%% Take Information
% 1 lab
    % get transitons information
    for i = 1:length(lab.datas)
        ProcessAutomata.lab.transition(i).Name = lab.datas{i,3};
        ProcessAutomata.lab.transition(i).StateIn = lab.datas{i,1};
        ProcessAutomata.lab.transition(i).StateOut = lab.datas{i,2};
    end
        % get states information
    for i = 1:lab.nbS
        ProcessAutomata.lab.state(i).Name = i;
        ProcessAutomata.lab.state(i).Initial = (i== lab.indInit);
        ProcessAutomata.lab.state(i).Marked = (i==lab.mark);
    end
 % 2 sche   
        % get transitons information
    for i = 1:length(sche.datas)
        ProcessAutomata.sche.transition(i).Name = sche.datas{i,3};
        ProcessAutomata.sche.transition(i).StateIn = sche.datas{i,1};
        ProcessAutomata.sche.transition(i).StateOut = sche.datas{i,2};
    end
        % get states information
    for i = 1:sche.nbS
        ProcessAutomata.sche.state(i).Name = i;
        ProcessAutomata.sche.state(i).Initial = (i== sche.indInit);
        ProcessAutomata.sche.state(i).Marked = 1;%(i==sche.mark);
    end
    
% 3 walls
    for i = 1:length(walls.datas)
        ProcessAutomata.walls.transition(i).Name = walls.datas{i,3};
        ProcessAutomata.walls.transition(i).StateIn = walls.datas{i,1};
        ProcessAutomata.walls.transition(i).StateOut = walls.datas{i,2};
    end
        % get states information
    for i = 1:walls.nbS
        ProcessAutomata.walls.state(i).Name = i;
        ProcessAutomata.walls.state(i).Initial = (i== walls.indInit);
        ProcessAutomata.walls.state(i).Marked = 1;%(i==walls.mark);
    end
% 4 escape
    ProcessAutomata.escape = AutomateGraph();
    ProcessAutomata.escape = ProcessAutomata.escape.FSM2Automata('escape.fsm');
    
%% Transpose to vector Automata
    ProcessAutomata.walls = ProcessAutomata.walls.structAutomata2vectorAutomata;
    ProcessAutomata.sche = ProcessAutomata.sche.structAutomata2vectorAutomata;
    ProcessAutomata.lab = ProcessAutomata.lab.structAutomata2vectorAutomata;
	ProcessAutomata.escape = ProcessAutomata.escape.structAutomata2vectorAutomata;	
    
    
%% Product Parrallel
    ProcessAutomata.composed = ParrallelComposition(ProcessAutomata.walls, ProcessAutomata.sche);
    ProcessAutomata.composed = ParrallelComposition(ProcessAutomata.lab, ProcessAutomata.composed);
    
    
%% Clean up of process composed
    ProcessAutomata.composed = rafineAutomatonClass(ProcessAutomata.composed, ...
        {'nU', 'nD', 'nR', 'nL', 'wD', 'wR', 'U', 'D', 'R', 'L'});
    
%%  Add escape option
   % ProcessAutomata.composed = ParrallelComposition(ProcessAutomata.composed, ProcessAutomata.escape);
%% Accessibiliy 
    ProcessAutomata.composed = ProcessAutomata.composed.accessibilityAutomate;
    
%% Command add
ok=0;
while(~ok)
disp('Choisissez la composition parall�le que vous souhaitez effectu�e :')
disp('Attention au format que vous envoyer (�tats nomm�s par des chiffres et transitions communes exact au proc�d� ou sinon elle seront consid�r�s comme ind�pendantes.)')
disp('1 : La commande avec priorit�')
disp('2 : La commande avec m�moire (3x3 max sinon c est trop grand)')
disp('3 : L objectif "Atteindre la sortie"')
disp('4 : L objectif "Rester bloqu�"')
choix = input('');
if(choix<=4 && choix>=0)
    ok=1;
end
end
Objective = AutomateGraph();
if choix == 1
    
    Objective = Objective.FSM2Automata('commandPacmanPriority.fsm');
else if choix == 2
        Objective = Objective.FSM2Automata('commandPacmanMemory.fsm');
    else if choix == 3
            Objective = Objective.FSM2Automata('objectiveEscape.fsm');
        else if choix ==4
                Objective = Objective.FSM2Automata('objectiveTrapped.fsm');
            end
        end
    end
end
Objective = Objective.structAutomata2vectorAutomata;

%% Product parallel with objectives
    Command = ParrallelComposition(Objective, ProcessAutomata.composed);
    %%recherche
    Command = Command.accessibilityAutomate;
    
%% 
    finalState = find([Command.state.Marked]);
    s=[];
    if ~isempty(finalState)
        for i = 1:length(finalState) 
            [l,c]= Command.PathResearche(1,finalState(i));
            % From Optimal Command
            disp(sprintf('For the initial state %d and the final state %d :' , find([Command.state.Initial],1)  ,finalState(i)))
            word = [Command.vector(c).Name];
           for(k=1:length(word))
            if(strcmp(word(k),'R') == 1 || strcmp(word(k),'D') == 1 || strcmp(word(k),'U') == 1 || strcmp(word(k),'L') == 1) 
                %disp(sprintf('%s ',strjoin(word(k))))
                s=[s strjoin(word(k))];
            end
           end
        disp(sprintf('%s',s))
        end
                     disp(sprintf('\n'))
    else
        disp('No way out of your labyrinth')
    end
    