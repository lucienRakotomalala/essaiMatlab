function str = writeStates(prefix,nbrOfStates,initialIndice,markedStatesIndices)
% Inputs
    % prefix        : cell = {'w','s','l'} for walls, scheduling or labyrinth
    % nbrOfStates   : int  = [x]         x  = number of states of the
                                            % automaton
    % initialIndice : int  = [x]         x = indice of the initial state
    % markedStatesIndices : int = [.,.,...] indice of the marked states 
    
% Output
    % str           : String = ['...\n...\n']  contain the DESUMA formated
                                             % string to create states by 
                                             % reading file from DESUMA.
                                  str ='';  
                                
                     
str = sprintf('%ss %s%d -I \n',str,prefix,initialIndice);

                           for i = 1:nbrOfStates
                                if (isempty(find(i == markedStatesIndices,1)) == 0)&&(i  ~= initialIndice)
                                       str = sprintf('%ss %s%d -M \n',str,prefix,i);
                                elseif (i  ~= initialIndice)
                                       str = sprintf('%ss %s%d \n',str,prefix,i);
                                end
                               
                      
                           end
                           
end
