function str = writeTransitions(prefix,datas)
% Inputs
    % prefix        : cell = {'w','s','l'} for walls, scheduling or labyrinth

    % datas : cell  = {O,D,Tr;.,.,.;}       One line : 1 transition
                                          % O  = origin state 
                                          % D  = destination state
                                          % Tr = event name
    
% Output
    % str           : String = ['...\n...\n']  contain the DESUMA formated
                                             % string to create transitions 
                                             % by reading file from DESUMA.
	str = '';
    for i=1:size(datas,1) % while we have element
        str=sprintf('%st %s%d %s%d %s\n',str,prefix,datas{i,1},prefix,datas{i,2},datas{i,3});
    end
end