function Video = CreatePituresAndVideo_textured(n, escape_i, labyState )
%%
escape_i= labyInit.escape_i

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% VISUALISATION OF THE MAZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% save state as one matrix
% > in a case : 0 nothing; 1 : wall ; 2 : ghost ; 3: pacman; 4 : escape 
%%%%%%%%%  LABYSTATE  %%%%%%%%%%%
%            obj.out{1} = zeros(1,2); % pacman [x y]
%            obj.out{2} = zeros(1,2); % ghost  [x y]
%            obj.out{3} = zeros(size(obj.modelLaby.presentState.wallsV)); %  Vertical Walls
%            obj.out{4} = zeros(size(obj.modelLaby.presentState.wallsH)); %  Horizontal Walls
%            obj.out{5} = 0 ;         % caught
%            obj.out{6} = 0 ;         % escape
%            obj.out{7} = zeros(1,4); % Walls around pacman [Up Down Left Right]
%            obj.out{8} = zeros(1,4); % Walls around ghost  [Up Down Left Right]
%            obj.out{9} = zeros(1,4); % Ghost sees pacman   [Up Down Left Right]
Ms = max(size(labyState{1,3}));
N = 2*Ms+1; % total size of maze
Visu = zeros(N,N,n);

%pacman (out{1} : pacman [x y]) in Visu 3 = pacman
    
% escape (out{2} : ghost [x y]) in Visu 2 = ghost


Visu(2:2:N-1,1,:)=5;                 % Vertical left border with size 100
Visu(3:2:N-2,1,:)=26;                % Vertical left border with size 50
Visu(2:2:N-1,N,:)=7;                 % Vertical Right border with size 100
Visu(3:2:N-2,N,:)=24;                % Vertical Right border with size 50
Visu(1,2:2:N-1,:)=6;                 % Horizontal top border with 100
Visu(1,3:2:N-2,:)=23;                 % Horizontal top border with size 50
Visu(N,2:2:N-1,:)=8;                 % Horizontal lower border with size 100
Visu(N,3:2:N-2,:)=25;                % Horizontal lower border with size 50
Visu(1,1,:)=9;                       % Border Corner NW
Visu(N,1,:)=12;                      % Border Corner SW
Visu(1,N,:)=10;                      % Border Corner NE
Visu(N,N,:)=11;                      % Border Corner SE


%Visu(:,[1 N],:)=1; % Horizontal sides

 % Filling wall intersections
[~,~,iWallMidd] = find((2:N-1).*mod((2:N-1),2));

iCase =  2:2:N-1;
iVWall = 3:2:N-2;
iHWall = 2:2:N-1;

for i = 1:n
    %walls
    %Vertical walls
    
    Visu(iHWall, iVWall,i)=15;
    [xmv, ymv]=find(labyState{i,3});
    xav = xmv.*2;
    yav = ymv.*2+1;
    %Horizontal walls
    Visu(iVWall,iHWall,i)=13;
    [xmh, ymh]=find(labyState{i,4});
    xah = xmh.*2+1;
    yah = ymh.*2;
    for ee = 1:max(size(yav))
        Visu(xav(ee),yav(ee),i) = 16;
    end
        for ee = 1:max(size(xah))
            Visu(xah(ee),yah(ee),i) = 14;
        end
  
    pacpos =  labyState{i,1}*[2 0; 0 2]; % adapt position and flip
    
    Visu(pacpos(1),pacpos(2),i)=1;  % Pacman Position
    escapePos = escape_i{1}*[2 0; 0 2];
        if pacpos==escapePos
            Visu(escapePos(1),escapePos(2),:)=4;     % Pacman on Escape
        else
             Visu(escapePos(1),escapePos(2),:)=3; % Escape Position
        end
       
%
    
    %ghost (out{2} : ghost [x y]) in Visu 2 = ghost
    ghostpos =  labyState{i,2}*[2 0; 0 2]; % adapt position and flip
    Visu(ghostpos(1),ghostpos(2),i)=2;
end
 for i = 3:2:N-2
     for j = 3:2:N-2
 if (Visu(i,j-1,:)==16 + Visu(i,j+1,:)==16 + Visu(i-1,j,:)==14 + Visu(i+1,j,:)==14)==0
            Visu(i,j,:)= 17; %% Middle Wall is Empty
        else if (Visu(i,j-1,:)==16 + Visu(i,j+1,:)==16 + Visu(i-1,j,:)==14 + Visu(i+1,j,:)==14)>3
                Visu(i,j,:)=18; %% Middle Wall is Full
            else if ( Visu(i-1,j,:)==14 + Visu(i,j+1,:)==16)>0
                    Visu(i,j,:)= 19; % Wall Middle NW
                else if (Visu(i+1,j,:)==14 + Visu(i,j+1,:)==16)>0
                           Visu(i,j,:)= 20; % Wall Middle NE
                    else if (Visu(i-1,j,:)==1 + Visu(i,j-1,:)==16)>0
                            Visu(i,j,:)=21; % Wall Middle SW
                        else if (Visu(i+1,j,:)==16 + Visu(i,j-1,:)==14)>0
                                Visu(i,j,:)=22; % Wall Middle SE
                            end
                        end
                    end
                end
            end
 end
     end
 end
 
                        
                
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PICTURES AND VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extension de l'affichage
% pour tout n
% 1. faire une 11x11x3 = 11x11
% 2. transformer la 11x11x3 (empty,walls,ghost,pacman,escape)
% 3. etendre la 11x11*3 avec kron
    
resImg      = 100;  %resolution of image in pixel size = resImg*(2*n+1)
%%
border          = imread('texture/border.png');
border_corner   = imread('texture/border_corner.png');
pacman          = imread('texture/pacman.png');
wall            = imread('texture/wall.png');
wall_middle_full= imread('texture/wall_middle_full.png');
wall_middle_half= imread('texture/wall_middle_half.png');
%%
i = 0;
j = 0;
while j < max
while i< 100
    
    
    
    
end
%%
% cim image :
imgs        = zeros(resImg*Ms + Ms/2-1 , resImg*N , 3 , n); % n rgb pictures with ( x  pixels)
rgbImg      = zeros(N , N , 3);

%%
for i = 1 : n
    %1.11x11x3
    rgbImg(:,:,1)=repmat(Visu(:,:,i),[1 1 1]);
    
    %2.color
    rgbImg = setColor(rgbImg,Visu(:,:,i),emptyColor,0);
    rgbImg = setColor(rgbImg,Visu(:,:,i),wallsColor,1);
    rgbImg = setColor(rgbImg,Visu(:,:,i),ghostColor,2);
    rgbImg = setColor(rgbImg,Visu(:,:,i),pacmanColor,3);
    rgbImg = setColor(rgbImg,Visu(:,:,i),escapeColor,4);


    %3.kron
    imgs(:,:,1,i) = kron(rgbImg(:,:,1),ones(resImg,resImg));
    imgs(:,:,2,i) = kron(rgbImg(:,:,2),ones(resImg,resImg));
    imgs(:,:,3,i) = kron(rgbImg(:,:,3),ones(resImg,resImg));
end
% %% test 
% stepToSee = 1; % range 1 : n
% imtest= imgs(:,:,:,stepToSee);
% figure(1)
% imshow(imtest);


%% save as pictures AND video 
repo = strcat('./data/',datestr(now,'yyyy-mm-dd_HH-MM'));
mkdir(repo);
save(strcat(repo,'/state'),'labyState');
video = VideoWriter(strcat(repo,'/video.avi'),'Motion JPEG AVI');
open(video)
for i = 1 : n
    name = strcat(repo,'/Simu_',int2str(i),'.jpg');
    imwrite(imgs(:,:,:,i),name,'jpg'); 
    %A = imread(name);
    for j = 1 : 20
        writeVideo(video,imgs(:,:,:,i));
    end
end
close(video)

 
%imgs(indP)
% %% create video from simulation 
% 
% % Create a |VideoWriter| object for a new uncompressed AVI file for RGB24 video.

% 
% % Open the file for writing.
% 
% 
% % Write the image in |A| to the video file.
%
% 
% % Close the file.
% 

%% Trie des cases pertinentes
% i impair  &   j impair    => +
% i impair  &   j pair      => |
% i pair    &   j impair    => -
% i pair    &   j pair      => pas concern?
% A = ones(12);
% 
% for i = 1:12 % x axis
%     for j = 1 : 12 % y axis
%         if ( mod(i,2)==1 || mod(j,2)==1 )% si au moins un des 2 est impart
%             if(mod(i,2)==1)
%                 A(j,i)
%             end
%             A(i,j)
%         end
%     end
% end

end

